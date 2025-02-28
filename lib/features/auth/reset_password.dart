import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/core/widgets/custom_button.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final ResetPasswordUseCase _resetPasswordUseCase =
      getIt<ResetPasswordUseCase>();

  TextEditingController newPasswordTextEditingController =
      TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  void submit() async {
    setState(() {
      isLoading = true;
    });

    (await _resetPasswordUseCase.execute(ResetPasswordRequest(
      email: _appPreferences.getForgotPasswordEmail(),
      emailOtpId: _appPreferences.getEmailOtpId(),
      newPassword: newPasswordTextEditingController.text,
      confirmPassword: confirmPasswordTextEditingController.text,
    )))
        .fold((error) {
      CustomFlushbar.showErrorFlushBar(
          context: context, message: error.message);
      setState(() {
        isLoading = false;
      });
    }, (success) {
      CustomFlushbar.showSuccessSnackBar(
          context: context, message: success.message ?? '');

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.router.pushNamed('/login');
        }
      });

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    'Reset Password!',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Choose a strong password to secure your account.',
                    style: TextStyle(
                        fontFamily: 'Euclide',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: newPasswordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
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
                    controller: confirmPasswordTextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                  const SizedBox(height: 24),
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
