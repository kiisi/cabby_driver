import 'package:cabby_driver/core/common/constant.dart';
import 'package:cabby_driver/data/models/driver_model.dart';
import 'package:cabby_driver/data/models/earnings_model.dart';
import 'package:cabby_driver/data/models/rating_model.dart';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/auth/driver/login')
  Future<BaseResponse<LoginResponse>> login({
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST('/auth/driver/register')
  Future<BaseResponse<RegisterResponse>> register({
    @Field("firstName") required String firstName,
    @Field("lastName") required String lastName,
    @Field("email") required String email,
    @Field("password") required String password,
  });

  @POST('/auth/driver/send-email-otp')
  Future<BaseResponse> sendEmailOtp({
    @Field("email") required String email,
  });

  @POST('/auth/driver/email-otp-verify')
  Future<BaseResponse<EmailOtpVerifyResponse>> emailOtpVerify({
    @Field("email") required String email,
    @Field("otp") required String otp,
  });

  @POST('/auth/driver/reset-password')
  Future<BaseResponse> resetPassword({
    @Field("email") required String email,
    @Field("emailOtpId") required String emailOtpId,
    @Field("newPassword") required String newPassword,
    @Field("confirmPassword") required String confirmPassword,
  });

  @POST('/auth/driver/driver-personal-info')
  Future<BaseResponse<DriverPersonalInfoResponse>> driverPersonalInfo({
    @Field("email") required String email,
    @Field("fullLegalName") required String fullLegalName,
    @Field("dateOfBirth") required String dateOfBirth,
    @Field("currentAddress") required String currentAddress,
    @Field("countryCode") required String countryCode,
    @Field("phoneNumber") required String phoneNumber,
    @Field("profilePhoto") required String profilePhoto,
  });

  @POST('/auth/driver/driver-license-info')
  Future<BaseResponse<DriverLicenseInfoResponse>> driverLicenseInfo({
    @Field("email") required String email,
    @Field("driverLicenseNumber") required String driverLicenseNumber,
    @Field("driverLicenseExpirationDate") required String driverLicenseExpirationDate,
    @Field("driverLicenseType") required String driverLicenseType,
    @Field("countryOfIssue") required String countryOfIssue,
    @Field("driverLicensePhotoFront") required String driverLicensePhotoFront,
    @Field("driverLicensePhotoBack") required String driverLicensePhotoBack,
  });

  @POST('/auth/driver/driver-vehicle-info')
  Future<BaseResponse<DriverVehicleInfoResponse>> driverVehicleInfo({
    @Field("email") required String email,
    @Field("vehicleMake") required String vehicleMake,
    @Field("vehicleModel") required String vehicleModel,
    @Field("vehicleYear") required String vehicleYear,
    @Field("vehicleColor") required String vehicleColor,
    @Field("vehicleLicensePlateNumber") required String vehicleLicensePlateNumber,
    @Field("vehicleRegistrationNumber") required String vehicleRegistrationNumber,
  });

  @POST('/auth/driver/driver-vehicle-photos')
  Future<BaseResponse<DriverVehiclePhotosResponse>> driverVehiclePhotos({
    @Field("email") required String email,
    @Field("vehiclePhotoFrontView") required String vehiclePhotoFrontView,
    @Field("vehiclePhotoBackView") required String vehiclePhotoBackView,
    @Field("vehiclePhotoRightSideView") required String vehiclePhotoRightSideView,
    @Field("vehiclePhotoLeftSideView") required String vehiclePhotoLeftSideView,
  });

  @POST('/auth/driver/register-details')
  Future<BaseResponse<RegisterDetailsResponse>> registerDetails({
    @Field("email") required String email,
    @Field("fullLegalName") required String fullLegalName,
    @Field("dateOfBirth") required String dateOfBirth,
    @Field("currentAddress") required String currentAddress,
    @Field("countryCode") required String countryCode,
    @Field("phoneNumber") required String phoneNumber,
    @Field("profilePhoto") required String profilePhoto,
    @Field("driverLicenseNumber") required String driverLicenseNumber,
    @Field("driverLicenseExpirationDate") required String driverLicenseExpirationDate,
    @Field("driverLicenseType") required String driverLicenseType,
    @Field("countryOfIssue") required String countryOfIssue,
    @Field("driverLicensePhotoFront") required String driverLicensePhotoFront,
    @Field("driverLicensePhotoBack") required String driverLicensePhotoBack,
    @Field("vehicleMake") required String vehicleMake,
    @Field("vehicleModel") required String vehicleModel,
    @Field("vehicleYear") required String vehicleYear,
    @Field("vehicleColor") required String vehicleColor,
    @Field("vehicleLicensePlateNumber") required String vehicleLicensePlateNumber,
    @Field("vehicleRegistrationNumber") required String vehicleRegistrationNumber,
    @Field("vehiclePhotoFrontView") required String vehiclePhotoFrontView,
    @Field("vehiclePhotoBackView") required String vehiclePhotoBackView,
    @Field("vehiclePhotoRightSideView") required String vehiclePhotoRightSideView,
    @Field("vehiclePhotoLeftSideView") required String vehiclePhotoLeftSideView,
  });

  @GET('/auth/user-auth')
  Future<BaseResponse> userAuth();

  @PATCH('/auth/driver/set-online-status')
  Future<BaseResponse<SetOnlineStatusResponse>> setOnlineStatus({
    @Field("id") required String id,
    @Field("isOnline") required bool isOnline,
  });

  @GET('/drivers/profile')
  Future<BaseResponse<DriverModel>> getProfile();

  @PUT('/drivers/profile')
  Future<BaseResponse<DriverModel>> updateProfile(@Body() Map<String, dynamic> data);

  @POST('/drivers/location')
  Future<BaseResponse> updateLocation({
    @Field("latitude") required double latitude,
    @Field("longitude") required double longitude,
  });

  // ---------------- RIDE ----------------

  @GET('/drivers/rides/active')
  Future<BaseResponse<RideModel?>> getActiveRide();

  @GET('/rides/{rideId}')
  Future<BaseResponse<RideModel>> getRide(@Path("rideId") String rideId);

  @GET('/drivers/rides/nearby')
  Future<BaseResponse<List<RideModel>>> getNearbyRideRequests();

  @GET('/drivers/rides/history')
  Future<BaseResponse<List<EarningRide>>> getRideHistory({
    @Query("page") int page = 1,
    @Query("limit") int limit = 10,
  });

  // ---------------- EARNINGS ----------------

  @GET('/drivers/earnings')
  Future<BaseResponse<EarningsModel>> getEarnings({
    @Query("startDate") required String startDate,
    @Query("endDate") required String endDate,
  });

  @GET('/drivers/earnings/weekly')
  Future<BaseResponse<EarningsModel>> getWeeklySummary();

  @GET('/drivers/earnings/monthly')
  Future<BaseResponse<EarningsModel>> getMonthlySummary();

  // ---------------- RATING ----------------

  @GET('/drivers/ratings')
  Future<BaseResponse<List<Rating>>> getRatings({
    @Query("page") int page = 1,
    @Query("limit") int limit = 10,
  });

  @POST('/ratings')
  Future<BaseResponse<Rating>> rateRider({
    @Field("rideId") required String rideId,
    @Field("riderId") required String riderId,
    @Field("rating") required int rating,
    @Field("comment") String? comment,
    @Field("raterRole") String raterRole = "driver",
  });
}
