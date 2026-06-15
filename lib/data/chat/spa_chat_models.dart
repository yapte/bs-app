enum SpaChatParticipantRole { client, admin }

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
  });

  final String id;
  final String authorId;
  final String text;
  final DateTime createdAt;
}

class SpaChatState {
  const SpaChatState({required this.participants, required this.messages});

  final List<SpaChatParticipant> participants;
  final List<SpaChatMessage> messages;
}
