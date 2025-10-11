import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/app.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Supabase.initialize(
    url: AuthService.supabaseUrl,
    anonKey: AuthService.anonkey,
  );
  setupDependencies();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: ColorsManager.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  FlutterNativeSplash.remove();

  runApp(ProviderScope(child: ParloApp()));
}
