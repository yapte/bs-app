enum SpaChatParticipantRole { client, admin }

enum SpaChatAttachmentType { image, procedure }

class SpaChatParticipant {
  const SpaChatParticipant({
    required this.id,
    required this.name,
    required this.role,
  });

  final String id;
  final String name;
  final SpaChatParticipantRole role;
}

class SpaChatMessage {
  const SpaChatMessage({
    required this.id,
    required this.authorId,
    required this.text,
    required this.createdAt,
    this.attachments = const [],
  });

  final String id;
  final String authorId;
  final String text;
  final DateTime createdAt;
  final List<SpaChatAttachment> attachments;
}

class SpaChatAttachment {
  const SpaChatAttachment({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.localPath,
    this.procedureId,
  });

  final String id;
  final SpaChatAttachmentType type;
  final String title;
  final String? subtitle;
  final String? localPath;
  final String? procedureId;
}

class SpaChatState {
  const SpaChatState({required this.participants, required this.messages});

  final List<SpaChatParticipant> participants;
  final List<SpaChatMessage> messages;
}
