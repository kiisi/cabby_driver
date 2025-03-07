import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/data/data-source/activity_remote_data_source.dart';
import 'package:cabby_driver/data/data-source/authentication_remote_data_source.dart';
import 'package:cabby_driver/data/data-source/cloudinary_remote_data_source.dart';
import 'package:cabby_driver/data/network/app_api.dart';
import 'package:cabby_driver/data/network/cloudinary_api.dart';
import 'package:cabby_driver/data/network/dio_factory.dart';
import 'package:cabby_driver/data/repository/activity_repo.dart';
import 'package:cabby_driver/data/repository/authentication_repo.dart';
import 'package:cabby_driver/data/repository/cloudinary_repo.dart';
import 'package:cabby_driver/domain/usecase/activity_usecase.dart';
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:cabby_driver/domain/usecase/cloudinary_usecase.dart';
import 'package:cabby_driver/features/home/location-appbar.dart/bloc/location_service_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // SharedPreferences instance
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Register AppPreferences as a singleton
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences(getIt()));

  // location service
  getIt.registerLazySingleton<LocationServiceBloc>(() => LocationServiceBloc());

  // dio factory
  getIt.registerLazySingleton<DioFactory>(() => DioFactory(getIt()));

  // app service client
  final dio = await getIt<DioFactory>().getDio();
  getIt.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // cloudinary service client
  getIt.registerLazySingleton<CloudinaryServiceClient>(() => CloudinaryServiceClient(dio));

  // getIt.registerLazySingleton<LocationServiceBloc>(() => LocationServiceBloc());

  // getIt.registerLazySingleton<GoogleMapsServiceClient>(
  //     () => GoogleMapsServiceClient(dio));

  // getIt.registerLazySingleton<GoogleMapsRemoteDataSource>(
  //     () => GoogleMapsRemoteDataSourceImpl(getIt(), getIt()));

  // getIt.registerLazySingleton<GoogleMapsRepository>(
  //     () => GoogleMapsRepositoryImpl(getIt()));

  // Authentication

  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(getIt()));

  getIt.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(getIt()));

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));

  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()));

  getIt.registerLazySingleton<RegisterDetailsUseCase>(() => RegisterDetailsUseCase(getIt()));

  getIt.registerLazySingleton<SendEmailOtpUseCase>(() => SendEmailOtpUseCase(getIt()));

  getIt.registerLazySingleton<EmailOtpVerifyUseCase>(() => EmailOtpVerifyUseCase(getIt()));

  getIt.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(getIt()));

  // cloudinary
  getIt.registerLazySingleton<CloudinaryRemoteDataSource>(() => CloudinaryRemoteDataSourceImpl(getIt()));

  getIt.registerLazySingleton<CloudinaryRepository>(() => CloudinaryRepositoryImpl(getIt()));

  getIt.registerLazySingleton<ImageUploadUseCase>(() => ImageUploadUseCase(getIt()));

  // activity
  getIt.registerLazySingleton<ActivityRemoteDataSource>(() => ActivityRemoteDataSourceImpl(getIt()));

  getIt.registerLazySingleton<ActivityRepository>(() => ActivityRepositoryImpl(getIt()));

  getIt.registerLazySingleton<ActivityUsecase>(() => ActivityUsecase(getIt()));
}
