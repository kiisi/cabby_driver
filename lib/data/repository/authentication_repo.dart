import 'package:cabby_driver/data/data-source/authentication_remote_data_source.dart';
import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthenticationRepository {
  Future<Either<Failure, BaseResponse<LoginResponse>>> loginRequest(LoginRequest loginRequest);
  Future<Either<Failure, BaseResponse<RegisterResponse>>> registerRequest(RegisterRequest registerRequest);
  Future<Either<Failure, BaseResponse<RegisterDetailsResponse>>> registerDetailsRequest(
      RegisterDetailsRequest registerDetailsRequest);
  Future<Either<Failure, BaseResponse>> sendEmailOtpRequest(SendEmailOtpRequest sendEmailOtpRequest);
  Future<Either<Failure, BaseResponse<EmailOtpVerifyResponse>>> emailOtpVerifyRequest(
      EmailOtpVerifyRequest emailOtpVerifyRequest);
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
}
