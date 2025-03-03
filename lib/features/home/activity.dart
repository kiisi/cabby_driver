import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/services/location_service.dart';
import 'package:cabby_driver/data/request/activity_request.dart';
import 'package:cabby_driver/domain/usecase/activity_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  GoogleMapController? controller;

  final LocationService _locationService = LocationService();

  late CameraPosition _kGooglePlex;
  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final ActivityUsecase _activityUsecase = getIt<ActivityUsecase>();

  bool isOnline = false;

  @override
  void initState() {
    isOnline = _appPreferences.getIsOnlineStatus();

    _kGooglePlex = const CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792),
      zoom: 18,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }

  Future<void> _moveToCurrentLocation() async {
    Position position = await _locationService.determinePosition();

    await controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 17),
      ),
    );
  }

  void toggleOnlineStatus() async {
    setState(() {
      isOnline = !isOnline;
    });

    (await _activityUsecase.execute(
      SetOnlineStatusRequest(id: _appPreferences.getUserId(), isOnline: isOnline),
    ))
        .fold((failure) {
      CustomFlushbar.showErrorFlushBar(context: context, message: failure.message);
    }, (success) {
      CustomFlushbar.showSuccessSnackBar(
        context: context,
        // flushbarPosition: FlushbarPosition.TOP,
        message: success.message ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            gestureRecognizers: //
                <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Builder(
                  builder: (context) => Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(AppSize.s50),
                    child: SwipeButton(
                      width: double.infinity,
                      thumb: const Icon(
                        Icons.double_arrow_rounded,
                        color: Colors.white,
                      ),
                      activeThumbColor: isOnline ? Colors.green : Colors.black,
                      activeTrackColor: isOnline ? Colors.green : const Color(0xfff6f6f6),
                      onSwipeEnd: () {
                        toggleOnlineStatus();
                      },
                      child: Text(
                        isOnline ? "ONLINE" : "GO ONLINE",
                        style: TextStyle(
                          color: isOnline ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
