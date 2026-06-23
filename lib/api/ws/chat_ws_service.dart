import 'dart:async';

import '../api_client.dart';
import '../api_exception.dart';
import '../dtos/json_readers.dart';
import 'chat_ws_events.dart';
import 'chat_ws_transport.dart';

class ChatWsService {
  ChatWsService({
    required String baseUrl,
    required AccessTokenProvider accessTokenProvider,
    ChatWsTransportFactory transportFactory = createSocketIoChatTransport,
  }) : _url = _namespaceUrl(baseUrl),
       _accessTokenProvider = accessTokenProvider,
       _transportFactory = transportFactory;

  static const namespace = '/chat-events';

  final String _url;
  final AccessTokenProvider _accessTokenProvider;
  final ChatWsTransportFactory _transportFactory;

  final _connectionStateController =
      StreamController<ChatWsConnectionState>.broadcast();
  final _connectedController =
      StreamController<ChatWsConnectedEvent>.broadcast();
  final _messageCreatedController =
      StreamController<ChatWsMessageCreatedEvent>.broadcast();
  final _messageDeletedController =
      StreamController<ChatWsMessageDeletedEvent>.broadcast();
  final _readUpdatedController =
      StreamController<ChatWsReadUpdatedEvent>.broadcast();
  final _chatUpdatedController =
      StreamController<ChatWsChatUpdatedEvent>.broadcast();
  final _authErrorController = StreamController<ChatWsAuthError>.broadcast();
  final _connectionErrorController = StreamController<Object>.broadcast();
  final _resyncRequiredController = StreamController<void>.broadcast();

  ChatWsTransport? _transport;
  ChatWsConnectionState _connectionState = ChatWsConnectionState.disconnected;
  bool _hasConnected = false;
  bool _disposed = false;

  String get url => _url;
  ChatWsConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == ChatWsConnectionState.connected;

  Stream<ChatWsConnectionState> get connectionStates =>
      _connectionStateController.stream;
  Stream<ChatWsConnectedEvent> get connectedEvents =>
      _connectedController.stream;
  Stream<ChatWsMessageCreatedEvent> get messageCreatedEvents =>
      _messageCreatedController.stream;
  Stream<ChatWsMessageDeletedEvent> get messageDeletedEvents =>
      _messageDeletedController.stream;
  Stream<ChatWsReadUpdatedEvent> get readUpdatedEvents =>
      _readUpdatedController.stream;
  Stream<ChatWsChatUpdatedEvent> get chatUpdatedEvents =>
      _chatUpdatedController.stream;
  Stream<ChatWsAuthError> get authErrors => _authErrorController.stream;
  Stream<Object> get connectionErrors => _connectionErrorController.stream;

  /// Emitted after a successful reconnection. Consumers should fetch missed
  /// messages with GET /chats/:chatId/messages?afterId=:lastMessageId.
  Stream<void> get resyncRequired => _resyncRequiredController.stream;

  Future<void> connect() async {
    _ensureNotDisposed();
    if (_connectionState == ChatWsConnectionState.connecting ||
        _connectionState == ChatWsConnectionState.connected ||
        _connectionState == ChatWsConnectionState.reconnecting) {
      return;
    }

    final token = await _accessTokenProvider();
    if (token == null || token.isEmpty) {
      throw const ApiException(
        statusCode: 401,
        code: 'AUTH_TOKEN_MISSING',
        message: 'Для подключения к чату требуется access token',
      );
    }

    _transport?.dispose();
    final transport = _transportFactory(url: _url, accessToken: token);
    _transport = transport;
    _bind(transport);
    _setConnectionState(ChatWsConnectionState.connecting);
    transport.connect();
  }

  void disconnect() {
    if (_disposed) {
      return;
    }
    _transport?.disconnect();
    _transport?.dispose();
    _transport = null;
    _hasConnected = false;
    _setConnectionState(ChatWsConnectionState.disconnected);
  }

  Future<void> reconnectWithLatestToken() async {
    disconnect();
    await connect();
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _transport?.disconnect();
    _transport?.dispose();
    _transport = null;

    await Future.wait([
      _connectionStateController.close(),
      _connectedController.close(),
      _messageCreatedController.close(),
      _messageDeletedController.close(),
      _readUpdatedController.close(),
      _chatUpdatedController.close(),
      _authErrorController.close(),
      _connectionErrorController.close(),
      _resyncRequiredController.close(),
    ]);
  }

  void _bind(ChatWsTransport transport) {
    transport.on('connect', (_) {
      if (_hasConnected) {
        _setConnectionState(ChatWsConnectionState.reconnecting);
      }
    });
    transport.on('disconnect', (_) {
      if (_hasConnected) {
        _setConnectionState(ChatWsConnectionState.reconnecting);
      } else {
        _setConnectionState(ChatWsConnectionState.disconnected);
      }
    });
    transport.on('connect_error', (error) {
      _connectionErrorController.add(error ?? 'Socket.IO connection error');
    });
    transport.on('error', (error) {
      _connectionErrorController.add(error ?? 'Socket.IO error');
    });

    transport.on('chat.connected', (payload) {
      final event = ChatWsConnectedEvent.fromJson(readMap(payload));
      final isReconnect = _hasConnected;
      _hasConnected = true;
      _setConnectionState(ChatWsConnectionState.connected);
      _connectedController.add(event);
      if (isReconnect) {
        _resyncRequiredController.add(null);
      }
    });
    transport.on('chat.message.created', (payload) {
      _messageCreatedController.add(
        ChatWsMessageCreatedEvent.fromJson(readMap(payload)),
      );
    });
    transport.on('chat.message.deleted', (payload) {
      _messageDeletedController.add(
        ChatWsMessageDeletedEvent.fromJson(readMap(payload)),
      );
    });
    transport.on('chat.read.updated', (payload) {
      _readUpdatedController.add(
        ChatWsReadUpdatedEvent.fromJson(readMap(payload)),
      );
    });
    transport.on('chat.updated', (payload) {
      _chatUpdatedController.add(
        ChatWsChatUpdatedEvent.fromJson(readMap(payload)),
      );
    });
    transport.on('chat.auth.error', (payload) {
      final error = ChatWsAuthError.fromJson(readMap(payload));
      _authErrorController.add(error);
      _setConnectionState(ChatWsConnectionState.disconnected);
      transport.disconnect();
    });
  }

  void _setConnectionState(ChatWsConnectionState value) {
    if (_disposed || _connectionState == value) {
      return;
    }
    _connectionState = value;
    _connectionStateController.add(value);
  }

  void _ensureNotDisposed() {
    if (_disposed) {
      throw StateError('ChatWsService is already disposed');
    }
  }

  static String _namespaceUrl(String baseUrl) {
    final normalized = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return '$normalized$namespace';
  }
}
