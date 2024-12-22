import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: ColorManager.primary,
    colorScheme: ColorScheme.light(primary: ColorManager.primary),
    fontFamily: GoogleFonts.notoSans().fontFamily,
    // inputDecorationTheme: InputDecorationTheme(
    //   focusColor: ColorManager.blueDark,
    //   enabledBorder: OutlineInputBorder(
    //     borderSide: const BorderSide(color: Colors.transparent),
    //     borderRadius: BorderRadius.circular(AppSize.s10),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: ColorManager.blueDark),
    //     borderRadius: BorderRadius.circular(AppSize.s10),
    //   ),
    //   focusedErrorBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: ColorManager.error),
    //     borderRadius: BorderRadius.circular(AppSize.s10),
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: ColorManager.error),
    //     borderRadius: BorderRadius.circular(AppSize.s10),
    //   ),
    //   errorStyle: const TextStyle(fontSize: AppSize.s14),
    // ),
  );
}
