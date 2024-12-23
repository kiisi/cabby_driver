// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:cabby_driver/features/auth/forgot_password.dart' as _i1;
import 'package:cabby_driver/features/auth/login.dart' as _i2;
import 'package:cabby_driver/features/auth/otp.dart' as _i3;
import 'package:cabby_driver/features/auth/register.dart' as _i4;
import 'package:cabby_driver/features/auth/reset_password.dart' as _i5;

/// generated route for
/// [_i1.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i6.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginScreen();
    },
  );
}

/// generated route for
/// [_i3.OtpScreen]
class OtpRoute extends _i6.PageRouteInfo<void> {
  const OtpRoute({List<_i6.PageRouteInfo>? children})
      : super(
          OtpRoute.name,
          initialChildren: children,
        );

  static const String name = 'OtpRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.OtpScreen();
    },
  );
}

/// generated route for
/// [_i4.RegisterScreen]
class RegisterRoute extends _i6.PageRouteInfo<void> {
  const RegisterRoute({List<_i6.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i5.ResetPasswordScreen]
class ResetPasswordRoute extends _i6.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.ResetPasswordScreen();
    },
  );
}
