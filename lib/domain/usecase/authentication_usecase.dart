import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/repository/authentication_repo.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:cabby_driver/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginRequest, BaseResponse<LoginResponse>> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<LoginResponse>>> execute(LoginRequest input) async {
    return await _authenticationRepository.loginRequest(input);
  }
}

class RegisterUseCase implements BaseUseCase<RegisterRequest, BaseResponse<RegisterResponse>> {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<RegisterResponse>>> execute(RegisterRequest input) async {
    return await _authenticationRepository.registerRequest(input);
  }
}

class RegisterDetailsUseCase
    implements BaseUseCase<RegisterDetailsRequest, BaseResponse<RegisterDetailsResponse>> {
  final AuthenticationRepository _authenticationRepository;

  RegisterDetailsUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<RegisterDetailsResponse>>> execute(RegisterDetailsRequest input) async {
    return await _authenticationRepository.registerDetailsRequest(input);
  }
}

class SendEmailOtpUseCase implements BaseUseCase<SendEmailOtpRequest, BaseResponse> {
  final AuthenticationRepository _authenticationRepository;

  SendEmailOtpUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse>> execute(SendEmailOtpRequest input) async {
    return await _authenticationRepository.sendEmailOtpRequest(input);
  }
}

class EmailOtpVerifyUseCase
    implements BaseUseCase<EmailOtpVerifyRequest, BaseResponse<EmailOtpVerifyResponse>> {
  final AuthenticationRepository _authenticationRepository;

  EmailOtpVerifyUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<EmailOtpVerifyResponse>>> execute(EmailOtpVerifyRequest input) async {
    return await _authenticationRepository.emailOtpVerifyRequest(input);
  }
}

class ResetPasswordUseCase implements BaseUseCase<ResetPasswordRequest, BaseResponse> {
  final AuthenticationRepository _authenticationRepository;

  ResetPasswordUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse>> execute(ResetPasswordRequest input) async {
    return await _authenticationRepository.resetPasswordRequest(input);
  }
}

class DriverPersonalInfoUseCase
    implements BaseUseCase<DriverPersonalInfoRequest, BaseResponse<DriverPersonalInfoResponse>> {
  final AuthenticationRepository _authenticationRepository;

  DriverPersonalInfoUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<DriverPersonalInfoResponse>>> execute(
      DriverPersonalInfoRequest input) async {
    return await _authenticationRepository.driverPersonalInfoRequest(input);
  }
}

class DriverLicenseInfoUseCase
    implements BaseUseCase<DriverLicenseInfoRequest, BaseResponse<DriverLicenseInfoResponse>> {
  final AuthenticationRepository _authenticationRepository;

  DriverLicenseInfoUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<DriverLicenseInfoResponse>>> execute(
      DriverLicenseInfoRequest input) async {
    return await _authenticationRepository.driverLicenseInfoRequest(input);
  }
}

class DriverVehicleInfoUseCase
    implements BaseUseCase<DriverVehicleInfoRequest, BaseResponse<DriverVehicleInfoResponse>> {
  final AuthenticationRepository _authenticationRepository;

  DriverVehicleInfoUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<DriverVehicleInfoResponse>>> execute(
      DriverVehicleInfoRequest input) async {
    return await _authenticationRepository.driverVehicleInfoRequest(input);
  }
}

class DriverVehiclePhotosUseCase
    implements BaseUseCase<DriverVehiclePhotosRequest, BaseResponse<DriverVehiclePhotosResponse>> {
  final AuthenticationRepository _authenticationRepository;

  DriverVehiclePhotosUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<DriverVehiclePhotosResponse>>> execute(
      DriverVehiclePhotosRequest input) async {
    return await _authenticationRepository.driverVehiclePhotosRequest(input);
  }
}
