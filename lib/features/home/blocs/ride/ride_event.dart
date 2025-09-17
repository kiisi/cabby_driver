import 'package:equatable/equatable.dart';

abstract class RideEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Get active ride
class GetActiveRide extends RideEvent {}

// Toggle driver availability
class ToggleAvailability extends RideEvent {
  final bool isAvailable;

  ToggleAvailability(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

// Update driver location
class UpdateDriverLocation extends RideEvent {
  final double latitude;
  final double longitude;

  UpdateDriverLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

// Accept ride
class AcceptRide extends RideEvent {
  final String rideId;
  final String riderId;

  AcceptRide({
    required this.rideId,
    required this.riderId,
  });

  @override
  List<Object> get props => [rideId, riderId];
}

// Reject ride
class RejectRide extends RideEvent {
  final String rideId;

  RejectRide({
    required this.rideId,
  });

  @override
  List<Object> get props => [rideId];
}

// Arrive at pickup
class ArriveAtPickup extends RideEvent {
  final String rideId;

  ArriveAtPickup({
    required this.rideId,
  });

  @override
  List<Object> get props => [rideId];
}

// Start ride
class StartRide extends RideEvent {
  final String rideId;

  StartRide({
    required this.rideId,
  });

  @override
  List<Object> get props => [rideId];
}

// Complete ride
class CompleteRide extends RideEvent {
  final String rideId;

  CompleteRide({
    required this.rideId,
  });

  @override
  List<Object> get props => [rideId];
}

// Cancel ride
class CancelRide extends RideEvent {
  final String rideId;
  final String reason;

  CancelRide({
    required this.rideId,
    required this.reason,
  });

  @override
  List<Object> get props => [rideId, reason];
}

// Send message
class SendMessage extends RideEvent {
  final String rideId;
  final String message;

  SendMessage({
    required this.rideId,
    required this.message,
  });

  @override
  List<Object> get props => [rideId, message];
}

// Rate rider
class RateRider extends RideEvent {
  final String rideId;
  final String riderId;
  final int rating;
  final String? comment;

  RateRider({
    required this.rideId,
    required this.riderId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [rideId, riderId, rating, comment];
}
