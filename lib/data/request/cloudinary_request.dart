import 'dart:io';

class ImageUploadRequest {
  File file;
  String upload_preset;
  String cloud_name;
  String folder;

  ImageUploadRequest({
    required this.file,
    required this.upload_preset,
    required this.cloud_name,
    required this.folder,
  });
}
