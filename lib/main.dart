import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/app.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:parlo/firebase_options.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: ColorsManager.white,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  FlutterNativeSplash.remove();

  runApp(ProviderScope(child: ParloApp()));
}
