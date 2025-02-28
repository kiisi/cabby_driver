import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  T? data;

  BaseResponse({this.status, this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseResponseToJson(this, toJsonT);
}

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'countryCode')
  String? countryCode;

  @JsonKey(name: 'phoneNumber')
  int? phoneNumber;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'password')
  String? password;

  @JsonKey(name: 'firstName')
  String? firstName;

  @JsonKey(name: 'lastName')
  String? lastName;

  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'role')
  String? role;

  @JsonKey(name: 'profilePhoto')
  String? profilePhoto;

  @JsonKey(name: 'ipAddress')
  String? ipAddress;

  @JsonKey(name: 'isMobileVerified')
  bool? isMobileVerified;

  @JsonKey(name: 'isEmailVerified')
  bool? isEmailVerified;

  @JsonKey(name: 'isDeleted')
  bool? isDeleted;

  @JsonKey(name: 'isSuspended')
  bool? isSuspended;

  @JsonKey(name: 'isRegistrationComplete')
  bool? isRegistrationComplete;

  @JsonKey(name: 'accountBalance')
  double? accountBalance;

  @JsonKey(name: 'currency')
  String? currency;

  @JsonKey(name: 'fullLegalName')
  String? fullLegalName;

  @JsonKey(name: 'dateOfBirth')
  String? dateOfBirth;

  @JsonKey(name: 'currentAddress')
  String? currentAddress;

  @JsonKey(name: 'driverLicenseNumber')
  int? driverLicenseNumber;

  @JsonKey(name: 'driverLicenseExpirationDate')
  String? driverLicenseExpirationDate;

  @JsonKey(name: 'driverLicenseType')
  String? driverLicenseType;

  @JsonKey(name: 'countryOfIssue')
  String? countryOfIssue;

  @JsonKey(name: 'driverLicensePhotoFront')
  String? driverLicensePhotoFront;

  @JsonKey(name: 'driverLicensePhotoBack')
  String? driverLicensePhotoBack;

  @JsonKey(name: 'vehicleMake')
  String? vehicleMake;

  @JsonKey(name: 'vehicleModel')
  String? vehicleModel;

  @JsonKey(name: 'vehicleYear')
  String? vehicleYear;

  @JsonKey(name: 'vehicleLicensePlateNumber')
  String? vehicleLicensePlateNumber;

  @JsonKey(name: 'vehicleColor')
  String? vehicleColor;

  @JsonKey(name: 'vehicleRegistrationNumber')
  String? vehicleRegistrationNumber;

  @JsonKey(name: 'vehiclePhotoFrontView')
  String? vehiclePhotoFrontView;

  @JsonKey(name: 'vehiclePhotoBackView')
  String? vehiclePhotoBackView;

  @JsonKey(name: 'vehiclePhotoRightSideView')
  String? vehiclePhotoRightSideView;

  @JsonKey(name: 'vehiclePhotoLeftSideView')
  String? vehiclePhotoLeftSideView;

  User({
    this.id,
    this.countryCode,
    this.phoneNumber,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.gender,
    this.role,
    this.profilePhoto,
    this.ipAddress,
    this.isMobileVerified,
    this.isEmailVerified,
    this.isDeleted,
    this.isSuspended,
    this.isRegistrationComplete,
    this.accountBalance,
    this.currency,
    this.fullLegalName,
    this.dateOfBirth,
    this.currentAddress,
    this.driverLicenseNumber,
    this.driverLicenseExpirationDate,
    this.driverLicenseType,
    this.countryOfIssue,
    this.driverLicensePhotoFront,
    this.driverLicensePhotoBack,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.vehicleLicensePlateNumber,
    this.vehicleColor,
    this.vehicleRegistrationNumber,
    this.vehiclePhotoFrontView,
    this.vehiclePhotoBackView,
    this.vehiclePhotoRightSideView,
    this.vehiclePhotoLeftSideView,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'accessToken')
  String accessToken;
  @JsonKey(name: 'user')
  User user;

  RegisterResponse({required this.accessToken, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'accessToken')
  String accessToken;
  @JsonKey(name: 'user')
  User user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class EmailOtpVerifyResponse {
  @JsonKey(name: 'isOtpVerified')
  bool? isOtpVerified;
  @JsonKey(name: 'emailOtpId')
  String? emailOtpId;

  EmailOtpVerifyResponse({this.isOtpVerified, this.emailOtpId});

  factory EmailOtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailOtpVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailOtpVerifyResponseToJson(this);
}

@JsonSerializable()
class ImageUploadResponse {
  final String? assetId;
  final String? publicId;
  final int? version;
  final String? versionId;
  final String? signature;
  final int? width;
  final int? height;
  final String? format;
  final String? resourceType;
  final String? createdAt;
  final List<String?>? tags;
  final int? bytes;
  final String? type;
  final String? etag;
  final bool? placeholder;
  final String? url;
  final String? secureUrl;
  final String? assetFolder;
  final String? displayName;
  final String? originalFilename;

  ImageUploadResponse({
    this.assetId,
    this.publicId,
    this.version,
    this.versionId,
    this.signature,
    this.width,
    this.height,
    this.format,
    this.resourceType,
    this.createdAt,
    this.tags,
    this.bytes,
    this.type,
    this.etag,
    this.placeholder,
    required this.url,
    required this.secureUrl,
    this.assetFolder,
    this.displayName,
    this.originalFilename,
  });

  /// Convert JSON to Dart object
  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) => _$ImageUploadResponseFromJson(json);

  /// Convert Dart object to JSON
  Map<String, dynamic> toJson() => _$ImageUploadResponseToJson(this);
}

@JsonSerializable()
class RegisterDetailsResponse {
  @JsonKey(name: 'user')
  User user;

  RegisterDetailsResponse({required this.user});

  factory RegisterDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDetailsResponseToJson(this);
}

@JsonSerializable()
class SetOnlineStatusResponse {
  @JsonKey(name: 'user')
  User user;

  SetOnlineStatusResponse({required this.user});

  factory SetOnlineStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SetOnlineStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetOnlineStatusResponseToJson(this);
}
