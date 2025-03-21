import 'package:flutter/material.dart';
import 'package:parlo/core/routing/app_router.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';

class ParloApp extends StatelessWidget {
  ParloApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parlo',
      theme: ThemeData(
        primaryColor: ColorsManager.primary,
        scaffoldBackgroundColor: ColorsManager.black,
        fontFamily: 'Ubuntu',
      ),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: Routes.login,
    );
  }
}
