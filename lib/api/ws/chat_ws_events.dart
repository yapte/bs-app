import '../../common/models/chat_models.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/json_readers.dart';

enum ChatWsConnectionState { disconnected, connecting, connected, reconnecting }

class ChatWsConnectedEvent {
  const ChatWsConnectedEvent({required this.userId});

  factory ChatWsConnectedEvent.fromJson(JsonMap json) {
    return ChatWsConnectedEvent(userId: readInt(json['userId']));
  }

  final int userId;
}

class ChatWsMessageCreatedEvent {
  const ChatWsMessageCreatedEvent({required this.message});

  factory ChatWsMessageCreatedEvent.fromJson(JsonMap json) {
    return ChatWsMessageCreatedEvent(
      message: SpaChatMessageDto.fromJson(json).toDomain(),
    );
  }

  final SpaChatMessage message;
}

class ChatWsMessageDeletedEvent {
  const ChatWsMessageDeletedEvent({
    required this.chatId,
    required this.messageId,
    required this.deletedAt,
  });

  factory ChatWsMessageDeletedEvent.fromJson(JsonMap json) {
    return ChatWsMessageDeletedEvent(
      chatId: readInt(json['chatId']),
      messageId: readInt(json['messageId']),
      deletedAt: readDate(json['deletedAt']),
    );
  }

  final int chatId;
  final int messageId;
  final DateTime deletedAt;
}

class ChatWsReadUpdatedEvent {
  const ChatWsReadUpdatedEvent({
    required this.chatId,
    required this.userId,
    required this.messageId,
    required this.readAt,
  });

  factory ChatWsReadUpdatedEvent.fromJson(JsonMap json) {
    return ChatWsReadUpdatedEvent(
      chatId: readInt(json['chatId']),
      userId: readInt(json['userId']),
      messageId: readInt(json['messageId']),
      readAt: readDate(json['readAt']),
    );
  }

  final int chatId;
  final int userId;
  final int messageId;
  final DateTime readAt;
}

class ChatWsChatUpdatedEvent {
  const ChatWsChatUpdatedEvent({required this.chatId});

  factory ChatWsChatUpdatedEvent.fromJson(JsonMap json) {
    return ChatWsChatUpdatedEvent(chatId: readInt(json['chatId']));
  }

  final int chatId;
}

class ChatWsAuthError {
  const ChatWsAuthError({required this.code, required this.message});

  factory ChatWsAuthError.fromJson(JsonMap json) {
    return ChatWsAuthError(
      code: readString(json['code'], 'UNAUTHORIZED'),
      message: readString(json['message'], 'WebSocket authorization failed'),
    );
  }

  final String code;
  final String message;

  @override
  String toString() => 'ChatWsAuthError($code): $message';
}
