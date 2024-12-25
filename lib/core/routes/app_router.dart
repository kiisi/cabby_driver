import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/core/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/login', page: LoginRoute.page, initial: true),
        AutoRoute(path: '/register', page: RegisterRoute.page),
        AutoRoute(path: '/forgot-password', page: ForgotPasswordRoute.page),
        AutoRoute(path: '/otp', page: OtpRoute.page),
        AutoRoute(path: '/reset-password', page: ResetPasswordRoute.page),
        AutoRoute(path: '/register-details', page: RegisterDetailsRoute.page),
      ];
}
