import 'dart:async';

import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:cabby_driver/data/network/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:cabby_driver/data/network/socket_events.dart';

class SocketProvider {
  // Socket instance
  io.Socket? _socket;

  // Stream controllers
  final _rideRequestStreamController = StreamController<RideModel>.broadcast();
  final _rideStatusStreamController = StreamController<RideModel>.broadcast();
  final _messageStreamController = StreamController<RideMessage>.broadcast();
  final _locationUpdateStreamController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<RideModel> get rideRequestStream => _rideRequestStreamController.stream;
  Stream<RideModel> get rideStatusStream => _rideStatusStreamController.stream;
  Stream<RideMessage> get messageStream => _messageStreamController.stream;
  Stream<Map<String, dynamic>> get locationUpdateStream => _locationUpdateStreamController.stream;

  // Singleton instance
  static SocketProvider? _instance;

  // Singleton factory
  factory SocketProvider() {
    _instance ??= SocketProvider._internal();
    return _instance!;
  }

  // Private constructor
  SocketProvider._internal();

  // Initialize socket connection
  void init(String driverId, String token) {
    // Close existing connection if any
    disconnect();

    // Configure socket options
    _socket = io.io(
      "http://192.168.0.198:5000",
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setQuery({'token': token, 'driverId': driverId})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    // Set up event listeners
    _setupEventListeners();

    // Connect to server
    _socket!.connect();
  }

  // Set up socket event listeners
  void _setupEventListeners() {
    _socket!.on('connect', (_) {
      print('Socket connected');
    });

    _socket!.on('disconnect', (_) {
      print('Socket disconnected');
    });

    _socket!.on('connect_error', (error) {
      print('Connection error: $error');
    });

    // Ride request event
    _socket!.on('ride_request', (data) {
      print('Received ride request: $data');

      try {
        final ride = RideModel.fromJson(data);
        _rideRequestStreamController.add(ride);
      } catch (e) {
        print('Error parsing ride request: $e');
      }
    });

    // Ride status update events
    _socket!.on('ride_accepted', (data) {
      try {
        final ride = RideModel.fromJson(data);
        _rideStatusStreamController.add(ride);
      } catch (e) {
        print('Error parsing ride accepted: $e');
      }
    });

    _socket!.on('ride_cancelled', (data) {
      try {
        final ride = RideModel.fromJson(data);
        _rideStatusStreamController.add(ride);
      } catch (e) {
        print('Error parsing ride cancelled: $e');
      }
    });

    _socket!.on('ride_completed', (data) {
      try {
        final ride = RideModel.fromJson(data);
        _rideStatusStreamController.add(ride);
      } catch (e) {
        print('Error parsing ride completed: $e');
      }
    });

    // Location update events
    _socket!.on('rider_location_update', (data) {
      _locationUpdateStreamController.add({
        'type': 'rider',
        'riderId': data['riderId'],
        'latitude': data['latitude'],
        'longitude': data['longitude'],
      });
    });

    // Chat message events
    _socket!.on('new_message', (data) {
      try {
        final message = RideMessage(
          senderId: data['senderId'],
          senderRole: data['senderRole'],
          message: data['message'],
          timestamp: DateTime.parse(data['timestamp']),
        );
        _messageStreamController.add(message);
      } catch (e) {
        print('Error parsing message: $e');
      }
    });
  }

  // Disconnect socket
  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket = null;
    }
  }

  // Update driver availability status
  void updateDriverAvailability(bool isAvailable) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('driver_availability', {
      'isAvailable': isAvailable,
    });
  }

  // Update driver location
  void updateDriverLocation(double latitude, double longitude) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('driver_location_update', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  // Accept a ride request
  void acceptRide(String rideId, String riderId) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('accept_ride', {
      'rideId': rideId,
      'riderId': riderId,
    });
  }

  // Reject a ride request
  void rejectRide(String rideId) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('reject_ride', {
      'rideId': rideId,
    });
  }

  // Arrive at pickup location
  void arriveAtPickup(String rideId) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('arrive_at_pickup', {
      'rideId': rideId,
    });
  }

  // Start ride
  void startRide(String rideId) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('start_ride', {
      'rideId': rideId,
    });
  }

  // Complete ride
  void completeRide(String rideId) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('complete_ride', {
      'rideId': rideId,
    });
  }

  // Cancel ride
  void cancelRide(String rideId, String reason) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('cancel_ride', {
      'rideId': rideId,
      'reason': reason,
    });
  }

  // Send message to rider
  void sendMessage(String rideId, String riderId, String message) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('send_message', {
      'rideId': rideId,
      'recipientId': riderId,
      'recipientRole': 'rider',
      'message': message,
    });
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _rideRequestStreamController.close();
    _rideStatusStreamController.close();
    _messageStreamController.close();
    _locationUpdateStreamController.close();
  }
}
