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
      id: json['_id'] as String?,
      countryCode: json['countryCode'] as String?,
      phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      role: json['role'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
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
      driverLicenseNumber: (json['driverLicenseNumber'] as num?)?.toInt(),
      driverLicenseExpirationDate:
          json['driverLicenseExpirationDate'] as String?,
      driverLicenseType: json['driverLicenseType'] as String?,
      countryOfIssue: json['countryOfIssue'] as String?,
      driverLicensePhotoFront: json['driverLicensePhotoFront'] as String?,
      driverLicensePhotoBack: json['driverLicensePhotoBack'] as String?,
      vehicleMake: json['vehicleMake'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleYear: json['vehicleYear'] as String?,
      vehicleLicensePlateNumber: json['vehicleLicensePlateNumber'] as String?,
      vehicleColor: json['vehicleColor'] as String?,
      vehicleRegistrationNumber: json['vehicleRegistrationNumber'] as String?,
      vehiclePhotoFrontView: json['vehiclePhotoFrontView'] as String?,
      vehiclePhotoBackView: json['vehiclePhotoBackView'] as String?,
      vehiclePhotoRightSideView: json['vehiclePhotoRightSideView'] as String?,
      vehiclePhotoLeftSideView: json['vehiclePhotoLeftSideView'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'role': instance.role,
      'profilePhoto': instance.profilePhoto,
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
      'driverLicenseNumber': instance.driverLicenseNumber,
      'driverLicenseExpirationDate': instance.driverLicenseExpirationDate,
      'driverLicenseType': instance.driverLicenseType,
      'countryOfIssue': instance.countryOfIssue,
      'driverLicensePhotoFront': instance.driverLicensePhotoFront,
      'driverLicensePhotoBack': instance.driverLicensePhotoBack,
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'vehicleYear': instance.vehicleYear,
      'vehicleLicensePlateNumber': instance.vehicleLicensePlateNumber,
      'vehicleColor': instance.vehicleColor,
      'vehicleRegistrationNumber': instance.vehicleRegistrationNumber,
      'vehiclePhotoFrontView': instance.vehiclePhotoFrontView,
      'vehiclePhotoBackView': instance.vehiclePhotoBackView,
      'vehiclePhotoRightSideView': instance.vehiclePhotoRightSideView,
      'vehiclePhotoLeftSideView': instance.vehiclePhotoLeftSideView,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      accessToken: json['accessToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'user': instance.user,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['accessToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'user': instance.user,
    };

EmailOtpVerifyResponse _$EmailOtpVerifyResponseFromJson(
        Map<String, dynamic> json) =>
    EmailOtpVerifyResponse(
      isOtpVerified: json['isOtpVerified'] as bool?,
      emailOtpId: json['emailOtpId'] as String?,
    );

Map<String, dynamic> _$EmailOtpVerifyResponseToJson(
        EmailOtpVerifyResponse instance) =>
    <String, dynamic>{
      'isOtpVerified': instance.isOtpVerified,
      'emailOtpId': instance.emailOtpId,
    };

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(
      assetId: json['assetId'] as String?,
      publicId: json['publicId'] as String?,
      version: (json['version'] as num?)?.toInt(),
      versionId: json['versionId'] as String?,
      signature: json['signature'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      format: json['format'] as String?,
      resourceType: json['resourceType'] as String?,
      createdAt: json['createdAt'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      bytes: (json['bytes'] as num?)?.toInt(),
      type: json['type'] as String?,
      etag: json['etag'] as String?,
      placeholder: json['placeholder'] as bool?,
      url: json['url'] as String?,
      secureUrl: json['secureUrl'] as String?,
      assetFolder: json['assetFolder'] as String?,
      displayName: json['displayName'] as String?,
      originalFilename: json['originalFilename'] as String?,
    );

Map<String, dynamic> _$ImageUploadResponseToJson(
        ImageUploadResponse instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'publicId': instance.publicId,
      'version': instance.version,
      'versionId': instance.versionId,
      'signature': instance.signature,
      'width': instance.width,
      'height': instance.height,
      'format': instance.format,
      'resourceType': instance.resourceType,
      'createdAt': instance.createdAt,
      'tags': instance.tags,
      'bytes': instance.bytes,
      'type': instance.type,
      'etag': instance.etag,
      'placeholder': instance.placeholder,
      'url': instance.url,
      'secureUrl': instance.secureUrl,
      'assetFolder': instance.assetFolder,
      'displayName': instance.displayName,
      'originalFilename': instance.originalFilename,
    };

RegisterDetailsResponse _$RegisterDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterDetailsResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterDetailsResponseToJson(
        RegisterDetailsResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
