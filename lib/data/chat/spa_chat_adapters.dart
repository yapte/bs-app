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
    metadata: attachments.isEmpty
        ? null
        : {
            'attachments': attachments
                .map((attachment) => attachment.toMetadata())
                .toList(),
          },
  );
}

extension ChatTextMessageAdapter on TextMessage {
  SpaChatMessage toSpaChatMessage() => SpaChatMessage(
    id: id,
    authorId: authorId,
    text: text,
    createdAt: createdAt?.toLocal() ?? DateTime.now(),
    attachments: spaChatAttachmentsFromMetadata(metadata),
  );
}

extension SpaChatAttachmentAdapter on SpaChatAttachment {
  Map<String, dynamic> toMetadata() => {
    'id': id,
    'type': type.name,
    'title': title,
    if (subtitle != null) 'subtitle': subtitle,
    if (localPath != null) 'localPath': localPath,
    if (procedureId != null) 'procedureId': procedureId,
  };
}

List<SpaChatAttachment> spaChatAttachmentsFromMetadata(
  Map<String, dynamic>? metadata,
) {
  final rawAttachments = metadata?['attachments'];
  if (rawAttachments is! List) {
    return const [];
  }

  return rawAttachments
      .whereType<Map>()
      .map((rawAttachment) {
        final typeName = rawAttachment['type'] as String?;
        final type = SpaChatAttachmentType.values
            .where((type) => type.name == typeName)
            .firstOrNull;
        final id = rawAttachment['id'] as String?;
        final title = rawAttachment['title'] as String?;

        if (type == null || id == null || title == null) {
          return null;
        }

        return SpaChatAttachment(
          id: id,
          type: type,
          title: title,
          subtitle: rawAttachment['subtitle'] as String?,
          localPath: rawAttachment['localPath'] as String?,
          procedureId: rawAttachment['procedureId'] as String?,
        );
      })
      .whereType<SpaChatAttachment>()
      .toList();
}
