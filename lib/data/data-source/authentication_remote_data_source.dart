import 'package:cabby_driver/data/network/app_api.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<BaseResponse> loginRequest(LoginRequest loginRequest);

  Future<BaseResponse<RegisterResponse>> registerRequest(
      RegisterRequest registerRequest);

  Future<BaseResponse> sendEmailOtpRequest(
      SendEmailOtpRequest sendEmailOtpRequest);

  Future<BaseResponse> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final AppServiceClient _appServiceClient;

  AuthenticationRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<BaseResponse> loginRequest(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
      email: loginRequest.email,
      password: loginRequest.password,
    );
  }

  @override
  Future<BaseResponse<RegisterResponse>> registerRequest(
      RegisterRequest registerRequest) async {
    return await _appServiceClient.register(
      firstName: registerRequest.firstName,
      lastName: registerRequest.lastName,
      email: registerRequest.email,
      password: registerRequest.password,
    );
  }

  @override
  Future<BaseResponse> sendEmailOtpRequest(
      SendEmailOtpRequest sendEmailOtpRequest) async {
    return await _appServiceClient.sendEmailOtp(
      email: sendEmailOtpRequest.email,
    );
  }

  @override
  Future<BaseResponse> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest) async {
    return await _appServiceClient.emailOtpVerify(
      email: emailOtpVerifyRequest.email,
    );
  }
}
