import 'package:cabby_driver/core/common/constant.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/auth/login')
  Future<BaseResponse> login({
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST('/auth/register')
  Future<BaseResponse> register({
    @Field("firstName") required String firstName,
    @Field("lastName") required String lastName,
    @Field("email") required String email,
    @Field("countryCode") required String countryCode,
    @Field("phoneNumber") required String phoneNumber,
  });

  @POST('/auth/get-started/user-info')
  Future<BaseResponse> getStartedUserInfo({
    @Field("email") required String email,
    @Field("firstName") required String firstName,
    @Field("lastName") required String lastName,
    @Field("gender") required String gender,
    @Field("countryCode") required String countryCode,
    @Field("phoneNumber") required String phoneNumber,
  });

  @GET('/auth/user-auth')
  Future<BaseResponse> userAuth();
}
