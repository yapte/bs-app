import 'package:socket_io_client/socket_io_client.dart' as io;

typedef ChatWsEventHandler = void Function(dynamic data);

abstract interface class ChatWsTransport {
  bool get connected;

  void on(String event, ChatWsEventHandler handler);

  void connect();

  void disconnect();

  void dispose();
}

typedef ChatWsTransportFactory =
    ChatWsTransport Function({
      required String url,
      required String accessToken,
    });

ChatWsTransport createSocketIoChatTransport({
  required String url,
  required String accessToken,
}) {
  return SocketIoChatTransport(url: url, accessToken: accessToken);
}

class SocketIoChatTransport implements ChatWsTransport {
  SocketIoChatTransport({required String url, required String accessToken})
    : _socket = io.io(
        url,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': accessToken})
            .disableAutoConnect()
            .enableForceNew()
            .build(),
      );

  final io.Socket _socket;

  @override
  bool get connected => _socket.connected;

  @override
  void on(String event, ChatWsEventHandler handler) {
    _socket.on(event, handler);
  }

  @override
  void connect() {
    _socket.connect();
  }

  @override
  void disconnect() {
    _socket.disconnect();
  }

  @override
  void dispose() {
    _socket.dispose();
  }
}
