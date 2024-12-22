import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/data/network/app_api.dart';
import 'package:cabby_driver/data/network/dio_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // SharedPreferences instance
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Register AppPreferences as a singleton
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences(getIt()));

  // dio factory
  getIt.registerLazySingleton<DioFactory>(() => DioFactory(getIt()));

  // app service client
  final dio = await getIt<DioFactory>().getDio();
  getIt.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // getIt.registerLazySingleton<LocationServiceBloc>(() => LocationServiceBloc());

  // getIt.registerLazySingleton<GoogleMapsServiceClient>(
  //     () => GoogleMapsServiceClient(dio));

  // getIt.registerLazySingleton<GoogleMapsRemoteDataSource>(
  //     () => GoogleMapsRemoteDataSourceImpl(getIt(), getIt()));

  // getIt.registerLazySingleton<GoogleMapsRepository>(
  //     () => GoogleMapsRepositoryImpl(getIt()));
}
