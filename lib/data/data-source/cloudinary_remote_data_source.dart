import 'package:cabby_driver/data/network/cloudinary_api.dart';
import 'package:cabby_driver/data/request/cloudinary_request.dart';
import 'package:cabby_driver/data/response/response.dart';

abstract interface class CloudinaryRemoteDataSource {
  Future<ImageUploadResponse> uploadImage(
      ImageUploadRequest imageUploadRequest);
}

class CloudinaryRemoteDataSourceImpl implements CloudinaryRemoteDataSource {
  final CloudinaryServiceClient _cloudinaryServiceClient;

  CloudinaryRemoteDataSourceImpl(this._cloudinaryServiceClient);

  @override
  Future<ImageUploadResponse> uploadImage(
      ImageUploadRequest imageUploadRequest) async {
    return await _cloudinaryServiceClient.uploadImage(
      cloud_name: imageUploadRequest.cloud_name,
      file: imageUploadRequest.file,
      folder: imageUploadRequest.folder,
      upload_preset: imageUploadRequest.upload_preset,
    );
  }
}
