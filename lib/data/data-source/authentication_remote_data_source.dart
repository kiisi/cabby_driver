import 'package:cabby_driver/data/network/app_api.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<BaseResponse<LoginResponse>> loginRequest(LoginRequest loginRequest);

  Future<BaseResponse<RegisterResponse>> registerRequest(RegisterRequest registerRequest);

  Future<BaseResponse<RegisterDetailsResponse>> registerDetailsRequest(
      RegisterDetailsRequest registerDetailsRequest);

  Future<BaseResponse> sendEmailOtpRequest(SendEmailOtpRequest sendEmailOtpRequest);

  Future<BaseResponse<EmailOtpVerifyResponse>> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest);

  Future<BaseResponse> resetPasswordRequest(ResetPasswordRequest resetPasswordRequest);
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  final AppServiceClient _appServiceClient;

  AuthenticationRemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<BaseResponse<LoginResponse>> loginRequest(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
      email: loginRequest.email,
      password: loginRequest.password,
    );
  }

  @override
  Future<BaseResponse<RegisterResponse>> registerRequest(RegisterRequest registerRequest) async {
    return await _appServiceClient.register(
      firstName: registerRequest.firstName,
      lastName: registerRequest.lastName,
      email: registerRequest.email,
      password: registerRequest.password,
    );
  }

  @override
  Future<BaseResponse> sendEmailOtpRequest(SendEmailOtpRequest sendEmailOtpRequest) async {
    return await _appServiceClient.sendEmailOtp(
      email: sendEmailOtpRequest.email,
    );
  }

  @override
  Future<BaseResponse<EmailOtpVerifyResponse>> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest) async {
    return await _appServiceClient.emailOtpVerify(
      email: emailOtpVerifyRequest.email,
      otp: emailOtpVerifyRequest.otp,
    );
  }

  @override
  Future<BaseResponse> resetPasswordRequest(ResetPasswordRequest resetPasswordRequest) async {
    return await _appServiceClient.resetPassword(
      email: resetPasswordRequest.email,
      emailOtpId: resetPasswordRequest.emailOtpId,
      newPassword: resetPasswordRequest.newPassword,
      confirmPassword: resetPasswordRequest.confirmPassword,
    );
  }

  @override
  Future<BaseResponse<RegisterDetailsResponse>> registerDetailsRequest(
      RegisterDetailsRequest registerDetailsRequest) async {
    return await _appServiceClient.registerDetails(
      email: registerDetailsRequest.email,
      countryCode: registerDetailsRequest.countryCode,
      countryOfIssue: registerDetailsRequest.countryOfIssue,
      currentAddress: registerDetailsRequest.currentAddress,
      dateOfBirth: registerDetailsRequest.dateOfBirth,
      driverLicenseExpirationDate: registerDetailsRequest.driverLicenseExpirationDate,
      driverLicenseNumber: registerDetailsRequest.driverLicenseNumber,
      driverLicensePhotoBack: registerDetailsRequest.driverLicensePhotoBack,
      driverLicensePhotoFront: registerDetailsRequest.driverLicensePhotoFront,
      driverLicenseType: registerDetailsRequest.driverLicenseType,
      fullLegalName: registerDetailsRequest.fullLegalName,
      phoneNumber: registerDetailsRequest.phoneNumber,
      profilePhoto: registerDetailsRequest.profilePhoto,
      vehicleColor: registerDetailsRequest.vehicleColor,
      vehicleLicensePlateNumber: registerDetailsRequest.vehicleLicensePlateNumber,
      vehicleMake: registerDetailsRequest.vehicleMake,
      vehicleModel: registerDetailsRequest.vehicleModel,
      vehiclePhotoBackView: registerDetailsRequest.vehiclePhotoBackView,
      vehiclePhotoFrontView: registerDetailsRequest.vehiclePhotoFrontView,
      vehiclePhotoLeftSideView: registerDetailsRequest.vehiclePhotoLeftSideView,
      vehiclePhotoRightSideView: registerDetailsRequest.vehiclePhotoRightSideView,
      vehicleRegistrationNumber: registerDetailsRequest.vehicleRegistrationNumber,
      vehicleYear: registerDetailsRequest.vehicleYear,
    );
  }
}
