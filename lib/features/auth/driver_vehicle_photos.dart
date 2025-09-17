import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/routes/app_router.gr.dart';
import 'package:cabby_driver/core/widgets/custom_button.dart';
import 'package:cabby_driver/data/network/socket.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/data/request/cloudinary_request.dart';
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:cabby_driver/domain/usecase/cloudinary_usecase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_state_city/country_state_city.dart' hide State;

enum ImagePickerType {
  profilePhoto,
  licensePhotoFront,
  licensePhotoBack,
  vehiclePhotoFront,
  vehiclePhotoBack,
  vehiclePhotoLeftSide,
  vehiclePhotoRightSide,
}

@RoutePage()
class DriverVehiclePhotosScreen extends StatefulWidget {
  const DriverVehiclePhotosScreen({super.key});

  @override
  State<DriverVehiclePhotosScreen> createState() => _DriverVehiclePhotosScreenState();
}

class _DriverVehiclePhotosScreenState extends State<DriverVehiclePhotosScreen> {
  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final SocketServiceClient socketServiceClient = SocketServiceClient();

  final AppPreferences _appPreference = getIt<AppPreferences>();

  final DriverVehiclePhotosUseCase _driverVehiclePhotosUseCase = getIt<DriverVehiclePhotosUseCase>();

  final ImageUploadUseCase _imageUploadUseCase = getIt<ImageUploadUseCase>();

  bool isLoading = false;

  File? _imageVehiclePhotoFront;

  String? _imageVehiclePhotoFrontUrl;

  File? _imageVehiclePhotoBack;

  String? _imageVehiclePhotoBackUrl;

  File? _imageVehiclePhotoRightSide;

  String? _imageVehiclePhotoRightSideUrl;

  File? _imageVehiclePhotoLeftSide;

  String? _imageVehiclePhotoLeftSideUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.vehiclePhotoFront) {
          _imageVehiclePhotoFront = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoBack) {
          _imageVehiclePhotoBack = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoRightSide) {
          _imageVehiclePhotoRightSide = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoLeftSide) {
          _imageVehiclePhotoLeftSide = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _takePhoto(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.vehiclePhotoFront) {
          _imageVehiclePhotoFront = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoBack) {
          _imageVehiclePhotoBack = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoRightSide) {
          _imageVehiclePhotoRightSide = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoLeftSide) {
          _imageVehiclePhotoLeftSide = File(pickedFile.path);
        }
      });
    }
  }

  void _removeImage(ImagePickerType type) {
    setState(() {
      if (type == ImagePickerType.vehiclePhotoFront) {
        _imageVehiclePhotoFront = null;
        _imageVehiclePhotoFrontUrl = '';
      } else if (type == ImagePickerType.vehiclePhotoBack) {
        _imageVehiclePhotoBack = null;
        _imageVehiclePhotoBackUrl = '';
      } else if (type == ImagePickerType.vehiclePhotoRightSide) {
        _imageVehiclePhotoRightSide = null;
        _imageVehiclePhotoRightSideUrl = '';
      } else if (type == ImagePickerType.vehiclePhotoLeftSide) {
        _imageVehiclePhotoLeftSide = null;
        _imageVehiclePhotoLeftSideUrl = '';
      }
    });
  }

  void _showImagePickerOptions(ImagePickerType type) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Wrap(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.grey,
              ),
              title: const Text(
                'Choose from Gallery',
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(type);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: Colors.grey,
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(type);
              },
            ),
            if (type == ImagePickerType.vehiclePhotoFront && _imageVehiclePhotoFront != null)
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: const Text('Remove Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(type);
                },
              ),
            if (type == ImagePickerType.vehiclePhotoBack && _imageVehiclePhotoBack != null)
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: const Text('Remove Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(type);
                },
              ),
            if (type == ImagePickerType.vehiclePhotoLeftSide && _imageVehiclePhotoLeftSide != null)
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: const Text('Remove Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(type);
                },
              ),
            if (type == ImagePickerType.vehiclePhotoRightSide && _imageVehiclePhotoRightSide != null)
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                title: const Text('Remove Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage(type);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submit() async {
    if (_imageVehiclePhotoFront == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle photo - front view is required!");
    }

    if (_imageVehiclePhotoBack == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle photo - back view is required!");
    }

    if (_imageVehiclePhotoLeftSide == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle photo - left view is required!");
    }
    if (_imageVehiclePhotoRightSide == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle photo - right view is required!");
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (_imageVehiclePhotoFront != null && _imageVehiclePhotoFrontUrl == null) {
        _imageVehiclePhotoFrontUrl = await uploadImage(_imageVehiclePhotoFront!);
      }
      if (_imageVehiclePhotoBack != null && _imageVehiclePhotoBackUrl == null) {
        _imageVehiclePhotoBackUrl = await uploadImage(_imageVehiclePhotoBack!);
      }
      if (_imageVehiclePhotoLeftSide != null && _imageVehiclePhotoLeftSideUrl == null) {
        _imageVehiclePhotoLeftSideUrl = await uploadImage(_imageVehiclePhotoLeftSide!);
      }
      if (_imageVehiclePhotoRightSide != null && _imageVehiclePhotoRightSideUrl == null) {
        _imageVehiclePhotoRightSideUrl = await uploadImage(_imageVehiclePhotoRightSide!);
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        CustomFlushbar.showErrorFlushBar(
            context: context, message: "An error occurred while uploading images to our server");
      }
    }

    (await _driverVehiclePhotosUseCase.execute(DriverVehiclePhotosRequest(
      email: _appPreference.getUserEmail(),
      vehiclePhotoBackView: _imageVehiclePhotoBackUrl ?? '',
      vehiclePhotoFrontView: _imageVehiclePhotoFrontUrl ?? '',
      vehiclePhotoLeftSideView: _imageVehiclePhotoLeftSideUrl ?? '',
      vehiclePhotoRightSideView: _imageVehiclePhotoRightSideUrl ?? '',
    )))
        .fold((error) {
      CustomFlushbar.showErrorFlushBar(context: context, message: error.message);
      setState(() {
        isLoading = false;
      });
    }, (success) {
      CustomFlushbar.showSuccessSnackBar(context: context, message: success.message ?? '');
      setState(() {
        isLoading = false;
      });

      _appPreferences.setUserId(success.data?.user.id ?? '');
      socketServiceClient.connect(success.data?.user.id);

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.router.replaceAll([const OverviewRoute()]);
        }
      });
    });
  }

  Future<String?> uploadImage(File image) async {
    String? response = (await _imageUploadUseCase.execute(ImageUploadRequest(
      cloud_name: 'dhaamr7kd',
      file: image,
      folder: 'cabbysaferide',
      upload_preset: 'cabbysaferide',
    )))
        .fold((error) {
      return null;
    }, (success) {
      return success.url;
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.p15,
              right: AppPadding.p15,
              bottom: AppPadding.p20,
              top: AppSize.s50,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vehicle Photos!',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Upload clear photos of your vehicle for safety and verification.',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Vehicle Photos:",
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: 18,
                      fontFamily: 'Ubermove',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.vehiclePhotoFront);
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoFront != null
                            ? DecorationImage(image: FileImage(_imageVehiclePhotoFront!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageVehiclePhotoFront == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('Vehicle photo - Front View')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.vehiclePhotoBack);
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoBack != null
                            ? DecorationImage(image: FileImage(_imageVehiclePhotoBack!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageVehiclePhotoBack == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('Vehicle photo - Back View')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.vehiclePhotoRightSide);
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoRightSide != null
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoRightSide!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageVehiclePhotoRightSide == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('Vehicle photo - Right Side View')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.vehiclePhotoLeftSide);
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoLeftSide != null
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoLeftSide!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageVehiclePhotoLeftSide == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('Vehicle photo - Left Side View')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: 'Submit',
                    onPressed: () {
                      submit();
                    },
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
