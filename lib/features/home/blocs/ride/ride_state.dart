import 'package:cabby_driver/data/models/driver_model.dart';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:equatable/equatable.dart';

abstract class RideState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class RideInitial extends RideState {}

// Loading state
class RideLoading extends RideState {}

// Driver offline state
class DriverOfflineState extends RideState {}

// Driver available state (online, waiting for rides)
class DriverAvailableState extends RideState {
  final List<RideModel> nearbyRides;

  DriverAvailableState({
    required this.nearbyRides,
  });

  @override
  List<Object> get props => [nearbyRides];
}

// Ride accepted state (driver is on the way to pickup)
class RideAcceptedState extends RideState {
  final RideModel ride;
  final RiderUser rider;

  RideAcceptedState({
    required this.ride,
    required this.rider,
  });

  @override
  List<Object> get props => [ride, rider];
}

// Arrived at pickup state (waiting for rider)
class ArrivedAtPickupState extends RideState {
  final RideModel ride;
  final RiderUser rider;

  ArrivedAtPickupState({
    required this.ride,
    required this.rider,
  });

  @override
  List<Object> get props => [ride, rider];
}

// Ride in progress state (rider is in the car)
class RideInProgressState extends RideState {
  final RideModel ride;
  final RiderUser rider;

  RideInProgressState({
    required this.ride,
    required this.rider,
  });

  @override
  List<Object> get props => [ride, rider];
}

// Ride completed state
class RideCompletedState extends RideState {
  final RideModel ride;
  final RiderUser rider;
  final bool isRated;

  RideCompletedState({
    required this.ride,
    required this.rider,
    this.isRated = false,
  });

  @override
  List<Object> get props => [ride, rider, isRated];
}

// Ride cancelled state
class RideCancelledState extends RideState {
  final String rideId;
  final String reason;
  final String cancelledBy; // 'driver' or 'rider'

  RideCancelledState({
    required this.rideId,
    required this.reason,
    required this.cancelledBy,
  });

  @override
  List<Object> get props => [rideId, reason, cancelledBy];
}

// New message received state
class NewMessageReceived extends RideState {
  final String rideId;
  final String senderId;
  final String senderRole;
  final String message;
  final DateTime timestamp;

  NewMessageReceived({
    required this.rideId,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object> get props => [rideId, senderId, senderRole, message, timestamp];
}

// Failure state
class RideFailure extends RideState {
  final String error;

  RideFailure(this.error);

  @override
  List<Object> get props => [error];
}
