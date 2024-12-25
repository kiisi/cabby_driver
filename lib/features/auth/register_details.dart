import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/widgets/country_code_phone_number_input.dart';
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

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _licenseDateController = TextEditingController();

  final TextEditingController _countryController = TextEditingController();

  File? _imageProfilePhoto;

  File? _imageLicenseFront;

  File? _imageLicenseBack;

  File? _imageVehiclePhotoFront;

  File? _imageVehiclePhotoBack;

  File? _imageVehiclePhotoRightSide;

  File? _imageVehiclePhotoLeftSide;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImagePickerType type) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

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
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

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
      } else if (type == ImagePickerType.licensePhotoFront) {
        _imageLicenseFront = null;
      } else if (type == ImagePickerType.licensePhotoBack) {
        _imageLicenseBack = null;
      } else if (type == ImagePickerType.vehiclePhotoFront) {
        _imageVehiclePhotoFront = null;
      } else if (type == ImagePickerType.vehiclePhotoBack) {
        _imageVehiclePhotoBack = null;
      } else if (type == ImagePickerType.vehiclePhotoRightSide) {
        _imageVehiclePhotoRightSide = null;
      } else if (type == ImagePickerType.vehiclePhotoLeftSide) {
        _imageVehiclePhotoLeftSide = null;
      }
    });
  }

  void _showImagePickerOptions(ImagePickerType type) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Wrap(
          children: [
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
            if (type == ImagePickerType.profilePhoto &&
                _imageProfilePhoto != null)
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
            if (type == ImagePickerType.licensePhotoFront &&
                _imageLicenseFront != null)
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
            if (type == ImagePickerType.licensePhotoBack &&
                _imageLicenseBack != null)
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
            if (type == ImagePickerType.vehiclePhotoFront &&
                _imageVehiclePhotoFront != null)
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
            if (type == ImagePickerType.vehiclePhotoBack &&
                _imageVehiclePhotoBack != null)
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
            if (type == ImagePickerType.vehiclePhotoLeftSide &&
                _imageVehiclePhotoLeftSide != null)
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
            if (type == ImagePickerType.vehiclePhotoRightSide &&
                _imageVehiclePhotoRightSide != null)
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
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
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
        _licenseDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
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
    _dateController.dispose();
    _licenseDateController.dispose();
    super.dispose();
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
                    decoration: InputDecoration(
                      hintText: "Full legal name",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: "Date of birth",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Current address",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CountryCodePhoneNumberInput(
                    onCountryCodeSelected: (value) {},
                    onPhoneNumberChanged: (value) {},
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
                            ? DecorationImage(
                                image: FileImage(_imageProfilePhoto!),
                                fit: BoxFit.cover)
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
                    decoration: InputDecoration(
                      hintText: "License number",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _licenseDateController,
                    readOnly: true,
                    onTap: () => _selectLicenseDate(context),
                    decoration: InputDecoration(
                      hintText: "License expiration date",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    decoration: InputDecoration(
                      hintText: "License class/type",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    controller: _countryController,
                    readOnly: true,
                    onTap: _showCountryModal,
                    decoration: InputDecoration(
                      hintText: "Country of issue",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(
                          ImagePickerType.licensePhotoFront);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageLicenseFront != null
                            ? DecorationImage(
                                image: FileImage(_imageLicenseFront!),
                                fit: BoxFit.cover)
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
                            ? DecorationImage(
                                image: FileImage(_imageLicenseBack!),
                                fit: BoxFit.cover)
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
                    decoration: InputDecoration(
                      hintText: "Vehicle make and model",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    decoration: InputDecoration(
                      hintText: "Vehicle year",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    decoration: InputDecoration(
                      hintText: "License plate number",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    decoration: InputDecoration(
                      hintText: "Vehicle color",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
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
                    decoration: InputDecoration(
                      hintText: "Vehicle registration number",
                      filled: true,
                      fillColor: const Color(0xfff4f5f6),
                      hintStyle: TextStyle(
                          color: ColorManager.blueDark,
                          fontWeight: FontWeight.w300),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color: ColorManager.primary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                    ),
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerOptions(
                          ImagePickerType.vehiclePhotoFront);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoFront != null
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoFront!),
                                fit: BoxFit.cover)
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
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoBack!),
                                fit: BoxFit.cover)
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
                      _showImagePickerOptions(
                          ImagePickerType.vehiclePhotoRightSide);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoRightSide != null
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoRightSide!),
                                fit: BoxFit.cover)
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
                      _showImagePickerOptions(
                          ImagePickerType.vehiclePhotoLeftSide);
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5f6),
                        borderRadius: BorderRadius.circular(4),
                        image: _imageVehiclePhotoLeftSide != null
                            ? DecorationImage(
                                image: FileImage(_imageVehiclePhotoLeftSide!),
                                fit: BoxFit.cover)
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.black,
                        foregroundColor: ColorManager.white,
                        fixedSize: const Size.fromHeight(AppSize.s48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
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
                      Navigator.pop(
                          context,
                          countries[index]
                              .name); // Pass the selected country back
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
        _countryController.text = selected;
      });
    }
  }
}
