import 'package:cabby_driver/data/data-source/authentication_remote_data_source.dart';
import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthenticationRepository {
  // Login Request
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginRequest(LoginRequest loginRequest);
  // Register Request
  Future<Either<Failure, BaseResponse<RegisterResponse>>> registerRequest(RegisterRequest registerRequest);
  // Register Details Request
  Future<Either<Failure, BaseResponse<RegisterDetailsResponse>>> registerDetailsRequest(
      RegisterDetailsRequest registerDetailsRequest);
  // Driver Personal Info Request
  Future<Either<Failure, BaseResponse<DriverPersonalInfoResponse>>> driverPersonalInfoRequest(
      DriverPersonalInfoRequest driverPersonalInfoRequest);
  // Driver License Request
  Future<Either<Failure, BaseResponse<DriverLicenseInfoResponse>>> driverLicenseInfoRequest(
      DriverLicenseInfoRequest driverLicenseInfoRequest);
  // Driver Vehicle Info Request
  Future<Either<Failure, BaseResponse<DriverVehicleInfoResponse>>> driverVehicleInfoRequest(
      DriverVehicleInfoRequest driverVehicleInfoRequest);
  // Driver Vehicle Photos Request
  Future<Either<Failure, BaseResponse<DriverVehiclePhotosResponse>>> driverVehiclePhotosRequest(
      DriverVehiclePhotosRequest driverVehiclePhotosRequest);
  // Send Email Otp Request
  Future<Either<Failure, BaseResponse>> sendEmailOtpRequest(SendEmailOtpRequest sendEmailOtpRequest);
  // Email Otp Verify Request
  Future<Either<Failure, BaseResponse<EmailOtpVerifyResponse>>> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest);
  // Reset Password Request
  Future<Either<Failure, BaseResponse>> resetPasswordRequest(ResetPasswordRequest resetPasswordRequest);
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;

  AuthenticationRepositoryImpl(this._authenticationRemoteDataSource);

  @override
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginRequest(LoginRequest loginRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.loginRequest(loginRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<RegisterResponse>>> registerRequest(
      RegisterRequest registerRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.registerRequest(registerRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> sendEmailOtpRequest(SendEmailOtpRequest sendEmailOtpRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.sendEmailOtpRequest(sendEmailOtpRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<EmailOtpVerifyResponse>>> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.emailOtpVerifyRequest(emailOtpVerifyRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> resetPasswordRequest(
      ResetPasswordRequest resetPasswordRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.resetPasswordRequest(resetPasswordRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<RegisterDetailsResponse>>> registerDetailsRequest(
      RegisterDetailsRequest registerDetailsRequest) async {
    try {
      final response = await _authenticationRemoteDataSource.registerDetailsRequest(registerDetailsRequest);
      return Right(response);
    } catch (error) {
      print(error);
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<DriverLicenseInfoResponse>>> driverLicenseInfoRequest(
      DriverLicenseInfoRequest driverLicenseInfoRequest) async {
    try {
      final response =
          await _authenticationRemoteDataSource.driverLicenseInfoRequest(driverLicenseInfoRequest);
      return Right(response);
    } catch (error) {
      print(error);
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<DriverPersonalInfoResponse>>> driverPersonalInfoRequest(
      DriverPersonalInfoRequest driverPersonalInfoRequest) async {
    try {
      final response =
          await _authenticationRemoteDataSource.driverPersonalInfoRequest(driverPersonalInfoRequest);
      return Right(response);
    } catch (error) {
      print(error);
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<DriverVehicleInfoResponse>>> driverVehicleInfoRequest(
      DriverVehicleInfoRequest driverVehicleInfoRequest) async {
    try {
      final response =
          await _authenticationRemoteDataSource.driverVehicleInfoRequest(driverVehicleInfoRequest);
      return Right(response);
    } catch (error) {
      print(error);
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, BaseResponse<DriverVehiclePhotosResponse>>> driverVehiclePhotosRequest(
      DriverVehiclePhotosRequest driverVehiclePhotosRequest) async {
    try {
      final response =
          await _authenticationRemoteDataSource.driverVehiclePhotosRequest(driverVehiclePhotosRequest);
      return Right(response);
    } catch (error) {
      print(error);
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }
}
