import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/repository/authentication_repo.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:cabby_driver/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginRequest, BaseResponse> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse>> execute(LoginRequest input) async {
    return await _authenticationRepository.loginRequest(input);
  }
}

class RegisterUseCase
    implements BaseUseCase<RegisterRequest, BaseResponse<RegisterResponse>> {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse<RegisterResponse>>> execute(
      RegisterRequest input) async {
    return await _authenticationRepository.registerRequest(input);
  }
}

class SendEmailOtpUseCase
    implements BaseUseCase<SendEmailOtpRequest, BaseResponse> {
  final AuthenticationRepository _authenticationRepository;

  SendEmailOtpUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      SendEmailOtpRequest input) async {
    return await _authenticationRepository.sendEmailOtpRequest(input);
  }
}

class EmailOtpVerifyUseCase
    implements BaseUseCase<EmailOtpVerifyRequest, BaseResponse> {
  final AuthenticationRepository _authenticationRepository;

  EmailOtpVerifyUseCase(this._authenticationRepository);

  @override
  Future<Either<Failure, BaseResponse>> execute(
      EmailOtpVerifyRequest input) async {
    return await _authenticationRepository.emailOtpVerifyRequest(input);
  }
}
