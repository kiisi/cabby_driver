import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomButton extends StatelessWidget {
  bool isLoading;
  final VoidCallback onPressed;
  final String label;

  CustomButton(
      {super.key,
      this.isLoading = false,
      required this.onPressed,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          fixedSize: const Size.fromHeight(48.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SpinKitFadingCircle(
                color: Colors.white,
                size: 24,
              )
            : Text(
                label,
                style: const TextStyle(fontSize: 16.0),
              ),
      ),
    );
  }
}
