import 'package:flutter/material.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:parlo/features/auth/presentation/screens/login_screen.dart';
import 'package:parlo/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:parlo/features/auth/presentation/screens/signup_screen.dart';
import 'package:parlo/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:parlo/features/chat/presentation/screens/chats_screen.dart';
import 'package:parlo/features/settings/presentation/screens/settings_screen.dart';
import 'package:parlo/features/api_keys_manager/presentation/screens/api_key_manager_screen.dart';

class AppRouter {
  const AppRouter();

  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case Routes.apiKeyManager:
        return MaterialPageRoute(builder: (_) => const ApiKeyManagerScreen());
      case Routes.otpVerification:
        return MaterialPageRoute(
          builder:
              (_) => OtpVerificationScreen(email: (arguments as Map)['email']),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => UpdatePasswordScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => ChatsScreen());
      case Routes.chatRoom:
        return MaterialPageRoute(
          builder:
              (_) => ChatRoomScreen(
                conversationId: (arguments as Map)['conversationId'],
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(
                  child: Text(
                    "Page not found",
                    style: TextStyleManager.white32Regular,
                  ),
                ),
              ),
        );
    }
  }
}
