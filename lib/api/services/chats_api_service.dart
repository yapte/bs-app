import '../../common/models/models.dart';
import '../api_client.dart';
import '../dtos/api_response_dtos.dart';
import '../dtos/dto_parsers.dart';
import '../dtos/json_readers.dart';

class ChatsApiService {
  const ChatsApiService(this._client);

  final ApiClient _client;

  Future<PageResult<SpaChat>> getAll({
    PageQuery query = const PageQuery(sort: 'lastMessageAt'),
    String? status,
    int? assignedUserId,
  }) async {
    final page = parsePage(
      await _client.get(
        '/chats',
        query: {
          'sort': query.sort,
          'sortDirection': query.sortDirection,
          'search': query.search,
          'itemsPerPage': query.itemsPerPage,
          'page': query.page,
          'status': status,
          'assignedUserId': assignedUserId,
        },
        authenticated: true,
      ),
      SpaChatDto.fromJson,
    );
    return PageResult(
      total: page.total,
      items: page.items.map((item) => item.toDomain()).toList(),
    );
  }

  Future<SpaChat> createOrGet({int? clientId}) async {
    return SpaChatDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/chats',
          body: clientId == null ? const {} : {'clientId': clientId},
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<SpaChat> getById(int chatId) async {
    return SpaChatDto.fromJson(
      requireJsonMap(await _client.get('/chats/$chatId', authenticated: true)),
    ).toDomain();
  }

  Future<SpaChat> update(
    int chatId, {
    int? assignedUserId,
    String? status,
  }) async {
    final body = <String, Object?>{};
    if (assignedUserId != null) {
      body['assignedUserId'] = assignedUserId;
    }
    if (status != null) {
      body['status'] = status;
    }

    return SpaChatDto.fromJson(
      requireJsonMap(
        await _client.patch('/chats/$chatId', body: body, authenticated: true),
      ),
    ).toDomain();
  }

  Future<SpaChatMessagesPage> getMessages(
    int chatId, {
    int limit = 30,
    int? beforeId,
    int? afterId,
  }) async {
    final json = requireJsonMap(
      await _client.get(
        '/chats/$chatId/messages',
        query: {'limit': limit, 'beforeId': beforeId, 'afterId': afterId},
        authenticated: true,
      ),
    );

    return SpaChatMessagesPage(
      items: (json['items'] as List? ?? const [])
          .map((item) => SpaChatMessageDto.fromJson(readMap(item)).toDomain())
          .toList(),
      hasMore: json['hasMore'] == true,
      nextCursor: readNullableInt(json['nextCursor']),
    );
  }

  Future<SpaChatMessage> sendMessage(
    int chatId, {
    required String text,
    List<SpaChatAttachment> attachments = const [],
  }) async {
    return SpaChatMessageDto.fromJson(
      requireJsonMap(
        await _client.post(
          '/chats/$chatId/messages',
          body: {
            if (text.trim().isNotEmpty) 'text': text.trim(),
            if (attachments.isNotEmpty)
              'attachments': attachments.map(_attachmentToJson).toList(),
          },
          authenticated: true,
        ),
      ),
    ).toDomain();
  }

  Future<void> markRead(int chatId, int messageId) {
    return _client
        .patch(
          '/chats/$chatId/read',
          body: {'messageId': messageId},
          authenticated: true,
        )
        .then((_) {});
  }

  Future<void> deleteMessage(int chatId, int messageId) {
    return _client.delete(
      '/chats/$chatId/messages/$messageId',
      authenticated: true,
    );
  }

  Map<String, Object> _attachmentToJson(SpaChatAttachment attachment) {
    return switch (attachment.type) {
      SpaChatAttachmentType.image => {
        'type': 'file',
        'fileId': attachment.fileId!,
      },
      SpaChatAttachmentType.procedure => {
        'type': 'spaProcedure',
        'spaProcedureId': attachment.spaProcedureId!,
      },
      SpaChatAttachmentType.favoriteGroup => {
        'type': 'favoriteGroup',
        'favoriteGroupId': attachment.favoriteGroupApiId!,
      },
    };
  }
}
