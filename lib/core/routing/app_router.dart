import 'package:flutter/material.dart';
import 'package:parlo/core/themes/text.dart';

class AppRouter {
  const AppRouter();

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
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
