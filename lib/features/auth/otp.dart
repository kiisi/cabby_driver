import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/app_prefs.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:flutter/material.dart';
import 'package:cabby_driver/core/widgets/custom_button.dart';

@RoutePage()
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final EmailOtpVerifyUseCase emailOtpVerifyUseCase =
      getIt<EmailOtpVerifyUseCase>();

  final TextEditingController otpTextEditingController =
      TextEditingController();

  void submit() async {
    setState(() {
      isLoading = true;
    });

    (await emailOtpVerifyUseCase.execute(EmailOtpVerifyRequest(
      email: _appPreferences.getForgotPasswordEmail(),
      otp: otpTextEditingController.text,
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

      _appPreferences.setEmailOtpId(success.data?.emailOtpId ?? '');

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.router.pushNamed('/reset-password');
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
                    'OTP!',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Enter the 6-digit code sent to your email',
                    style: TextStyle(
                        fontFamily: 'Euclide',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: otpTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter 6 digit code",
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
                    label: 'Verify',
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
