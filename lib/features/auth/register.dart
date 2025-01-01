import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/common/custom_flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:cabby_driver/data/request/authentication_request.dart';
import 'package:cabby_driver/domain/usecase/authentication_usecase.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  final RegisterUseCase registerUseCase = getIt<RegisterUseCase>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final TextEditingController lastNameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  void submit() async {
    setState(() {
      isLoading = true;
    });

    (await registerUseCase.execute(RegisterRequest(
            firstName: firstNameTextEditingController.text,
            lastName: lastNameTextEditingController.text,
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text)))
        .fold((error) {
      CustomFlushbar.showErrorFlushBar(
          context: context, message: error.message);
      setState(() {
        isLoading = false;
      });
    }, (success) {
      CustomFlushbar.showSuccessSnackBar(
          context: context, message: success.message ?? '');
      setState(() {
        isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.router.replaceNamed('/register-details');
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
                    'Sign up!',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Join thousands of drivers making travel easier.',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameTextEditingController,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            filled: true,
                            fillColor: const Color(0xfff4f5f6),
                            hintStyle: TextStyle(
                                color: ColorManager.blueDark,
                                fontWeight: FontWeight.w300),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameTextEditingController,
                          decoration: InputDecoration(
                            hintText: "Last Name",
                            filled: true,
                            fillColor: const Color(0xfff4f5f6),
                            hintStyle: TextStyle(
                                color: ColorManager.blueDark,
                                fontWeight: FontWeight.w300),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
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
                      onPressed: () {
                        submit();
                      },
                      child: isLoading
                          ? const SpinKitFadingCircle(
                              color: Colors.white,
                              size: 24,
                            )
                          : const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                                color: ColorManager.primary, fontSize: 15.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.router.replaceNamed('/login');
                              },
                          ),
                        ],
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
}
