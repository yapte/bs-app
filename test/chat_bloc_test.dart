import 'dart:convert';

import 'package:bs_app/api/api.dart';
import 'package:bs_app/screens/home_screen/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('WS message increments unread and opening chat marks it read', () async {
    var markReadCalls = 0;
    final api = ApiServices(
      ApiClient(
        baseUrl: 'https://example.test',
        accessTokenProvider: () => 'access-token',
        httpClient: MockClient((request) async {
          if (request.url.path == '/auth/profile') {
            return _jsonResponse(_userJson);
          }
          if (request.url.path == '/chats' && request.method == 'POST') {
            return _jsonResponse(_chatJson);
          }
          if (request.url.path == '/chats/4/messages') {
            return _jsonResponse({
              'items': <Object>[],
              'hasMore': false,
              'nextCursor': null,
            });
          }
          if (request.url.path == '/chats/4/read') {
            markReadCalls++;
            return http.Response('', 204);
          }
          return _jsonResponse({'code': 'NOT_FOUND', 'message': 'Not found'});
        }),
      ),
    );
    late _FakeChatWsTransport transport;
    final ws = ChatWsService(
      baseUrl: 'https://example.test',
      accessTokenProvider: () => 'access-token',
      transportFactory: ({required url, required accessToken}) {
        return transport = _FakeChatWsTransport();
      },
    );
    final bloc = ChatBloc(api: api, wsService: ws);
    addTearDown(() async {
      await bloc.close();
      await ws.dispose();
    });

    bloc.add(const ChatStarted());
    await _waitFor(bloc, (state) => state.status == ChatStatus.ready);
    await _waitFor(
      bloc,
      (state) => state.wsState == ChatWsConnectionState.connecting,
    );

    transport.emit('chat.connected', {'userId': 1});
    transport.emit('chat.message.created', _messageJson);
    final unreadState = await _waitFor(bloc, (state) => state.unreadCount == 1);

    expect(unreadState.messages.single.id, '120');

    bloc.add(const ChatVisibilityChanged(true));
    final readState = await _waitFor(bloc, (state) => state.unreadCount == 0);
    await _waitUntil(() => markReadCalls == 1);

    expect(readState.isVisible, isTrue);
    expect(markReadCalls, 1);
  });
}

Future<void> _waitUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 30; attempt++) {
    if (predicate()) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('Condition was not met');
}

Future<ChatState> _waitFor(
  ChatBloc bloc,
  bool Function(ChatState state) predicate,
) async {
  if (predicate(bloc.state)) {
    return bloc.state;
  }
  return bloc.stream.firstWhere(predicate).timeout(const Duration(seconds: 3));
}

http.Response _jsonResponse(Object body) {
  return http.Response(
    jsonEncode(body),
    200,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

final _userJson = {
  'id': 1,
  'name': 'Клиент',
  'email': 'client@example.com',
  'role': 'guest',
  'createdAt': '2026-06-23T10:00:00.000Z',
  'updatedAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'createdBy': null,
  'updatedBy': null,
  'deletedBy': null,
};

final _chatJson = {
  'id': 4,
  'client': {'id': 42, 'name': 'Клиент', 'email': 'client@example.com'},
  'participants': [
    {'id': 1, 'name': 'Клиент', 'role': 'guest'},
    {'id': 7, 'name': 'Администратор', 'role': 'manager'},
  ],
  'status': 'open',
  'unreadCount': 0,
  'createdAt': '2026-06-23T09:00:00.000Z',
  'updatedAt': '2026-06-23T10:00:00.000Z',
};

final _messageJson = {
  'id': 120,
  'chatId': 4,
  'author': {'id': 7, 'name': 'Администратор', 'role': 'manager'},
  'text': 'Новое сообщение',
  'createdAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'attachments': <Object>[],
};

class _FakeChatWsTransport implements ChatWsTransport {
  final _handlers = <String, List<ChatWsEventHandler>>{};

  @override
  bool connected = false;

  @override
  void connect() {}

  @override
  void disconnect() {
    connected = false;
  }

  @override
  void dispose() {}

  @override
  void on(String event, ChatWsEventHandler handler) {
    _handlers.putIfAbsent(event, () => []).add(handler);
  }

  void emit(String event, dynamic payload) {
    if (event == 'chat.connected') {
      connected = true;
    }
    for (final handler in _handlers[event] ?? const []) {
      handler(payload);
    }
  }
}
