import 'package:cabby_driver/data/data-source/cloudinary_remote_data_source.dart';
import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/request/cloudinary_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:dartz/dartz.dart';

abstract interface class CloudinaryRepository {
  Future<Either<Failure, ImageUploadResponse>> imageUpload(
      ImageUploadRequest imageUploadRequest);
}

class CloudinaryRepositoryImpl implements CloudinaryRepository {
  final CloudinaryRemoteDataSource _cloudinaryRemoteDataSource;

  CloudinaryRepositoryImpl(this._cloudinaryRemoteDataSource);

  @override
  Future<Either<Failure, ImageUploadResponse>> imageUpload(
      ImageUploadRequest imageUploadRequest) async {
    try {
      final response =
          await _cloudinaryRemoteDataSource.uploadImage(imageUploadRequest);
      return Right(response);
    } catch (error) {
      return Left(FailureExceptionHandler.handle(error).failure);
    }
  }
}
