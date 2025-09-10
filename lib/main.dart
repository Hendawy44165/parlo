import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/app.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
