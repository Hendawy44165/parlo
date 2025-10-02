import 'package:flutter/material.dart';
import 'package:parlo/core/routing/app_router.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParloApp extends StatelessWidget {
  ParloApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService().onAuthStateChange,
      builder: (context, snapshot) {
        final session = AuthService().currentSession;
        return MaterialApp(
          key: ValueKey(snapshot.data),
          title: 'Parlo',
          theme: ThemeData(
            primaryColor: ColorsManager.primaryPurple,
            scaffoldBackgroundColor: ColorsManager.black,
            fontFamily: 'Ubuntu',
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: session == null ? Routes.login : Routes.settings,
        );
      },
    );
  }
}
