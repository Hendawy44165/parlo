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
        late final String route;
        switch (snapshot.data?.event) {
          case AuthChangeEvent.signedIn:
            route = Routes.home;
            break;
          case AuthChangeEvent.signedOut:
            route = Routes.login;
            break;
          case AuthChangeEvent.userUpdated:
            route = Routes.home;
            break;
          case AuthChangeEvent.passwordRecovery:
            route = Routes.resetPassword;
            break;
          default:
            route = Routes.login;
            break;
        }
        debugPrint('Auth State Changed: ${snapshot.data}');
        return MaterialApp(
          key: ValueKey(snapshot.data),
          title: 'Parlo',
          theme: ThemeData(
            primaryColor: ColorsManager.primaryPurple,
            scaffoldBackgroundColor: ColorsManager.black,
            fontFamily: 'Ubuntu',
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: route,
        );
      },
    );
  }
}
