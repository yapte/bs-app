import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../catalog/catalog_models.dart';
import 'spa_chat_adapters.dart';
import 'spa_chat_models.dart';

class MockSpaChatService {
  MockSpaChatService() {
    _controller = InMemoryChatController(
      messages: _state.messages
          .map((message) => message.toChatMessage())
          .toList(),
    );
  }

  static const clientId = 'client';
  static const adminId = 'admin';

  late final InMemoryChatController _controller;

  final _participants = const [
    SpaChatParticipant(
      id: clientId,
      name: 'Вы',
      role: SpaChatParticipantRole.client,
    ),
    SpaChatParticipant(
      id: adminId,
      name: 'Администратор СПА',
      role: SpaChatParticipantRole.admin,
    ),
  ];

  late SpaChatState _state = SpaChatState(
    participants: _participants,
    messages: [
      SpaChatMessage(
        id: 'message-1',
        authorId: adminId,
        text:
            'Здравствуйте! Я администратор СПА «Большие соли». Помогу подобрать процедуру или уточнить запись.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      SpaChatMessage(
        id: 'message-2',
        authorId: clientId,
        text: 'Добрый день! Хочу узнать, есть ли свободные окна на массаж.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 16)),
      ),
      SpaChatMessage(
        id: 'message-3',
        authorId: adminId,
        text:
            'Сегодня есть свободное время после 17:00. Могу предложить САРГА-терапию или вакуумный гидромассаж.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
      ),
    ],
  );

  ChatController get chatController => _controller;

  SpaChatState get state => _state;

  Future<User> resolveUser(String id) async {
    final participant = _participants.firstWhere(
      (participant) => participant.id == id,
      orElse: () => SpaChatParticipant(
        id: id,
        name: 'Гость',
        role: SpaChatParticipantRole.client,
      ),
    );

    return participant.toChatUser();
  }

  Future<void> sendClientMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    final message = SpaChatMessage(
      id: _nextMessageId(),
      authorId: clientId,
      text: trimmedText,
      createdAt: DateTime.now(),
    );

    _appendMessage(message);
    await _controller.insertMessage(message.toChatMessage());
    unawaited(_sendAdminReply());
  }

  Future<void> sendImageAttachment({
    required String localPath,
    required String fileName,
  }) async {
    final message = SpaChatMessage(
      id: _nextMessageId(),
      authorId: clientId,
      text: 'Прикрепляю изображение',
      createdAt: DateTime.now(),
      attachments: [
        SpaChatAttachment(
          id: _nextAttachmentId(),
          type: SpaChatAttachmentType.image,
          title: fileName,
          subtitle: 'Изображение из галереи',
          localPath: localPath,
        ),
      ],
    );

    _appendMessage(message);
    await _controller.insertMessage(message.toChatMessage());
  }

  Future<void> sendProcedureAttachment({
    required Product product,
    required String groupId,
    required String groupTitle,
  }) async {
    final message = SpaChatMessage(
      id: _nextMessageId(),
      authorId: clientId,
      text: 'Интересует эта процедура',
      createdAt: DateTime.now(),
      attachments: [
        SpaChatAttachment(
          id: _nextAttachmentId(),
          type: SpaChatAttachmentType.procedure,
          title: product.title,
          subtitle: '$groupTitle · ${product.duration} · ${product.price} ₽',
          catalogGroupId: groupId,
        ),
      ],
    );

    _appendMessage(message);
    await _controller.insertMessage(message.toChatMessage());
  }

  void dispose() {
    _controller.dispose();
  }

  void _appendMessage(SpaChatMessage message) {
    _state = SpaChatState(
      participants: _state.participants,
      messages: [..._state.messages, message],
    );
  }

  Future<void> _sendAdminReply() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final message = SpaChatMessage(
      id: _nextMessageId(),
      authorId: adminId,
      text:
          'Спасибо, сообщение получила. Сейчас проверю расписание и вернусь с вариантом записи.',
      createdAt: DateTime.now(),
    );

    _appendMessage(message);
    await _controller.insertMessage(message.toChatMessage());
  }

  String _nextMessageId() {
    return 'message-${DateTime.now().microsecondsSinceEpoch}';
  }

  String _nextAttachmentId() {
    return 'attachment-${DateTime.now().microsecondsSinceEpoch}';
  }
}
