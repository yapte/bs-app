import 'dart:convert';
import 'dart:io';

import 'package:bs_app/api/api.dart';
import 'package:bs_app/common/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('chat service maps history and sends attachment contract', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test',
      accessTokenProvider: () => 'access-token',
      httpClient: MockClient((request) async {
        expect(request.headers['authorization'], 'Bearer access-token');

        if (request.method == 'POST') {
          expect(request.url.path, '/chats/4/messages');
          expect(jsonDecode(request.body), {
            'text': 'Фото',
            'attachments': [
              {'type': 'file', 'fileId': 10},
            ],
          });
          return http.Response(
            jsonEncode(_messageJson),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }

        expect(request.url.path, '/chats/4/messages');
        expect(request.url.queryParameters['limit'], '30');
        expect(request.url.queryParameters['afterId'], '119');
        return http.Response(
          jsonEncode({
            'items': [_messageJson],
            'hasMore': false,
            'nextCursor': null,
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    final service = ChatsApiService(client);

    final page = await service.getMessages(4, afterId: 119);
    final sent = await service.sendMessage(
      4,
      text: 'Фото',
      attachments: const [
        SpaChatAttachment(
          id: 'draft-file-10',
          type: SpaChatAttachmentType.image,
          title: 'photo.jpg',
          fileId: 10,
        ),
      ],
    );

    expect(page.items.single.id, '120');
    expect(page.items.single.attachments.single.fileId, 10);
    expect(
      page.items.single.attachments.single.imageUrl,
      'https://files.example.com/photo.jpg',
    );
    expect(sent.authorId, '7');
  });

  test('file upload is multipart and authenticated', () async {
    final directory = await Directory.systemTemp.createTemp('bs-chat-test');
    final source = File('${directory.path}/photo.jpg');
    await source.writeAsBytes([0xFF, 0xD8, 0xFF, 0xD9]);
    addTearDown(() => directory.delete(recursive: true));

    final client = ApiClient(
      baseUrl: 'https://example.test',
      accessTokenProvider: () => 'access-token',
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/files');
        expect(request.headers['authorization'], 'Bearer access-token');
        expect(
          request.headers['content-type'],
          startsWith('multipart/form-data'),
        );
        return http.Response(
          jsonEncode(_fileJson),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    final file = await FilesApiService(client).upload(source.path);

    expect(file.id, 10);
    expect(file.originalName, 'photo.jpg');
  });
}

final _fileJson = {
  'id': 10,
  'originalName': 'photo.jpg',
  'mimeType': 'image/jpeg',
  'size': 123456,
  'uploadedByUserId': 7,
  'createdAt': '2026-06-23T10:00:00.000Z',
  'url': 'https://files.example.com/photo.jpg',
};

final _messageJson = {
  'id': 120,
  'chatId': 4,
  'author': {'id': 7, 'name': 'Администратор', 'role': 'manager'},
  'text': 'Фото',
  'createdAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'attachments': [
    {'id': 1, 'type': 'file', 'file': _fileJson},
  ],
};
