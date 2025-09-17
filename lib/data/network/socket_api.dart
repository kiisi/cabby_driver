import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:cabby_driver/data/network/socket_events.dart';

class SocketServiceClient {
  final io.Socket _socket;

  SocketServiceClient(this._socket);

  // ---- Emitters (Requests to server) ----
  void updateDriverAvailability(bool isAvailable) {
    _socket.emit(SocketEvents.driverAvailability, {
      'isAvailable': isAvailable,
    });
  }

  void updateDriverLocation(double latitude, double longitude) {
    _socket.emit(SocketEvents.driverLocationUpdate, {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void acceptRide(String rideId, String riderId) {
    _socket.emit(SocketEvents.acceptRide, {
      'rideId': rideId,
      'riderId': riderId,
    });
  }

  void rejectRide(String rideId) {
    _socket.emit(SocketEvents.rejectRide, {'rideId': rideId});
  }

  void arriveAtPickup(String rideId) {
    _socket.emit(SocketEvents.arriveAtPickup, {'rideId': rideId});
  }

  void startRide(String rideId) {
    _socket.emit(SocketEvents.startRide, {'rideId': rideId});
  }

  void completeRide(String rideId) {
    _socket.emit(SocketEvents.completeRide, {'rideId': rideId});
  }

  void cancelRide(String rideId, String reason) {
    _socket.emit(SocketEvents.cancelRide, {
      'rideId': rideId,
      'reason': reason,
    });
  }

  void sendMessage(String rideId, String riderId, String message) {
    _socket.emit(SocketEvents.sendMessage, {
      'rideId': rideId,
      'recipientId': riderId,
      'recipientRole': 'rider',
      'message': message,
    });
  }
}
