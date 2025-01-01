import 'package:cabby_driver/app/di.dart';
import 'package:cabby_driver/core/resources/theme_manager.dart';
import 'package:cabby_driver/core/routes/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cabby Driver',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
