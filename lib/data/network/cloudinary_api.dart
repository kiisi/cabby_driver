import 'dart:io';

import 'package:cabby_driver/core/common/constant.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'cloudinary_api.g.dart';

@RestApi(baseUrl: Constant.cloudinaryBaseUrl)
abstract class CloudinaryServiceClient {
  factory CloudinaryServiceClient(Dio dio, {String baseUrl}) =
      _CloudinaryServiceClient;

  @MultiPart()
  @POST("/image/upload")
  Future<ImageUploadResponse> uploadImage({
    @Part() required File file,
    @Part() required String upload_preset,
    @Part() required String cloud_name,
    @Part() required String folder,
  });
}
