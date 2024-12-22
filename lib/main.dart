import 'package:cabby_driver/core/resources/theme_manager.dart';
import 'package:cabby_driver/features/auth/login.dart';
import 'package:cabby_driver/features/auth/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabby Driver',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const LoginScreen(),
    );
  }
}
