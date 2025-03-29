import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/app.dart';
import 'package:parlo/core/di.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:parlo/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load();
  setupDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: ColorsManager.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  FlutterNativeSplash.remove();

  runApp(ProviderScope(child: ParloApp()));
}
