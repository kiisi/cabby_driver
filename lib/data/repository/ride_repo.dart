import 'dart:async';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:cabby_driver/data/network/api_provider.dart';
import 'package:cabby_driver/data/network/socket_provider.dart';

class RideRepository {
  final ApiProvider apiProvider;
  final SocketProvider socketProvider;

  // StreamControllers to broadcast ride events
  final _activeRideController = StreamController<RideModel>.broadcast();
  final _rideRequestController = StreamController<RideModel>.broadcast();
  final _driverLocationController = StreamController<Map<String, dynamic>>.broadcast();
  final _riderLocationController = StreamController<Map<String, dynamic>>.broadcast();
  final _messageController = StreamController<RideMessage>.broadcast();

  // Expose streams
  Stream<RideModel> get activeRideStream => _activeRideController.stream;
  Stream<RideModel> get rideRequestStream => _rideRequestController.stream;
  Stream<Map<String, dynamic>> get driverLocationStream => _driverLocationController.stream;
  Stream<Map<String, dynamic>> get riderLocationStream => _riderLocationController.stream;
  Stream<RideMessage> get messageStream => _messageController.stream;

  RideRepository({
    required this.apiProvider,
    required this.socketProvider,
  }) {
    // Listen to socket events and broadcast to appropriate streams
    socketProvider.rideRequestStream.listen(_rideRequestController.add);
    socketProvider.rideStatusStream.listen(_activeRideController.add);
    socketProvider.messageStream.listen(_messageController.add);
    socketProvider.locationUpdateStream.listen((location) {
      if (location['type'] == 'rider') {
        _riderLocationController.add(location);
      } else {
        _driverLocationController.add(location);
      }
    });
  }

  // Get active ride
  Future<RideModel?> getActiveRide() async {
    try {
      final ride = await apiProvider.getActiveRide();
      if (ride != null) {
        _activeRideController.add(ride);
      }
      return ride;
    } catch (e) {
      print('Error getting active ride: $e');
      return null;
    }
  }

  // Get nearby ride requests
  Future<List<RideModel>> getNearbyRideRequests() async {
    try {
      return await apiProvider.getNearbyRideRequests();
    } catch (e) {
      print('Error getting nearby ride requests: $e');
      return [];
    }
  }

  // Update driver availability
  void updateDriverAvailability(bool isAvailable) {
    socketProvider.updateDriverAvailability(isAvailable);
  }

  // Update driver location
  void updateDriverLocation(double latitude, double longitude) {
    socketProvider.updateDriverLocation(latitude, longitude);
    // Also update via API for persistence
    apiProvider.updateLocation(latitude, longitude).catchError((e) {
      print('Error updating location via API: $e');
    });
  }

  // Accept ride
  void acceptRide(String rideId, String riderId) {
    socketProvider.acceptRide(rideId, riderId);
  }

  // Reject ride
  void rejectRide(String rideId) {
    socketProvider.rejectRide(rideId);
  }

  // Arrive at pickup
  void arriveAtPickup(String rideId) {
    socketProvider.arriveAtPickup(rideId);
  }

  // Start ride
  void startRide(String rideId) {
    socketProvider.startRide(rideId);
  }

  // Complete ride
  void completeRide(String rideId) {
    socketProvider.completeRide(rideId);
  }

  // Cancel ride
  void cancelRide(String rideId, String reason) {
    socketProvider.cancelRide(rideId, reason);
  }

  // Send message to rider
  void sendMessage(String rideId, String riderId, String message) {
    socketProvider.sendMessage(rideId, riderId, message);
  }

  // Rate a rider
  Future<RatingModel> rateRider(
    String rideId,
    String riderId,
    int rating,
    String? comment,
  ) async {
    try {
      return await apiProvider.rateRider(
        rideId,
        riderId,
        rating,
        comment,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Dispose resources
  void dispose() {
    _activeRideController.close();
    _rideRequestController.close();
    _driverLocationController.close();
    _riderLocationController.close();
    _messageController.close();
  }
}
