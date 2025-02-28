// import 'package:cabby/core/common/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceClient {
  late IO.Socket socket;

  void connect(String? id) {
    socket = IO.io(
        // Constant.baseUrl,
        "http://192.168.0.198:5000",
        IO.OptionBuilder().setTransports(['websocket']).setQuery({'id': id}).build());

    print('Socket.io ${socket.id}');

    socket.onError((data) {
      print('Socket error: $data');
    });

    // Handle disconnection
    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }
}
