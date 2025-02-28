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
class RegisterDetailsScreen extends StatefulWidget {
  const RegisterDetailsScreen({super.key});

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreference = getIt<AppPreferences>();

  final RegisterDetailsUseCase _registerDetailsUseCase = getIt<RegisterDetailsUseCase>();

  final ImageUploadUseCase _imageUploadUseCase = getIt<ImageUploadUseCase>();

  final TextEditingController _fullLegalNameController = TextEditingController();

  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _currentAddressController = TextEditingController();

  String countryCode = 'NG';

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _licenseNumberController = TextEditingController();

  final TextEditingController _licenseExpirationDateController = TextEditingController();

  final TextEditingController _licenseTypeController = TextEditingController();

  final TextEditingController _countryOfLicenseIssuanceController = TextEditingController();

  final TextEditingController _vehicleMakeController = TextEditingController();

  final TextEditingController _vehicleModelController = TextEditingController();

  final TextEditingController _vehicleYearController = TextEditingController();

  final TextEditingController _vehicleLicensePlateNumberController = TextEditingController();

  final TextEditingController _vehicleColorController = TextEditingController();

  final TextEditingController _vehicleRegistrationNumberController = TextEditingController();

  bool isLoading = false;

  File? _imageProfilePhoto;

  String? _imageProfilePhotoUrl;

  File? _imageLicenseFront;

  String? _imageLicenseFrontUrl;

  File? _imageLicenseBack;

