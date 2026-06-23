import 'package:bs_app/api/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('connects with token and parses chat events', () async {
    late _FakeChatWsTransport transport;
    late String createdUrl;
    late String createdToken;
    final service = ChatWsService(
      baseUrl: 'https://api.example.com',
      accessTokenProvider: () => 'access-token',
      transportFactory: ({required url, required accessToken}) {
        createdUrl = url;
        createdToken = accessToken;
        return transport = _FakeChatWsTransport();
      },
    );
    addTearDown(service.dispose);

    final connectedFuture = service.connectedEvents.first;
    final messageFuture = service.messageCreatedEvents.first;

    await service.connect();
    expect(createdUrl, 'https://api.example.com/chat-events');
    expect(createdToken, 'access-token');
    expect(transport.connectCalls, 1);

    transport.emit('chat.connected', {'userId': 7});
    transport.emit('chat.message.created', _messageJson);

    expect((await connectedFuture).userId, 7);
    final message = (await messageFuture).message;
    expect(message.id, '120');
    expect(message.authorId, '7');
    expect(service.connectionState, ChatWsConnectionState.connected);
  });

  test('requests REST resync after reconnection', () async {
    late _FakeChatWsTransport transport;
    final service = ChatWsService(
      baseUrl: 'https://api.example.com/',
      accessTokenProvider: () => 'access-token',
      transportFactory: ({required url, required accessToken}) {
        return transport = _FakeChatWsTransport();
      },
    );
    addTearDown(service.dispose);

    var resyncCount = 0;
    final subscription = service.resyncRequired.listen((_) => resyncCount++);
    addTearDown(subscription.cancel);

    await service.connect();
    transport.emit('chat.connected', {'userId': 7});
    transport.emit('disconnect', 'transport close');
    expect(service.connectionState, ChatWsConnectionState.reconnecting);

    transport.emit('connect', null);
    transport.emit('chat.connected', {'userId': 7});
    await Future<void>.delayed(Duration.zero);

    expect(resyncCount, 1);
    expect(service.connectionState, ChatWsConnectionState.connected);
  });

  test('emits typed auth errors and disconnects transport', () async {
    late _FakeChatWsTransport transport;
    final service = ChatWsService(
      baseUrl: 'https://api.example.com',
      accessTokenProvider: () => 'access-token',
      transportFactory: ({required url, required accessToken}) {
        return transport = _FakeChatWsTransport();
      },
    );
    addTearDown(service.dispose);

    final errorFuture = service.authErrors.first;
    await service.connect();
    transport.emit('chat.auth.error', {
      'code': 'UNAUTHORIZED',
      'message': 'Invalid access token',
    });

    final error = await errorFuture;
    expect(error.code, 'UNAUTHORIZED');
    expect(error.message, 'Invalid access token');
    expect(transport.disconnectCalls, 1);
    expect(service.connectionState, ChatWsConnectionState.disconnected);
  });

  test('rejects connection without access token', () async {
    final service = ChatWsService(
      baseUrl: 'https://api.example.com',
      accessTokenProvider: () => null,
    );
    addTearDown(service.dispose);

    expect(
      service.connect,
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'AUTH_TOKEN_MISSING',
        ),
      ),
    );
  });
}

final _messageJson = {
  'id': 120,
  'chatId': 4,
  'author': {'id': 7, 'name': 'Администратор', 'role': 'manager'},
  'text': 'Сообщение',
  'createdAt': '2026-06-23T10:00:00.000Z',
  'deletedAt': null,
  'attachments': <Object>[],
};

class _FakeChatWsTransport implements ChatWsTransport {
  final _handlers = <String, List<ChatWsEventHandler>>{};

  int connectCalls = 0;
  int disconnectCalls = 0;
  bool disposed = false;

  @override
  bool connected = false;

  @override
  void connect() {
    connectCalls++;
  }

  @override
  void disconnect() {
    disconnectCalls++;
    connected = false;
  }

  @override
  void dispose() {
    disposed = true;
  }

  @override
  void on(String event, ChatWsEventHandler handler) {
    _handlers.putIfAbsent(event, () => []).add(handler);
  }

  void emit(String event, dynamic payload) {
    if (event == 'connect') {
      connected = true;
    } else if (event == 'disconnect') {
      connected = false;
    }
    for (final handler in _handlers[event] ?? const []) {
      handler(payload);
    }
  }
}
