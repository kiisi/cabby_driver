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
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:flutter/material.dart';
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
class DriverVehicleInfoScreen extends StatefulWidget {
  const DriverVehicleInfoScreen({super.key});

  @override
  State<DriverVehicleInfoScreen> createState() => _DriverVehicleInfoScreenState();
}

class _DriverVehicleInfoScreenState extends State<DriverVehicleInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final SocketServiceClient socketServiceClient = SocketServiceClient();

  final AppPreferences _appPreference = getIt<AppPreferences>();

  final DriverVehicleInfoUseCase _driverVehicleInfoUseCase = getIt<DriverVehicleInfoUseCase>();

  final TextEditingController _vehicleMakeController = TextEditingController();

  final TextEditingController _vehicleModelController = TextEditingController();

  final TextEditingController _vehicleYearController = TextEditingController();

  final TextEditingController _vehicleLicensePlateNumberController = TextEditingController();

  final TextEditingController _vehicleColorController = TextEditingController();

  final TextEditingController _vehicleRegistrationNumberController = TextEditingController();

  bool isLoading = false;

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
    super.dispose();
  }

  void submit() async {
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

    setState(() {
      isLoading = true;
    });

    (await _driverVehicleInfoUseCase.execute(DriverVehicleInfoRequest(
      email: _appPreference.getUserEmail(),
      vehicleColor: _vehicleColorController.text,
      vehicleLicensePlateNumber: _vehicleLicensePlateNumberController.text,
      vehicleMake: _vehicleMakeController.text,
      vehicleModel: _vehicleModelController.text,
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

      _appPreferences.setUserId(success.data?.user.id ?? '');
      socketServiceClient.connect(success.data?.user.id);

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.router.pushNamed('/driver-vehicle-photos');
        }
      });
    });
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
                    'Vehicle Information!',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Enter your vehicle details so riders can recognize your car.',
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
  }
}
