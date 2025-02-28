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
  String otp;

  EmailOtpVerifyRequest({
    required this.email,
    required this.otp,
  });
}

class ResetPasswordRequest {
  String email;
  String emailOtpId;
  String newPassword;
  String confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.emailOtpId,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class RegisterDetailsRequest {
  String email;
  String countryCode;
  String phoneNumber;
  String profilePhoto;
  String fullLegalName;
  String dateOfBirth;
  String currentAddress;
  String driverLicenseNumber;
  String driverLicenseExpirationDate;
  String driverLicenseType;
  String countryOfIssue;
  String driverLicensePhotoFront;
  String driverLicensePhotoBack;
  String vehicleMake;
  String vehicleModel;
  String vehicleYear;
  String vehicleLicensePlateNumber;
  String vehicleColor;
  String vehicleRegistrationNumber;
  String vehiclePhotoFrontView;
  String vehiclePhotoBackView;
  String vehiclePhotoRightSideView;
  String vehiclePhotoLeftSideView;

  RegisterDetailsRequest({
    required this.email,
    required this.profilePhoto,
    required this.countryCode,
    required this.phoneNumber,
    required this.fullLegalName,
    required this.dateOfBirth,
    required this.currentAddress,
    required this.driverLicenseNumber,
    required this.driverLicenseExpirationDate,
    required this.driverLicenseType,
    required this.countryOfIssue,
    required this.driverLicensePhotoFront,
    required this.driverLicensePhotoBack,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleLicensePlateNumber,
    required this.vehicleColor,
    required this.vehicleRegistrationNumber,
    required this.vehiclePhotoFrontView,
    required this.vehiclePhotoBackView,
    required this.vehiclePhotoRightSideView,
    required this.vehiclePhotoLeftSideView,
  });
}
