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

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}

@JsonSerializable()
class User {
  @JsonKey(name: 'countryCode')
  String? countryCode;

  @JsonKey(name: 'phoneNumber')
  int? phoneNumber;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'firstName')
  String? firstName;

  @JsonKey(name: 'lastName')
  String? lastName;

  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'role')
  String? role;

  @JsonKey(name: 'photo')
  String? photo;

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

  @JsonKey(name: 'licenseNumber')
  int? licenseNumber;

  @JsonKey(name: 'licenseExpirationDate')
  String? licenseExpirationDate;

  @JsonKey(name: 'licenseType')
  String? licenseType;

  @JsonKey(name: 'countryOfIssue')
  String? countryOfIssue;

  User({
    this.countryCode,
    this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.role,
    this.photo,
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
    this.licenseNumber,
    this.licenseExpirationDate,
    this.licenseType,
    this.countryOfIssue,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'accessToken')
  String? accessToken;
  @JsonKey(name: 'user')
  User? user;

  RegisterResponse({this.accessToken, this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
