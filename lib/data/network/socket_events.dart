class SocketEvents {
  static const connect = 'connect';
  static const disconnect = 'disconnect';
  static const connectError = 'connect_error';

  // Ride events
  static const rideRequest = 'ride_request';
  static const rideAccepted = 'ride_accepted';
  static const rideCancelled = 'ride_cancelled';
  static const rideCompleted = 'ride_completed';

  // Location
  static const riderLocationUpdate = 'rider_location_update';
  static const driverLocationUpdate = 'driver_location_update';
  static const driverAvailability = 'driver_availability';

  // Chat
  static const newMessage = 'new_message';
  static const sendMessage = 'send_message';

  // Driver ride actions
  static const acceptRide = 'accept_ride';
  static const rejectRide = 'reject_ride';
  static const arriveAtPickup = 'arrive_at_pickup';
  static const startRide = 'start_ride';
  static const completeRide = 'complete_ride';
  static const cancelRide = 'cancel_ride';
}
