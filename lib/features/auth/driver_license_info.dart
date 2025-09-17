import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/routes/app_router.gr.dart';
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
class DriverLicenseInfoScreen extends StatefulWidget {
  const DriverLicenseInfoScreen({super.key});

  @override
  State<DriverLicenseInfoScreen> createState() => _DriverLicenseInfoScreenState();
}

class _DriverLicenseInfoScreenState extends State<DriverLicenseInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final SocketServiceClient socketServiceClient = SocketServiceClient();

  final AppPreferences _appPreference = getIt<AppPreferences>();

  final DriverLicenseInfoUseCase _driverLicenseInfoUseCase = getIt<DriverLicenseInfoUseCase>();

  final ImageUploadUseCase _imageUploadUseCase = getIt<ImageUploadUseCase>();

  final TextEditingController _licenseNumberController = TextEditingController();

  final TextEditingController _licenseExpirationDateController = TextEditingController();

  final TextEditingController _licenseTypeController = TextEditingController();

  final TextEditingController _countryOfLicenseIssuanceController = TextEditingController();

  bool isLoading = false;

  File? _imageLicenseFront;

  String? _imageLicenseFrontUrl;

  File? _imageLicenseBack;

  String? _imageLicenseBackUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.licensePhotoFront) {
          _imageLicenseFront = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoBack) {
          _imageLicenseBack = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _takePhoto(ImagePickerType type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (type == ImagePickerType.licensePhotoFront) {
          _imageLicenseFront = File(pickedFile.path);
        } else if (type == ImagePickerType.licensePhotoBack) {
          _imageLicenseBack = File(pickedFile.path);
        }
      });
    }
  }

  void _removeImage(ImagePickerType type) {
    setState(() {
      if (type == ImagePickerType.licensePhotoFront) {
        _imageLicenseFront = null;
        _imageLicenseFrontUrl = '';
      } else if (type == ImagePickerType.licensePhotoBack) {
        _imageLicenseBack = null;
        _imageLicenseBackUrl = '';
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
          ],
        ),
      ),
    );
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
    _licenseExpirationDateController.dispose();
    super.dispose();
  }

  void submit() async {
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

    setState(() {
      isLoading = true;
    });

    try {
      if (_imageLicenseFront != null && _imageLicenseFrontUrl == null) {
        _imageLicenseFrontUrl = await uploadImage(_imageLicenseFront!);
      }
      if (_imageLicenseBack != null && _imageLicenseBackUrl == null) {
        _imageLicenseBackUrl = await uploadImage(_imageLicenseBack!);
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

    (await _driverLicenseInfoUseCase.execute(DriverLicenseInfoRequest(
      email: _appPreference.getUserEmail(),
      countryOfIssue: _countryOfLicenseIssuanceController.text,
      driverLicenseExpirationDate: _licenseExpirationDateController.text,
      driverLicenseNumber: _licenseNumberController.text,
      driverLicensePhotoBack: _imageLicenseBackUrl ?? '',
      driverLicensePhotoFront: _imageLicenseFrontUrl ?? '',
      driverLicenseType: _licenseExpirationDateController.text,
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
          context.router.pushNamed('/driver-vehicle-info');
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
                    'Driver\'s License Info!',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Provide your license details to verify your eligibility to drive',
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
                      height: 240,
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
                      height: 240,
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
