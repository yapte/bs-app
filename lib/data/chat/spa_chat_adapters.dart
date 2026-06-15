import 'package:flutter_chat_core/flutter_chat_core.dart';

import 'spa_chat_models.dart';

extension SpaChatParticipantAdapter on SpaChatParticipant {
  User toChatUser() => User(id: id, name: name);
}

extension SpaChatMessageAdapter on SpaChatMessage {
  TextMessage toChatMessage() => TextMessage(
    id: id,
    authorId: authorId,
    createdAt: createdAt.toUtc(),
    text: text,
  );
}

extension ChatTextMessageAdapter on TextMessage {
  SpaChatMessage toSpaChatMessage() => SpaChatMessage(
    id: id,
    authorId: authorId,
    text: text,
    createdAt: createdAt?.toLocal() ?? DateTime.now(),
  );
}
