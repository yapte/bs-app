import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app_routes.dart';
import '../../../data/catalog/catalog_mock_data.dart';
import '../../../data/chat/mock_spa_chat_service.dart';
import '../../../data/chat/spa_chat_adapters.dart';
import '../../../data/chat/spa_chat_models.dart';
import '../../../theme.dart';
import '../widgets/chat_message_attachments.dart';
import '../widgets/chat_procedure_picker_dialog.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.draftProcedureId});

  final String? draftProcedureId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final MockSpaChatService _chatService;
  final _imagePicker = ImagePicker();
  final _draftAttachments = <SpaChatAttachment>[];

  @override
  void initState() {
    super.initState();
    _chatService = MockSpaChatService();
    _addInitialProcedureDraft();
  }

  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
  }

  Future<void> _showAttachmentPicker() async {
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
      case null:
        break;
    }
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    await _chatService.sendImageAttachment(
      localPath: image.path,
      fileName: image.name,
    );
  }

  Future<void> _pickProcedure() async {
    final selection = await showDialog<ProcedureSelection>(
      context: context,
      builder: (context) => const ProcedurePickerDialog(),
    );

    if (selection == null) {
      return;
    }

    final attachment = _chatService.createProcedureAttachment(
      procedure: selection.procedure,
      groupTitle: selection.group.title,
    );

    setState(() => _draftAttachments.add(attachment));
  }

  void _openAttachment(SpaChatAttachment attachment) {
    if (attachment.type != SpaChatAttachmentType.procedure ||
        attachment.procedureId == null) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamed(AppRoutes.procedureDetails(attachment.procedureId!));
  }

  void _addInitialProcedureDraft() {
    final procedureId = widget.draftProcedureId;
    if (procedureId == null) {
      return;
    }

    final entry = findProcedureInCatalog(procedureId);
    if (entry == null) {
      return;
    }

    _draftAttachments.add(
      _chatService.createProcedureAttachment(
        procedure: entry.procedure,
        groupTitle: entry.group.title,
      ),
    );
  }

  void _removeDraftAttachment(SpaChatAttachment attachment) {
    setState(() => _draftAttachments.remove(attachment));
  }

  void _sendMessage(String text) {
    final attachments = List<SpaChatAttachment>.of(_draftAttachments);
    if (attachments.isNotEmpty) {
      setState(_draftAttachments.clear);
    }

    unawaited(_chatService.sendClientMessage(text, attachments: attachments));
  }

  Widget _buildTextMessage(
    BuildContext context,
    TextMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final attachments = spaChatAttachmentsFromMetadata(message.metadata);

    if (attachments.isEmpty) {
      return SimpleTextMessage(message: message, index: index);
    }

    return Column(
      crossAxisAlignment: isSentByMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        SimpleTextMessage(message: message, index: index),
        const SizedBox(height: 6),
        MessageAttachmentsList(
          attachments: attachments,
          isSentByMe: isSentByMe,
          onAttachmentTap: _openAttachment,
        ),
      ],
    );
  }

  Widget _buildComposer(BuildContext context) {
    return Composer(
      hintText: 'Сообщение администратору',
      allowEmptyMessage: _draftAttachments.isNotEmpty,
      sendButtonVisibilityMode: SendButtonVisibilityMode.always,
      topWidget: _draftAttachments.isEmpty
          ? null
          : DraftProcedureAttachments(
              attachments: _draftAttachments,
              onRemove: _removeDraftAttachment,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            chatController: _chatService.chatController,
            currentUserId: MockSpaChatService.clientId,
            onMessageSend: _sendMessage,
            onAttachmentTap: _showAttachmentPicker,
            resolveUser: (UserID id) => _chatService.resolveUser(id),
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

enum _AttachmentAction { image, procedure }

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
