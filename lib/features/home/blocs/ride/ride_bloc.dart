import 'dart:async';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ride_event.dart';
import 'ride_state.dart';
import 'package:cabby_driver/data/repository/ride_repo.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final RideRepository rideRepository;
  StreamSubscription? _activeRideSubscription;
  StreamSubscription? _rideRequestSubscription;
  StreamSubscription? _messageSubscription;
  bool _isDriverAvailable = false;

  RideBloc({
    required this.rideRepository,
  }) : super(RideInitial()) {
    on<GetActiveRide>(_onGetActiveRide);
    on<ToggleAvailability>(_onToggleAvailability);
    on<UpdateDriverLocation>(_onUpdateDriverLocation);
    on<AcceptRide>(_onAcceptRide);
    on<RejectRide>(_onRejectRide);
    on<ArriveAtPickup>(_onArriveAtPickup);
    on<StartRide>(_onStartRide);
    on<CompleteRide>(_onCompleteRide);
    on<CancelRide>(_onCancelRide);
    on<SendMessage>(_onSendMessage);
    on<RateRider>(_onRateRider);

    // Listen to active ride updates from the repository
    _activeRideSubscription = rideRepository.activeRideStream.listen((ride) {
      if (ride.status == 'accepted') {
        add(AcceptRide(rideId: ride.id, riderId: ride.riderId));
      } else if (ride.status == 'arrived') {
        add(ArriveAtPickup(rideId: ride.id));
      } else if (ride.status == 'in_progress') {
        add(StartRide(rideId: ride.id));
      } else if (ride.status == 'completed') {
        add(CompleteRide(rideId: ride.id));
      } else if (ride.status == 'cancelled') {
        add(CancelRide(
          rideId: ride.id,
          reason: ride.cancellationReason ?? 'Cancelled by rider',
        ));
      }
    });

    // Listen to new ride requests from the repository
    _rideRequestSubscription = rideRepository.rideRequestStream.listen((ride) {
      if (state is DriverAvailableState && _isDriverAvailable) {
        final currentState = state as DriverAvailableState;
        // Check if the ride is already in the list
        final existingRideIndex =
            currentState.nearbyRides.indexWhere((existingRide) => existingRide.id == ride.id);

        List<RideModel> updatedRides = List.from(currentState.nearbyRides);
        if (existingRideIndex >= 0) {
          // Update existing ride
          updatedRides[existingRideIndex] = ride;
        } else {
          // Add new ride
          updatedRides.add(ride);
        }

        emit(DriverAvailableState(nearbyRides: updatedRides));
      }
    });

    // Listen to new messages from the repository
    _messageSubscription = rideRepository.messageStream.listen((message) {
      if (message.senderRole == 'rider') {
        emit(NewMessageReceived(
          rideId: '', // This will be set in the ride state
          senderId: message.senderId,
          senderRole: message.senderRole,
          message: message.message,
          timestamp: message.timestamp,
        ));
      }
    });
  }

  Future<void> _onGetActiveRide(
    GetActiveRide event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      final ride = await rideRepository.getActiveRide();

      if (ride == null) {
        // No active ride, check if driver is available
        if (_isDriverAvailable) {
          final nearbyRides = await rideRepository.getNearbyRideRequests();
          emit(DriverAvailableState(nearbyRides: nearbyRides));
        } else {
          emit(DriverOfflineState());
        }
        return;
      }

      // Process active ride based on its status
      if (ride.status == 'accepted') {
        final rider = ride.rider;
        if (rider == null) {
          emit(RideFailure('Rider information not available'));
          return;
        }
        emit(RideAcceptedState(ride: ride, rider: rider));
      } else if (ride.status == 'arrived') {
        final rider = ride.rider;
        if (rider == null) {
          emit(RideFailure('Rider information not available'));
          return;
        }
        emit(ArrivedAtPickupState(ride: ride, rider: rider));
      } else if (ride.status == 'in_progress') {
        final rider = ride.rider;
        if (rider == null) {
          emit(RideFailure('Rider information not available'));
          return;
        }
        emit(RideInProgressState(ride: ride, rider: rider));
      } else if (ride.status == 'completed') {
        final rider = ride.rider;
        if (rider == null) {
          emit(RideFailure('Rider information not available'));
          return;
        }
        emit(RideCompletedState(ride: ride, rider: rider));
      } else if (ride.status == 'cancelled') {
        emit(RideCancelledState(
          rideId: ride.id,
          reason: ride.cancellationReason ?? 'Unknown reason',
          cancelledBy: 'unknown',
        ));
      } else {
        // If ride is in a different state, revert to the appropriate available/offline state
        if (_isDriverAvailable) {
          final nearbyRides = await rideRepository.getNearbyRideRequests();
          emit(DriverAvailableState(nearbyRides: nearbyRides));
        } else {
          emit(DriverOfflineState());
        }
      }
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  Future<void> _onToggleAvailability(
    ToggleAvailability event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      _isDriverAvailable = event.isAvailable;
      rideRepository.updateDriverAvailability(event.isAvailable);

      if (event.isAvailable) {
        // If driver is now available, get nearby ride requests
        final nearbyRides = await rideRepository.getNearbyRideRequests();
        emit(DriverAvailableState(nearbyRides: nearbyRides));
      } else {
        // If driver is now offline
        emit(DriverOfflineState());
      }
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  void _onUpdateDriverLocation(
    UpdateDriverLocation event,
    Emitter<RideState> emit,
  ) {
    try {
      rideRepository.updateDriverLocation(
        event.latitude,
        event.longitude,
      );
      // No state change needed, this is just updating location
    } catch (e) {
      // No need to emit error state for location updates
      print('Error updating location: $e');
    }
  }

  Future<void> _onAcceptRide(
    AcceptRide event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      // Send accept ride event to repository
      rideRepository.acceptRide(event.rideId, event.riderId);

      // Get the ride details
      final ride = await rideRepository.getActiveRide();

      if (ride == null) {
        emit(RideFailure('Failed to get ride details'));
        return;
      }

      final rider = ride.rider;
      if (rider == null) {
        emit(RideFailure('Rider information not available'));
        return;
      }

      emit(RideAcceptedState(ride: ride, rider: rider));
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  void _onRejectRide(
    RejectRide event,
    Emitter<RideState> emit,
  ) {
    try {
      rideRepository.rejectRide(event.rideId);

      // Update nearby rides list if driver is available
      if (state is DriverAvailableState) {
        final currentState = state as DriverAvailableState;
        final updatedRides = currentState.nearbyRides.where((ride) => ride.id != event.rideId).toList();

        emit(DriverAvailableState(nearbyRides: updatedRides));
      }
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  Future<void> _onArriveAtPickup(
    ArriveAtPickup event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      // Send arrive at pickup event to repository
      rideRepository.arriveAtPickup(event.rideId);

      // Get the ride details
      final ride = await rideRepository.getActiveRide();

      if (ride == null) {
        emit(RideFailure('Failed to get ride details'));
        return;
      }

      final rider = ride.rider;
      if (rider == null) {
        emit(RideFailure('Rider information not available'));
        return;
      }

      emit(ArrivedAtPickupState(ride: ride, rider: rider));
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  Future<void> _onStartRide(
    StartRide event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      // Send start ride event to repository
      rideRepository.startRide(event.rideId);

      // Get the ride details
      final ride = await rideRepository.getActiveRide();

      if (ride == null) {
        emit(RideFailure('Failed to get ride details'));
        return;
      }

      final rider = ride.rider;
      if (rider == null) {
        emit(RideFailure('Rider information not available'));
        return;
      }

      emit(RideInProgressState(ride: ride, rider: rider));
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  Future<void> _onCompleteRide(
    CompleteRide event,
    Emitter<RideState> emit,
  ) async {
    emit(RideLoading());
    try {
      // Send complete ride event to repository
      rideRepository.completeRide(event.rideId);

      // Get the ride details
      final ride = await rideRepository.getActiveRide();

      if (ride == null) {
        emit(RideFailure('Failed to get ride details'));
        return;
      }

      final rider = ride.rider;
      if (rider == null) {
        emit(RideFailure('Rider information not available'));
        return;
      }

      emit(RideCompletedState(ride: ride, rider: rider));
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  void _onCancelRide(
    CancelRide event,
    Emitter<RideState> emit,
  ) {
    try {
      // Send cancel ride event to repository
      rideRepository.cancelRide(event.rideId, event.reason);

      emit(RideCancelledState(
        rideId: event.rideId,
        reason: event.reason,
        cancelledBy: 'driver',
      ));
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  void _onSendMessage(
    SendMessage event,
    Emitter<RideState> emit,
  ) {
    try {
      // Extract riderId from the current state
      String? riderId;

      if (state is RideAcceptedState) {
        riderId = (state as RideAcceptedState).rider.id;
      } else if (state is ArrivedAtPickupState) {
        riderId = (state as ArrivedAtPickupState).rider.id;
      } else if (state is RideInProgressState) {
        riderId = (state as RideInProgressState).rider.id;
      } else if (state is RideCompletedState) {
        riderId = (state as RideCompletedState).rider.id;
      }

      if (riderId == null) {
        print('Cannot send message: Rider ID not available');
        return;
      }

      // Send message event to repository
      rideRepository.sendMessage(event.rideId, riderId, event.message);

      // No state change needed, this is just sending a message
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _onRateRider(
    RateRider event,
    Emitter<RideState> emit,
  ) async {
    try {
      // Send rate rider event to repository
      await rideRepository.rateRider(
        event.rideId,
        event.riderId,
        event.rating,
        event.comment,
      );

      // Update state if it's a completed ride
      if (state is RideCompletedState) {
        final currentState = state as RideCompletedState;
        emit(RideCompletedState(
          ride: currentState.ride,
          rider: currentState.rider,
          isRated: true,
        ));
      }
    } catch (e) {
      emit(RideFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _activeRideSubscription?.cancel();
    _rideRequestSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }
}
