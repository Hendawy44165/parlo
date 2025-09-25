import 'package:flutter/material.dart';
import 'package:parlo/core/routing/app_router.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';

class ParloApp extends StatelessWidget {
  ParloApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: AuthService().uidStream,
      builder: (context, snapshot) {
        return MaterialApp(
          key: ValueKey(snapshot.data),
          title: 'Parlo',
          theme: ThemeData(
            primaryColor: ColorsManager.primaryPurple,
            scaffoldBackgroundColor: ColorsManager.black,
            fontFamily: 'Ubuntu',
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: snapshot.hasData ? Routes.settings : Routes.login,
        );
      },
    );
  }
}
