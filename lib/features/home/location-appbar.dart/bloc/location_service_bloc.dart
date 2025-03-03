import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'location_service_event.dart';
part 'location_service_state.dart';

class LocationServiceBloc
    extends Bloc<LocationServiceEvent, LocationServiceState> {
  LocationServiceBloc() : super(LocationServiceState()) {
    on<LocationServiceEvent>((event, emit) {
      // print("==========LocationServiceBloc=====================");
      // print("Running location block");
      // print(event);
      if (event is LocationServiceEnabled) {
        emit(state.copyWith(
          isLocationEnabled: true,
          latitude: event.latitude,
          longitude: event.longitude,
        ));
      } else if (event is LocationServiceDisabled) {
        emit(state.copyWith(isLocationEnabled: false));
      } else {
        emit(state.copyWith(isLocationEnabled: false));
      }
    });
  }
}
