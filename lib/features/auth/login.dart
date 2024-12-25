import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
                    'Sign in!',
                    style: TextStyle(
                      fontFamily: 'Euclide',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Ready to Drive? Log in to start accepting rides.',
                    style: TextStyle(
                        fontFamily: 'Euclide',
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(TextSpan(
                      text: 'Forgot password?',
                      style: TextStyle(color: ColorManager.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.router.pushNamed('/forgot-password');
                        },
                    )),
                  ),
                  const SizedBox(height: 16),
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
                        'Log in',
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
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                                color: ColorManager.primary, fontSize: 15.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.router.replaceNamed('/register');
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
