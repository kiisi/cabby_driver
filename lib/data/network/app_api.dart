import 'package:cabby_driver/core/common/constant.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/auth/driver/login')
  Future<BaseResponse> login({
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST('/auth/driver/register')
  Future<BaseResponse<RegisterResponse>> register({
    @Field("firstName") required String firstName,
    @Field("lastName") required String lastName,
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST('/auth/driver/send-email-otp')
  Future<BaseResponse> sendEmailOtp({
    @Field("email") required String email,
  });

  @POST('/auth/driver/email-otp-verify')
  Future<BaseResponse> emailOtpVerify({
    @Field("email") required String email,
  });

  @GET('/auth/user-auth')
  Future<BaseResponse> userAuth();
}
