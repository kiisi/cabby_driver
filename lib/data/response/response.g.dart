// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse<T> _$BaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseResponse<T>(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

User _$UserFromJson(Map<String, dynamic> json) => User(
      countryCode: json['countryCode'] as String?,
      phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      role: json['role'] as String?,
      photo: json['photo'] as String?,
      ipAddress: json['ipAddress'] as String?,
      isMobileVerified: json['isMobileVerified'] as bool?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isSuspended: json['isSuspended'] as bool?,
      isRegistrationComplete: json['isRegistrationComplete'] as bool?,
      accountBalance: (json['accountBalance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      fullLegalName: json['fullLegalName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      currentAddress: json['currentAddress'] as String?,
      licenseNumber: (json['licenseNumber'] as num?)?.toInt(),
      licenseExpirationDate: json['licenseExpirationDate'] as String?,
      licenseType: json['licenseType'] as String?,
      countryOfIssue: json['countryOfIssue'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'role': instance.role,
      'photo': instance.photo,
      'ipAddress': instance.ipAddress,
      'isMobileVerified': instance.isMobileVerified,
      'isEmailVerified': instance.isEmailVerified,
      'isDeleted': instance.isDeleted,
      'isSuspended': instance.isSuspended,
      'isRegistrationComplete': instance.isRegistrationComplete,
      'accountBalance': instance.accountBalance,
      'currency': instance.currency,
      'fullLegalName': instance.fullLegalName,
      'dateOfBirth': instance.dateOfBirth,
      'currentAddress': instance.currentAddress,
      'licenseNumber': instance.licenseNumber,
      'licenseExpirationDate': instance.licenseExpirationDate,
      'licenseType': instance.licenseType,
      'countryOfIssue': instance.countryOfIssue,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      accessToken: json['accessToken'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'user': instance.user,
    };
