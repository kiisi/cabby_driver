import 'package:cabby_driver/app/app_config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destinationLocation;
  final LatLng? pickupLocation;
  final bool showDirections;
  final bool showCircle;
  final bool isDriverMode;

  const MapWidget({
    Key? key,
    required this.currentLocation,
    this.destinationLocation,
    this.pickupLocation,
    this.showDirections = false,
    this.showCircle = false,
    this.isDriverMode = false,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _updateMapFeatures();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentLocation != widget.currentLocation ||
        oldWidget.destinationLocation != widget.destinationLocation ||
        oldWidget.pickupLocation != widget.pickupLocation ||
        oldWidget.showDirections != widget.showDirections ||
        oldWidget.showCircle != widget.showCircle) {
      _updateMapFeatures();

      // Update camera position if current location changes
      if (oldWidget.currentLocation != widget.currentLocation && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(widget.currentLocation),
        );
      }
    }
  }

  void _updateMapFeatures() {
    // Clear previous markers and polylines
    _markers = {};
    _polylines = {};
    _circles = {};

    // Add current location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: widget.currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          widget.isDriverMode ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueRed,
        ),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    // Add destination marker if available
    if (widget.destinationLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    // Add pickup marker if available
    if (widget.pickupLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: widget.pickupLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );
    }

    // Add polyline for directions if requested
    if (widget.showDirections && widget.destinationLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            widget.currentLocation,
            widget.destinationLocation!,
          ],
          color: AppConfig.primaryColor,
          width: 5,
        ),
      );
    }

    // Add circle if requested
    if (widget.showCircle) {
      _circles.add(
        Circle(
          circleId: const CircleId('search_area'),
          center: widget.currentLocation,
          radius: 100, // 100 meters
          fillColor: AppConfig.primaryColor.withOpacity(0.2),
          strokeColor: AppConfig.primaryColor,
          strokeWidth: 1,
        ),
      );
    }

    // Trigger a rebuild
    if (mounted) {
      setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Apply custom map style if needed
    // _mapController!.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation,
        zoom: widget.isDriverMode ? AppConfig.navigationZoom : AppConfig.defaultZoom,
      ),
      markers: _markers,
      polylines: _polylines,
      circles: _circles,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      trafficEnabled: widget.isDriverMode, // Enable traffic for drivers
    );
  }
}
