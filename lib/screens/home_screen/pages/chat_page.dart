import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/api.dart';
import '../../../app_routes.dart';
import '../../../common/models/models.dart';
import '../../../data/chat/spa_chat_adapters.dart';
import '../../../theme.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_favorite_group_details_dialog.dart';
import '../widgets/chat_favorite_group_picker_dialog.dart';
import '../widgets/chat_message_attachments.dart';
import '../widgets/chat_procedure_picker_dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = InMemoryChatController();
  final _imagePicker = ImagePicker();
  bool _initialMessagesSynced = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialMessagesSynced) {
      return;
    }
    _initialMessagesSynced = true;
    unawaited(_syncMessages(context.read<ChatBloc>().state.messages));
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _syncMessages(List<SpaChatMessage> messages) {
    return _chatController.setMessages(
      messages.map((message) => message.toChatMessage()).toList(),
    );
  }

  Future<void> _showAttachmentPicker() async {
    final state = context.read<ChatBloc>().state;
    if (state.isSending || state.isUploading) {
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
    if (image != null && mounted) {
      context.read<ChatBloc>().add(ChatImageSelected(image.path));
    }
  }

  Future<void> _pickProcedure() async {
    try {
      final procedures = await ApiScope.of(context).spaProcedures.getAll();
      if (!mounted) {
        return;
      }
      final procedure = await showDialog<SpaProcedure>(
        context: context,
        builder: (context) => ProcedurePickerDialog(procedures: procedures),
      );
      if (procedure != null && mounted) {
        context.read<ChatBloc>().add(ChatProcedureSelected(procedure));
      }
    } catch (error) {
      _showError(_errorText(error));
    }
  }

  Future<void> _pickFavoriteGroup() async {
    try {
      final groups = await ApiScope.of(context).favoriteGroups.getAll();
      if (!mounted) {
        return;
      }
      final group = await showDialog<ApiFavoriteGroup>(
        context: context,
        builder: (context) => ChatFavoriteGroupPickerDialog(groups: groups),
      );
      if (group != null && mounted) {
        context.read<ChatBloc>().add(ChatFavoriteGroupSelected(group));
      }
    } catch (error) {
      _showError(_errorText(error));
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
          final group = await ApiScope.of(
            context,
          ).favoriteGroups.getById(groupId);
          if (mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) =>
                  ChatFavoriteGroupDetailsDialog(group: group),
            );
          }
        } catch (error) {
          _showError(_errorText(error));
        }
      case SpaChatAttachmentType.image:
        final fileId = attachment.fileId;
        if (fileId == null) {
          return;
        }
        try {
          final file = await ApiScope.of(context).files.getById(fileId);
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
          _showError(_errorText(error));
        }
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _errorText(Object error) {
    return error is ApiException
        ? error.message
        : 'Не удалось выполнить запрос. Проверьте подключение к интернету.';
  }

  Future<User> _resolveUser(String id) async {
    final state = context.read<ChatBloc>().state;
    return User(
      id: id,
      name:
          state.participants[id]?.name ??
          (id == state.currentUserId ? state.currentUserName : null) ??
          'Пользователь',
    );
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
    final state = context.watch<ChatBloc>().state;
    return Composer(
      hintText: state.isSending
          ? 'Отправляем сообщение…'
          : state.isUploading
          ? 'Загружаем файл…'
          : 'Сообщение администратору',
      allowEmptyMessage: state.draftAttachments.isNotEmpty,
      sendButtonVisibilityMode: SendButtonVisibilityMode.always,
      topWidget: state.draftAttachments.isEmpty
          ? null
          : DraftChatAttachments(
              attachments: state.draftAttachments,
              onRemove: (attachment) => context.read<ChatBloc>().add(
                ChatDraftAttachmentRemoved(attachment),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) =>
              previous.messages != current.messages,
          listener: (_, state) => unawaited(_syncMessages(state.messages)),
        ),
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (_, state) => _showError(state.errorMessage!),
        ),
      ],
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.status == ChatStatus.initial ||
              state.status == ChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ChatStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Не удалось загрузить чат',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ChatBloc>().add(const ChatRetried()),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _ConnectionBadge(state: state.wsState),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Chat(
                  chatController: _chatController,
                  currentUserId: state.currentUserId!,
                  onMessageSend: (text) =>
                      context.read<ChatBloc>().add(ChatMessageSubmitted(text)),
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
        },
      ),
    );
  }
}

enum _AttachmentAction { image, procedure, favoriteGroup }

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.state});

  final ChatWsConnectionState state;

  @override
  Widget build(BuildContext context) {
    final connected = state == ChatWsConnectionState.connected;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (connected ? SpaThemeColors.blue : Colors.grey).withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          connected ? 'Администратор онлайн' : 'Подключение…',
          style: TextStyle(
            color: connected ? SpaThemeColors.blueDark : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