  String? _imageLicenseBackUrl;

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
        if (type == ImagePickerType.profilePhoto) {
          _imageProfilePhoto = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoFront) {
          _imageLicenseFront = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoBack) {
          _imageLicenseBack = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoFront) {
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
        if (type == ImagePickerType.profilePhoto) {
          _imageProfilePhoto = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoFront) {
          _imageLicenseFront = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoBack) {
          _imageLicenseBack = File(pickedFile.path);
        } else if (type == ImagePickerType.vehiclePhotoFront) {
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
      if (type == ImagePickerType.profilePhoto) {
        _imageProfilePhoto = null;
        _imageProfilePhotoUrl = '';
      } else if (type == ImagePickerType.licensePhotoFront) {
        _imageLicenseFront = null;
        _imageLicenseFrontUrl = '';
      } else if (type == ImagePickerType.licensePhotoBack) {
        _imageLicenseBack = null;
        _imageLicenseBackUrl = '';
      } else if (type == ImagePickerType.vehiclePhotoFront) {
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
            if (type == ImagePickerType.licensePhotoFront && _imageLicenseFront != null)
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
            if (type == ImagePickerType.licensePhotoBack && _imageLicenseBack != null)
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

  Future<void> _selectLicenseDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _licenseExpirationDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
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
    _licenseExpirationDateController.dispose();
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

    if (_licenseNumberController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license number is required.");
    }

    if (_licenseExpirationDateController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license expiration date is required.");
    }

    if (_licenseTypeController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license class or type is required.");
    }

    if (_countryOfLicenseIssuanceController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license country of issue is required.");
    }

    if (_imageLicenseFront == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license photo — a front-view is required.");
    }

    if (_imageLicenseBack == null) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Driver's license photo — a back-view is required.");
    }

    if (_vehicleMakeController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Vehicle make is required.");
    }

    if (_vehicleModelController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Vehicle model is required.");
    }

    if (_vehicleYearController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Vehicle year is required.");
    }

    if (_vehicleLicensePlateNumberController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle license plate number is required.");
    }

    if (_vehicleColorController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(context: context, message: "Vehicle color is required.");
    }

    if (_vehicleRegistrationNumberController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle registration number is required.");
    }

    if (_vehicleRegistrationNumberController.text.isEmpty) {
      return CustomFlushbar.showErrorFlushBar(
          context: context, message: "Vehicle registration number is required.");
    }

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
      if (_imageProfilePhoto != null && _imageProfilePhotoUrl == null) {
        _imageProfilePhotoUrl = await uploadImage(_imageProfilePhoto!);
      }
      if (_imageLicenseFront != null && _imageLicenseFrontUrl == null) {
        _imageLicenseFrontUrl = await uploadImage(_imageLicenseFront!);
      }
      if (_imageLicenseBack != null && _imageLicenseBackUrl == null) {
        _imageLicenseBackUrl = await uploadImage(_imageLicenseBack!);
      }
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

    (await _registerDetailsUseCase.execute(RegisterDetailsRequest(
      email: _appPreference.getUserEmail(),
      countryCode: countryCode,
      countryOfIssue: _countryOfLicenseIssuanceController.text,
      currentAddress: _currentAddressController.text,
      dateOfBirth: _dateOfBirthController.text,
      driverLicenseExpirationDate: _licenseExpirationDateController.text,
      driverLicenseNumber: _licenseNumberController.text,
      driverLicensePhotoBack: _imageLicenseBackUrl ?? '',
      driverLicensePhotoFront: _imageLicenseFrontUrl ?? '',
      driverLicenseType: _licenseExpirationDateController.text,
      fullLegalName: _fullLegalNameController.text,
      phoneNumber: _phoneNumberController.text,
      profilePhoto: _imageProfilePhotoUrl ?? '',
      vehicleColor: _vehicleColorController.text,
      vehicleLicensePlateNumber: _vehicleLicensePlateNumberController.text,
      vehicleMake: _vehicleMakeController.text,
      vehicleModel: _vehicleModelController.text,
      vehiclePhotoBackView: _imageVehiclePhotoBackUrl ?? '',
      vehiclePhotoFrontView: _imageVehiclePhotoFrontUrl ?? '',
      vehiclePhotoLeftSideView: _imageVehiclePhotoLeftSideUrl ?? '',
      vehiclePhotoRightSideView: _imageVehiclePhotoRightSideUrl ?? '',
      vehicleRegistrationNumber: _vehicleRegistrationNumberController.text,
      vehicleYear: _vehicleYearController.text,
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
                    'Driver Details!',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Set up your driver profile, vehicle and license details.',
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
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.profilePhoto);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageProfilePhoto != null
                            ? DecorationImage(image: FileImage(_imageProfilePhoto!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageProfilePhoto == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('Profile photo')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Driver's License Information:",
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: 18,
                      fontFamily: 'Ubermove',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _licenseNumberController,
                    decoration: InputDecoration(
                      hintText: "License number",
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
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _licenseExpirationDateController,
                    readOnly: true,
                    onTap: () => _selectLicenseDate(context),
                    decoration: InputDecoration(
                      hintText: "License expiration date",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _licenseTypeController,
                    decoration: InputDecoration(
                      hintText: "License class/type",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _countryOfLicenseIssuanceController,
                    readOnly: true,
                    onTap: _showCountryModal,
                    decoration: InputDecoration(
                      hintText: "Country of license issuance",
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
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.licensePhotoFront);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageLicenseFront != null
                            ? DecorationImage(image: FileImage(_imageLicenseFront!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageLicenseFront == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('License photo (front)')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.licensePhotoBack);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageLicenseBack != null
                            ? DecorationImage(image: FileImage(_imageLicenseBack!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageLicenseBack == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                Text('License photo (back)')
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Vehicle Information:",
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: 18,
                      fontFamily: 'Ubermove',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _vehicleMakeController,
                    decoration: InputDecoration(
                      hintText: "Vehicle make",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _vehicleModelController,
                    decoration: InputDecoration(
                      hintText: "Vehicle model",
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
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _vehicleYearController,
                    decoration: InputDecoration(
                      hintText: "Vehicle year",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _vehicleLicensePlateNumberController,
                    decoration: InputDecoration(
                      hintText: "License plate number",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _vehicleColorController,
                    decoration: InputDecoration(
                      hintText: "Vehicle color",
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
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _vehicleRegistrationNumberController,
                    decoration: InputDecoration(
                      hintText: "Vehicle registration number",
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
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(ImagePickerType.vehiclePhotoFront);
                    },
                    child: Container(
                      height: 180,
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
                      height: 180,
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
                      height: 180,
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
                      height: 180,
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

  void _showCountryModal() async {
    final selected = await showModalBottomSheet<String>(
      clipBehavior: Clip.antiAlias,
      context: context,
      backgroundColor: Colors.white, // Light mode
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          children: [
            Padding(
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      countries[index].flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(countries[index].name),
                    onTap: () {
                      Navigator.pop(context, countries[index].name); // Pass the selected country back
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    // Update selected country if not null
    if (selected != null) {
      setState(() {
        _countryOfLicenseIssuanceController.text = selected;
      });
    }
  }
}
