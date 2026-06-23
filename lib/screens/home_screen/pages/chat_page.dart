import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/api.dart';
import '../../../app_routes.dart';
import '../../../common/models/models.dart';
import '../../../data/chat/spa_chat_adapters.dart';
import '../../../theme.dart';
import '../widgets/chat_favorite_group_details_dialog.dart';
import '../widgets/chat_favorite_group_picker_dialog.dart';
import '../widgets/chat_message_attachments.dart';
import '../widgets/chat_procedure_picker_dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.draftProcedureId});

  final String? draftProcedureId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = InMemoryChatController();
  final _imagePicker = ImagePicker();
  final _draftAttachments = <SpaChatAttachment>[];
  final _participants = <String, SpaChatParticipant>{};
  final _messageIds = <String>{};

  ApiServices? _api;
  SpaChat? _chat;
  String? _currentUserId;
  String? _currentUserName;
  Timer? _pollTimer;
  bool _initialized = false;
  bool _loading = true;
  bool _polling = false;
  bool _sending = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;
    _api = ApiScope.of(context);
    unawaited(_loadChat());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _loadChat() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _api!.auth.getProfile();
      final chat = profile.role == 'guest'
          ? await _api!.chats.createOrGet()
          : await _getFirstStaffChat();
      final page = await _api!.chats.getMessages(chat.id, limit: 100);

      _currentUserId = profile.id.toString();
      _currentUserName = profile.name;
      _chat = chat;
      _participants
        ..clear()
        ..addEntries(
          chat.participants.map(
            (participant) => MapEntry(participant.id, participant),
          ),
        );
      _participants.putIfAbsent(
        _currentUserId!,
        () => SpaChatParticipant(
          id: _currentUserId!,
          name: profile.name,
          role: profile.role == 'guest'
              ? SpaChatParticipantRole.client
              : SpaChatParticipantRole.admin,
        ),
      );

      for (final message in page.items) {
        await _insertMessage(message);
      }
      await _markLatestRead(page.items);
      await _addInitialProcedureDraft();

      if (!mounted) {
        return;
      }
      setState(() => _loading = false);
      _pollTimer?.cancel();
      _pollTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => unawaited(_pollMessages()),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorMessage = _errorText(error);
      });
    }
  }

  Future<SpaChat> _getFirstStaffChat() async {
    final chats = await _api!.chats.getAll(
      query: const PageQuery(
        sort: 'lastMessageAt',
        sortDirection: 'desc',
        itemsPerPage: 1,
      ),
      status: 'open',
    );
    if (chats.items.isEmpty) {
      throw const ApiException(
        statusCode: 404,
        code: 'CHAT_NOT_FOUND',
        message: 'Нет доступных открытых чатов',
      );
    }
    return chats.items.first;
  }

  Future<void> _pollMessages() async {
    final chat = _chat;
    if (chat == null || _polling || _messageIds.isEmpty) {
      return;
    }
    _polling = true;
    try {
      final lastId = _messageIds
          .map(int.tryParse)
          .whereType<int>()
          .fold<int>(0, (latest, id) => id > latest ? id : latest);
      final page = await _api!.chats.getMessages(
        chat.id,
        limit: 100,
        afterId: lastId,
      );
      for (final message in page.items) {
        await _insertMessage(message);
      }
      await _markLatestRead(page.items);
    } catch (_) {
      // A temporary polling failure should not take the chat screen down.
    } finally {
      _polling = false;
    }
  }

  Future<void> _insertMessage(SpaChatMessage message) async {
    if (!_messageIds.add(message.id)) {
      return;
    }
    await _chatController.insertMessage(message.toChatMessage());
  }

  Future<void> _markLatestRead(List<SpaChatMessage> messages) async {
    if (messages.isEmpty || _chat == null) {
      return;
    }
    final latestId = messages
        .map((message) => int.tryParse(message.id))
        .whereType<int>()
        .fold<int>(0, (latest, id) => id > latest ? id : latest);
    if (latestId > 0) {
      await _api!.chats.markRead(_chat!.id, latestId);
    }
  }

  Future<void> _showAttachmentPicker() async {
    if (_sending) {
      return;
    }
    final selectedAction = await showModalBottomSheet<_AttachmentAction>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.image_outlined,
                  color: SpaThemeColors.blue,
                ),
                title: const Text('Картинка из галереи'),
                onTap: () => Navigator.of(context).pop(_AttachmentAction.image),
              ),
              ListTile(
                leading: const Icon(
                  Icons.spa_outlined,
                  color: SpaThemeColors.gold,
                ),
                title: const Text('Процедура из каталога'),
                onTap: () =>
                    Navigator.of(context).pop(_AttachmentAction.procedure),
              ),
              ListTile(
                leading: const Icon(
                  Icons.folder_special_outlined,
                  color: SpaThemeColors.gold,
                ),
                title: const Text('Группа избранного'),
                onTap: () =>
                    Navigator.of(context).pop(_AttachmentAction.favoriteGroup),
              ),
            ],
          ),
        ),
      ),
    );

    switch (selectedAction) {
      case _AttachmentAction.image:
        await _pickImage();
      case _AttachmentAction.procedure:
        await _pickProcedure();
      case _AttachmentAction.favoriteGroup:
        await _pickFavoriteGroup();
      case null:
        break;
    }
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    try {
      final file = await _api!.files.upload(image.path);
      if (!mounted) {
        return;
      }
      setState(() {
        _draftAttachments.add(
          SpaChatAttachment(
            id: 'draft-file-${file.id}',
            type: SpaChatAttachmentType.image,
            title: file.originalName,
            subtitle: file.mimeType,
            fileId: file.id,
            imageUrl: file.url,
          ),
        );
      });
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _pickProcedure() async {
    try {
      final procedures = await _api!.spaProcedures.getAll();
      if (!mounted) {
        return;
      }
      final procedure = await showDialog<SpaProcedure>(
        context: context,
        builder: (context) => ProcedurePickerDialog(procedures: procedures),
      );
      if (procedure == null || !mounted) {
        return;
      }
      setState(() {
        _draftAttachments.add(
          SpaChatAttachment(
            id: 'draft-procedure-${procedure.id}',
            type: SpaChatAttachmentType.procedure,
            title: procedure.name,
            subtitle:
                '${procedure.durationMinutes} мин · '
                '${procedure.price.toStringAsFixed(0)} ₽',
            procedureId: procedure.slug ?? procedure.id.toString(),
            spaProcedureId: procedure.id,
          ),
        );
      });
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _pickFavoriteGroup() async {
    try {
      final groups = await _api!.favoriteGroups.getAll();
      if (!mounted) {
        return;
      }
      final group = await showDialog<ApiFavoriteGroup>(
        context: context,
        builder: (context) => ChatFavoriteGroupPickerDialog(groups: groups),
      );
      if (group == null || !mounted) {
        return;
      }
      setState(() {
        _draftAttachments.add(
          SpaChatAttachment(
            id: 'draft-group-${group.id}',
            type: SpaChatAttachmentType.favoriteGroup,
            title: group.title,
            subtitle: '${group.procedures.length} процедур в избранном',
            favoriteGroupId: group.id.toString(),
            favoriteGroupApiId: group.id,
          ),
        );
      });
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _openAttachment(SpaChatAttachment attachment) async {
    switch (attachment.type) {
      case SpaChatAttachmentType.procedure:
        final procedureId = attachment.procedureId;
        if (procedureId != null && mounted) {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.procedureDetails(procedureId));
        }
      case SpaChatAttachmentType.favoriteGroup:
        final groupId = attachment.favoriteGroupApiId;
        if (groupId == null) {
          return;
        }
        try {
          final group = await _api!.favoriteGroups.getById(groupId);
          if (mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) =>
                  ChatFavoriteGroupDetailsDialog(group: group),
            );
          }
        } catch (error) {
          _showError(error);
        }
      case SpaChatAttachmentType.image:
        final fileId = attachment.fileId;
        if (fileId == null) {
          return;
        }
        try {
          final file = await _api!.files.getById(fileId);
          if (!mounted) {
            return;
          }
          await showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              child: InteractiveViewer(
                child: Image.network(
                  file.url,
                  errorBuilder: (_, _, _) => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Не удалось загрузить изображение'),
                  ),
                ),
              ),
            ),
          );
        } catch (error) {
          _showError(error);
        }
    }
  }

  Future<void> _addInitialProcedureDraft() async {
    final slug = widget.draftProcedureId;
    if (slug == null) {
      return;
    }
    final procedures = await _api!.spaProcedures.getAll();
    final procedure = procedures.where((item) => item.slug == slug).firstOrNull;
    if (procedure == null) {
      return;
    }
    _draftAttachments.add(
      SpaChatAttachment(
        id: 'draft-procedure-${procedure.id}',
        type: SpaChatAttachmentType.procedure,
        title: procedure.name,
        subtitle:
            '${procedure.durationMinutes} мин · '
            '${procedure.price.toStringAsFixed(0)} ₽',
        procedureId: procedure.slug ?? procedure.id.toString(),
        spaProcedureId: procedure.id,
      ),
    );
  }

  void _removeDraftAttachment(SpaChatAttachment attachment) {
    setState(() => _draftAttachments.remove(attachment));
  }

  void _sendMessage(String text) {
    unawaited(_sendMessageAsync(text));
  }

  Future<void> _sendMessageAsync(String text) async {
    final chat = _chat;
    if (chat == null || _sending) {
      return;
    }
    final attachments = List<SpaChatAttachment>.of(_draftAttachments);
    if (text.trim().isEmpty && attachments.isEmpty) {
      return;
    }

    setState(() {
      _sending = true;
      _draftAttachments.clear();
    });
    try {
      final message = await _api!.chats.sendMessage(
        chat.id,
        text: text,
        attachments: attachments,
      );
      await _insertMessage(message);
      await _markLatestRead([message]);
    } catch (error) {
      if (mounted) {
        setState(() => _draftAttachments.insertAll(0, attachments));
        _showError(error);
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<User> _resolveUser(String id) async {
    final participant = _participants[id];
    return User(
      id: id,
      name:
          participant?.name ??
          (id == _currentUserId ? _currentUserName : null) ??
          'Пользователь',
    );
  }

  void _showError(Object error) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorText(error))));
  }

  String _errorText(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Не удалось выполнить запрос. Проверьте подключение к интернету.';
  }

  Widget _buildTextMessage(
    BuildContext context,
    TextMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final attachments = spaChatAttachmentsFromMetadata(message.metadata);
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;
    final bubble = attachments.isEmpty
        ? SimpleTextMessage(
            message: message,
            index: index,
            constraints: BoxConstraints(maxWidth: maxWidth),
          )
        : Column(
            crossAxisAlignment: isSentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.text.isNotEmpty)
                SimpleTextMessage(
                  message: message,
                  index: index,
                  constraints: BoxConstraints(maxWidth: maxWidth),
                ),
              if (message.text.isNotEmpty) const SizedBox(height: 6),
              MessageAttachmentsList(
                attachments: attachments,
                isSentByMe: isSentByMe,
                onAttachmentTap: (attachment) =>
                    unawaited(_openAttachment(attachment)),
              ),
            ],
          );

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: bubble,
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return Composer(
      hintText: _sending ? 'Отправляем сообщение…' : 'Сообщение администратору',
      allowEmptyMessage: _draftAttachments.isNotEmpty,
      sendButtonVisibilityMode: SendButtonVisibilityMode.always,
      topWidget: _draftAttachments.isEmpty
          ? null
          : DraftChatAttachments(
              attachments: _draftAttachments,
              onRemove: _removeDraftAttachment,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadChat,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Чат',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: _OnlineBadge(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Chat(
            chatController: _chatController,
            currentUserId: _currentUserId!,
            onMessageSend: _sendMessage,
            onAttachmentTap: _showAttachmentPicker,
            resolveUser: _resolveUser,
            backgroundColor: SpaThemeColors.paper,
            builders: Builders(
              textMessageBuilder: _buildTextMessage,
              composerBuilder: _buildComposer,
            ),
          ),
        ),
      ],
    );
  }
}

enum _AttachmentAction { image, procedure, favoriteGroup }

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SpaThemeColors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Администратор онлайн',
          style: TextStyle(
            color: SpaThemeColors.blueDark,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
