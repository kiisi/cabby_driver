import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/routes/app_router.gr.dart';
import 'package:cabby_driver/core/widgets/country_code_phone_number_input.dart';
import 'package:cabby_driver/core/widgets/custom_button.dart';
import 'package:cabby_driver/data/network/cloudinary_api.dart';
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
class DriverPersonalInfoScreen extends StatefulWidget {
  const DriverPersonalInfoScreen({super.key});

  @override
  State<DriverPersonalInfoScreen> createState() => _DriverPersonalInfoScreenState();
}

class _DriverPersonalInfoScreenState extends State<DriverPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final SocketServiceClient socketServiceClient = SocketServiceClient();

  final AppPreferences _appPreference = getIt<AppPreferences>();

  final DriverPersonalInfoUseCase _driverPersonalInfoUseCase = getIt<DriverPersonalInfoUseCase>();

  final ImageUploadUseCase _imageUploadUseCase = getIt<ImageUploadUseCase>();

  final TextEditingController _fullLegalNameController = TextEditingController();

  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _currentAddressController = TextEditingController();

  String countryCode = 'NG';

  final TextEditingController _phoneNumberController = TextEditingController();

  bool isLoading = false;

  File? _imageProfilePhoto;

  String? _imageProfilePhotoUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.profilePhoto) {
          _imageProfilePhoto = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _takePhoto(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.profilePhoto) {
          _imageProfilePhoto = File(pickedFile.path);
        }
      });
    }
  }

  void _removeImage(ImagePickerType type) {
    setState(() {
      if (type == ImagePickerType.profilePhoto) {
        _imageProfilePhoto = null;
        _imageProfilePhotoUrl = '';
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
            if (type == ImagePickerType.profilePhoto && _imageProfilePhoto != null)
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2800),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfBirthController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  late List<Country> countries;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCountries();
  }

  Future<void> loadCountries() async {
    countries = await getAllCountries();
    print("Countries: $countries");
    setState(() {}); // Trigger a rebuild if necessary
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_fullLegalNameController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Full legal name is required.");
    }

    if (_dateOfBirthController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Date of birth is required.");
    }

    if (_currentAddressController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Current address is required.");
    }

    if (_phoneNumberController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Phone number is required.");
    }

    if (_imageProfilePhoto == null) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Upload your profile photo.");
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (_imageProfilePhoto != null && _imageProfilePhotoUrl == null) {
        _imageProfilePhotoUrl = await uploadImage(_imageProfilePhoto!);
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

    (await _driverPersonalInfoUseCase.execute(DriverPersonalInfoRequest(
      email: _appPreference.getUserEmail(),
      countryCode: countryCode,
      currentAddress: _currentAddressController.text,
      dateOfBirth: _dateOfBirthController.text,
      fullLegalName: _fullLegalNameController.text,
      phoneNumber: _phoneNumberController.text,
      profilePhoto: _imageProfilePhotoUrl ?? '',
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
          context.router.pushNamed('/driver-license-info');
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
                    'Personal Information',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Tell us about yourself to create your driver profile',
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
                    'Personal Information:',
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: 18,
                      fontFamily: 'Ubermove',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _fullLegalNameController,
                    decoration: InputDecoration(
                      hintText: "Full legal name",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(color: ColorManager.blueDark, fontWeight: FontWeight.w300),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateOfBirthController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: "Date of birth",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(color: ColorManager.blueDark, fontWeight: FontWeight.w300),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _currentAddressController,
                    decoration: InputDecoration(
                      hintText: "Current address",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(color: ColorManager.blueDark, fontWeight: FontWeight.w300),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CountryCodePhoneNumberInput(
                    controller: _phoneNumberController,
                    initialCountryCode: countryCode,
                    onCountryCodeSelected: (value) {
                      countryCode = value.code;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showImagePickerOptions(ImagePickerType.profilePhoto);
                      },
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xfff4f5f6),
                          borderRadius: BorderRadius.circular(100),
                          image: _imageProfilePhoto != null
                              ? DecorationImage(image: FileImage(_imageProfilePhoto!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _imageProfilePhoto == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_sharp,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                  Text('Profile photo')
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: 'Continue',
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
