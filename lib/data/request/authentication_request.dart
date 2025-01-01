class LoginRequest {
  String email;
  String password;

  LoginRequest({required this.email, required this.password});
}

class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class SendEmailOtpRequest {
  String email;

  SendEmailOtpRequest({
    required this.email,
  });
}

class EmailOtpVerifyRequest {
  String email;

  EmailOtpVerifyRequest({
    required this.email,
  });
}
