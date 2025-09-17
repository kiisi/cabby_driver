import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_config.dart';
import 'package:cabby_driver/data/models/driver_model.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_bloc.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_event.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_state.dart';
import 'package:cabby_driver/features/widgets/map_widget.dart';
import 'package:cabby_driver/features/widgets/online_switch.dart';
import 'package:cabby_driver/features/widgets/ride_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DriverModel? _driver;
  bool _isOnline = false;
  Timer? _locationUpdateTimer;
  LatLng _currentLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    // Initialize location updates
    _startLocationUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check for active rides when screen loads
      context.read<RideBloc>().add(GetActiveRide());
    });
  }

  @override
  void dispose() {
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
    if (_isOnline) {
      context.read<RideBloc>().add(
            UpdateDriverLocation(
              latitude: latitude,
              longitude: longitude,
            ),
          );
    }
  }

  void _toggleDriverAvailability(bool isAvailable) {
    setState(() {
      _isOnline = isAvailable;
    });

    context.read<RideBloc>().add(ToggleAvailability(isAvailable));
  }

  void _viewRideRequest(BuildContext context, String rideId, String riderId) {
    // Navigate to ride request details or show a bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: RideRequestCard(
              rideId: rideId,
              riderId: riderId,
              onAccept: () {
                Navigator.of(context).pop();
                context.read<RideBloc>().add(
                      AcceptRide(
                        rideId: rideId,
                        riderId: riderId,
                      ),
                    );
              },
              onReject: () {
                Navigator.of(context).pop();
                context.read<RideBloc>().add(
                      RejectRide(rideId: rideId),
                    );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideBloc, RideState>(
      listener: (context, rideState) {
        if (rideState is RideAcceptedState ||
            rideState is ArrivedAtPickupState ||
            rideState is RideInProgressState) {
          // Navigate to ride in progress screen
          Navigator.of(context).pushReplacementNamed('/ride');
        }
      },
      builder: (context, rideState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppConfig.appName),
            backgroundColor: AppConfig.primaryColor,
            elevation: 0,
            actions: [
              // Account button
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
            ],
          ),
          drawer: _buildDrawer(),
          body: Stack(
            children: [
              // Map
              MapWidget(
                currentLocation: _currentLocation,
                isDriverMode: true,
              ),

              // Online/offline switch
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: OnlineSwitch(
                  isOnline: _isOnline,
                  onToggle: _toggleDriverAvailability,
                ),
              ),

              // Bottom panel
              if (rideState is DriverAvailableState)
                _buildAvailablePanel(context, rideState)
              else if (rideState is DriverOfflineState)
                _buildOfflinePanel()
              else if (rideState is RideLoading)
                _buildLoadingPanel()
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    if (_driver == null) return const Drawer();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${_driver!.firstName} ${_driver!.lastName}'),
            accountEmail: Text(_driver!.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                '${_driver!.firstName[0]}${_driver!.lastName[0]}',
                style: TextStyle(
                  fontSize: 24,
                  color: AppConfig.primaryColor,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('My Rides'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/rides');
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Earnings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/earnings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/support');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        // context.read<AuthBloc>().add(LogoutRequested());
                      },
                      child: const Text('Logout'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePanel(BuildContext context, DriverAvailableState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              state.nearbyRides.isEmpty ? 'No Ride Requests Nearby' : 'Nearby Ride Requests',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (state.nearbyRides.isEmpty)
              Column(
                children: [
                  const Icon(
                    Icons.search,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Waiting for ride requests...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You\'re online and visible to riders',
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.nearbyRides.length,
                  itemBuilder: (context, index) {
                    final ride = state.nearbyRides[index];
                    return SizedBox(
                      width: 300,
                      child: Card(
                        margin: const EdgeInsets.only(right: 12, bottom: 8),
                        child: InkWell(
                          onTap: () => _viewRideRequest(
                            context,
                            ride.id,
                            ride.riderId,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      ride.rider?.fullName ?? 'Rider',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      ride.formattedFare,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppConfig.primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ride.pickup.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ride.destination.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${ride.estimatedDistance.toStringAsFixed(1)} km',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${ride.estimatedDuration} min',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          context.read<RideBloc>().add(
                                                RejectRide(rideId: ride.id),
                                              );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(color: Colors.red),
                                        ),
                                        child: const Text('Decline'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<RideBloc>().add(
                                                AcceptRide(
                                                  rideId: ride.id,
                                                  riderId: ride.riderId,
                                                ),
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppConfig.primaryColor,
                                        ),
                                        child: const Text('Accept'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflinePanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
            const Icon(
              Icons.offline_bolt,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              'You\'re Offline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Go online to start receiving ride requests',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _toggleDriverAvailability(true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppConfig.primaryColor,
              ),
              child: const Text('Go Online'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
