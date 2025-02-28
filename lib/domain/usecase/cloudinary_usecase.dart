import 'package:cabby_driver/data/network/failure.dart';
import 'package:cabby_driver/data/repository/cloudinary_repo.dart';
import 'package:cabby_driver/data/request/cloudinary_request.dart';
import 'package:cabby_driver/data/response/response.dart';
import 'package:cabby_driver/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ImageUploadUseCase
    implements BaseUseCase<ImageUploadRequest, ImageUploadResponse> {
  final CloudinaryRepository _cloudinaryRepository;

  ImageUploadUseCase(this._cloudinaryRepository);

  @override
  Future<Either<Failure, ImageUploadResponse>> execute(
      ImageUploadRequest input) async {
    return await _cloudinaryRepository.imageUpload(input);
  }
}
