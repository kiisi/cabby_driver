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
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final AppPreferences _appPreferences = getIt<AppPreferences>();

  final SendEmailOtpUseCase sendEmailOtpUseCase = getIt<SendEmailOtpUseCase>();

  final TextEditingController emailTextEditingController =
      TextEditingController();

  void submit() async {
    setState(() {
      isLoading = true;
    });

    _appPreferences.setForgotPasswordEmail(emailTextEditingController.text);

    (await sendEmailOtpUseCase.execute(SendEmailOtpRequest(
      email: emailTextEditingController.text,
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
          context.router.pushNamed('/otp');
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
                    'Forgot Password!',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Enter your registered email to reset password.',
                    style: TextStyle(
                        fontFamily: 'Euclide',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
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
                    isLoading: isLoading,
                    onPressed: () {
                      submit();
                    },
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
