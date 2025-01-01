import 'package:another_flushbar/flushbar.dart';
import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static void showErrorFlushBar({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      icon: Icon(Icons.not_interested_outlined, color: ColorManager.white),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xFFFC5521),
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.linear,
      duration: const Duration(seconds: 5),
      messageColor: ColorManager.white,
      message: message,
      animationDuration: const Duration(milliseconds: 400),
    ).show(context);
  }

  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      icon: Icon(Icons.task_alt, color: ColorManager.white),
      shouldIconPulse: false,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: ColorManager.primary,
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.linear,
      duration: const Duration(seconds: 5),
      messageColor: ColorManager.white,
      message: message,
      animationDuration: const Duration(milliseconds: 400),
    ).show(context);
  }

  static void showWarningSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: ColorManager.white),
        textAlign: TextAlign.left,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 340,
        right: 10,
        left: 10,
      ),
      backgroundColor: Colors.grey.shade800,
      showCloseIcon: true,
      closeIconColor: ColorManager.white,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
