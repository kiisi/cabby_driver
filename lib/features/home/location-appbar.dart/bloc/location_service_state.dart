part of 'location_service_bloc.dart';

class LocationServiceState {
  final bool? isLocationEnabled;
  final double? latitude;
  final double? longitude;

  LocationServiceState({this.isLocationEnabled, this.latitude, this.longitude});

  LocationServiceState copyWith(
      {bool? isLocationEnabled, double? latitude, double? longitude}) {
    return LocationServiceState(
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
