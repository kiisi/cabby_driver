part of 'location_service_bloc.dart';

@immutable
abstract class LocationServiceEvent {}

class LocationServiceEnabled extends LocationServiceEvent {
  final double latitude;
  final double longitude;

  LocationServiceEnabled({required this.latitude, required this.longitude});
}

class LocationServiceDisabled extends LocationServiceEvent {}
