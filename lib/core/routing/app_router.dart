import 'package:flutter/material.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/screens/login_screen.dart';
import 'package:parlo/features/auth/screens/signup_screen.dart';

class AppRouter {
  const AppRouter();

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(
                  child: Text(
                    "Page not found",
                    style: TextStyleManger.white32Regular,
                  ),
                ),
              ),
        );
    }
  }
}
