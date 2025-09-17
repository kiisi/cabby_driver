import 'dart:async';

import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/resources/theme_manager.dart';
import 'package:cabby_driver/core/routes/app_router.dart';
import 'package:cabby_driver/core/services/location_service.dart';
import 'package:cabby_driver/data/network/socket.dart';
import 'package:cabby_driver/features/home/blocs/ride/ride_bloc.dart';
import 'package:cabby_driver/features/home/location-appbar.dart/bloc/location_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    initializeMapRenderer();
  }

  await initAppModule();

  runApp(MyApp());
}

Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

/// Initializes map renderer to the `latest` renderer type for Android platform.
///
/// The renderer must be requested before creating GoogleMap instances,
/// as the renderer can be initialized only once per application context.
Future<AndroidMapRenderer?> initializeMapRenderer() async {
  if (_initializedRendererCompleter != null) {
    return _initializedRendererCompleter!.future;
  }

  final Completer<AndroidMapRenderer?> completer = Completer<AndroidMapRenderer?>();
  _initializedRendererCompleter = completer;

  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    unawaited(mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest)
        .then((AndroidMapRenderer initializedRenderer) => completer.complete(initializedRenderer)));
  } else {
    completer.complete(null);
  }

  return completer.future;
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final LocationService _locationService = LocationService();

  final LocationServiceBloc _locationServiceBloc = getIt<LocationServiceBloc>();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();

    _bind();
  }

  _bind() async {
    Position position = await _locationService.determinePosition();
    await _appPreferences.setLatitude(position.latitude);
    await _appPreferences.setLongitude(position.longitude);

    final positionStream = _geolocatorPlatform.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
    );
    positionStream.handleError((error) {
      _locationServiceBloc.add(LocationServiceDisabled());
    }).listen((position) {
      _locationServiceBloc.add(LocationServiceEnabled(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationServiceBloc>(
          create: (BuildContext context) => getIt<LocationServiceBloc>(),
        ),
        BlocProvider<RideBloc>(
          create: (BuildContext context) => getIt<RideBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Cabby Driver',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
