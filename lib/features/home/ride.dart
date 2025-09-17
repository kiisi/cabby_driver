import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_config.dart';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_bloc.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_event.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_state.dart';
import 'package:cabby_driver/features/widgets/chat_interface.dart';
import 'package:cabby_driver/features/widgets/map_widget.dart';
import 'package:cabby_driver/features/widgets/ride_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

@RoutePage()
class RideScreen extends StatefulWidget {
  const RideScreen({Key? key}) : super(key: key);

  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  final List<RideMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isRiderDetailsExpanded = false;
  bool _isChatExpanded = false;
  Timer? _locationUpdateTimer;
  LatLng _currentLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    // Initialize location updates
    _startLocationUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check for active ride when screen loads
      context.read<RideBloc>().add(GetActiveRide());
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    // In a real app, use a location service to get updates
    // For this demo, we'll simulate location updates
    _locationUpdateTimer = Timer.periodic(
      AppConfig.locationUpdateInterval,
      (_) => _updateDriverLocation(),
    );
  }

  void _updateDriverLocation() {
    // In a real app, get the current location using location plugin
    // For this demo, we'll use a fixed location with small random variations
    final baseLatitude = 37.7749;
    final baseLongitude = -122.4194;

    // Add small random variations to simulate movement
    final latitude = baseLatitude + (DateTime.now().millisecond / 1000000);
    final longitude = baseLongitude + (DateTime.now().second / 100000);

    setState(() {
      _currentLocation = LatLng(latitude, longitude);
    });

    // Update location via BLoC
    context.read<RideBloc>().add(
          UpdateDriverLocation(
            latitude: latitude,
            longitude: longitude,
          ),
        );
  }

  void _toggleRiderDetails() {
    setState(() {
      _isRiderDetailsExpanded = !_isRiderDetailsExpanded;
      if (_isRiderDetailsExpanded) {
        _isChatExpanded = false;
      }
    });
  }

  void _toggleChat() {
    setState(() {
      _isChatExpanded = !_isChatExpanded;
      if (_isChatExpanded) {
        _isRiderDetailsExpanded = false;
      }
    });
  }

  void _sendMessage(String rideId) {
    if (_messageController.text.isEmpty) return;

    // Add message to UI
    setState(() {
      _messages.add(
        RideMessage(
          senderId: 'driver', // This should be the actual driver ID in a real app
          senderRole: 'driver',
          message: _messageController.text,
          timestamp: DateTime.now(),
        ),
      );
    });

    // Send message via BLoC
    context.read<RideBloc>().add(
          SendMessage(
            rideId: rideId,
            message: _messageController.text,
          ),
        );

    // Clear input field
    _messageController.clear();
  }

  void _arriveAtPickup(String rideId) {
    context.read<RideBloc>().add(ArriveAtPickup(rideId: rideId));
  }

  void _startRide(String rideId) {
    context.read<RideBloc>().add(StartRide(rideId: rideId));
  }

  void _completeRide(String rideId) {
    context.read<RideBloc>().add(CompleteRide(rideId: rideId));
  }

  void _cancelRide(String rideId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride'),
        content: const Text('Are you sure you want to cancel this ride? This may affect your ratings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<RideBloc>().add(
                    CancelRide(
                      rideId: rideId,
                      reason: 'Cancelled by driver',
                    ),
                  );
            },
            child: const Text('Yes'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideBloc, RideState>(
      listener: (context, state) {
        if (state is RideInitial) {
          // No active ride, navigate back to home
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is RideCancelledState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ride was cancelled: ${state.reason}'),
              backgroundColor: Colors.red,
            ),
          );

          // After a delay, return to home screen
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else if (state is NewMessageReceived) {
          // Add message to chat if it's from rider
          if (state.senderRole == 'rider') {
            setState(() {
              _messages.add(
                RideMessage(
                  senderId: state.senderId,
                  senderRole: state.senderRole,
                  message: state.message,
                  timestamp: state.timestamp,
                ),
              );
            });
          }
        }
      },
      builder: (context, state) {
        if (state is RideLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Ride accepted state
        if (state is RideAcceptedState) {
          return _buildRideAcceptedUI(state);
        }

        // Arrived at pickup state
        if (state is ArrivedAtPickupState) {
          return _buildArrivedAtPickupUI(state);
        }

        // Ride in progress state
        if (state is RideInProgressState) {
          return _buildRideInProgressUI(state);
        }

        // Ride completed state
        if (state is RideCompletedState) {
          return _buildRideCompletedUI(state);
        }

        // Fallback
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ride'),
            backgroundColor: AppConfig.primaryColor,
          ),
          body: const Center(
            child: Text('No active ride found'),
          ),
        );
      },
    );
  }

  Widget _buildRideAcceptedUI(RideAcceptedState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Rider'),
        backgroundColor: AppConfig.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _toggleChat,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map showing route to pickup location
          MapWidget(
            currentLocation: _currentLocation,
            destinationLocation: LatLng(
              state.ride.pickup.location.latitude,
              state.ride.pickup.location.longitude,
            ),
            showDirections: true,
            isDriverMode: true,
          ),

          // Bottom panel with rider info and actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'En route to pickup ${state.rider.firstName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppConfig.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          state.ride.formattedFare,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppConfig.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rider info card (expandable)
                  RiderInfoCard(
                    rider: state.rider,
                    isExpanded: _isRiderDetailsExpanded,
                    onExpand: _toggleRiderDetails,
                  ),

                  // Pickup address
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(state.ride.pickup.address),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _cancelRide(state.ride.id),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _arriveAtPickup(state.ride.id),
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Arrived'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConfig.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat overlay
          if (_isChatExpanded)
            ChatInterface(
              messages: _messages,
              controller: _messageController,
              onSend: () => _sendMessage(state.ride.id),
              onClose: _toggleChat,
            ),
        ],
      ),
    );
  }

  Widget _buildArrivedAtPickupUI(ArrivedAtPickupState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting for Rider'),
        backgroundColor: AppConfig.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _toggleChat,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map showing pickup location
          MapWidget(
            currentLocation: _currentLocation,
            destinationLocation: LatLng(
              state.ride.pickup.location.latitude,
              state.ride.pickup.location.longitude,
            ),
            showCircle: true,
            isDriverMode: true,
          ),

          // Bottom panel with rider info and actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Waiting for ${state.rider.firstName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        Text(
                          state.ride.formattedFare,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rider info card (expandable)
                  RiderInfoCard(
                    rider: state.rider,
                    isExpanded: _isRiderDetailsExpanded,
                    onExpand: _toggleRiderDetails,
                  ),

                  // Pickup and destination addresses
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(state.ride.pickup.address),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Destination location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Destination',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(state.ride.destination.address),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _cancelRide(state.ride.id),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _startRide(state.ride.id),
                                icon: const Icon(Icons.directions_car),
                                label: const Text('Start Ride'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConfig.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat overlay
          if (_isChatExpanded)
            ChatInterface(
              messages: _messages,
              controller: _messageController,
              onSend: () => _sendMessage(state.ride.id),
              onClose: _toggleChat,
            ),
        ],
      ),
    );
  }

  Widget _buildRideInProgressUI(RideInProgressState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride in Progress'),
        backgroundColor: AppConfig.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _toggleChat,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map showing route to destination
          MapWidget(
            currentLocation: _currentLocation,
            destinationLocation: LatLng(
              state.ride.destination.location.latitude,
              state.ride.destination.location.longitude,
            ),
            showDirections: true,
            isDriverMode: true,
          ),

          // Bottom panel with rider info and actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'En route to ${state.rider.firstName}\'s destination',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Text(
                          state.ride.formattedFare,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rider info card (expandable)
                  RiderInfoCard(
                    rider: state.rider,
                    isExpanded: _isRiderDetailsExpanded,
                    onExpand: _toggleRiderDetails,
                  ),

                  // Destination address
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Destination',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(state.ride.destination.address),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Ride stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              Icons.route,
                              '${state.ride.estimatedDistance.toStringAsFixed(1)} km',
                              'Distance',
                            ),
                            _buildStatCard(
                              Icons.timer,
                              '${state.ride.estimatedDuration} min',
                              'Est. Time',
                            ),
                            _buildStatCard(
                              Icons.attach_money,
                              state.ride.formattedFare,
                              'Fare',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _completeRide(state.ride.id),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Complete Ride'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat overlay
          if (_isChatExpanded)
            ChatInterface(
              messages: _messages,
              controller: _messageController,
              onSend: () => _sendMessage(state.ride.id),
              onClose: _toggleChat,
            ),
        ],
      ),
    );
  }

  Widget _buildRideCompletedUI(RideCompletedState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Completed'),
        backgroundColor: AppConfig.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ride Completed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You earned ${state.ride.formattedFare}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Thank you for driving with Cabby!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You will be automatically redirected to the home screen to accept new rides.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppConfig.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
