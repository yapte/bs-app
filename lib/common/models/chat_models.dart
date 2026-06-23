enum SpaChatParticipantRole { client, admin }

enum SpaChatAttachmentType { image, procedure, favoriteGroup }

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
    this.favoriteGroupId,
    this.fileId,
    this.spaProcedureId,
    this.favoriteGroupApiId,
    this.imageUrl,
  });

  final String id;
  final SpaChatAttachmentType type;
  final String title;
  final String? subtitle;
  final String? localPath;
  final String? procedureId;
  final String? favoriteGroupId;
  final int? fileId;
  final int? spaProcedureId;
  final int? favoriteGroupApiId;
  final String? imageUrl;
}

class SpaChatState {
  const SpaChatState({required this.participants, required this.messages});

  final List<SpaChatParticipant> participants;
  final List<SpaChatMessage> messages;
}

class StoredFile {
  const StoredFile({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.uploadedByUserId,
    required this.createdAt,
    required this.url,
  });

  final int id;
  final String originalName;
  final String mimeType;
  final int size;
  final int uploadedByUserId;
  final DateTime createdAt;
  final String url;
}

class SpaChat {
  const SpaChat({
    required this.id,
    required this.status,
    required this.participants,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageAt,
    this.lastMessage,
  });

  final int id;
  final String status;
  final List<SpaChatParticipant> participants;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMessageAt;
  final SpaChatMessage? lastMessage;
}

class SpaChatMessagesPage {
  const SpaChatMessagesPage({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  final List<SpaChatMessage> items;
  final bool hasMore;
  final int? nextCursor;
}
