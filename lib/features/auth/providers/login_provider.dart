import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/features/auth/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/services/auth_service.dart';

class LoginNotifier extends StateNotifier<AsyncValue> {
  LoginNotifier({required AuthService service})
    : _service = service,
      super(const AsyncData(null));

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _service;

  login() async {}

  signinWithGoogle() async {}
}

StateNotifierProvider<LoginNotifier, AsyncValue> getLoginProvider(
  AuthService service,
) => StateNotifierProvider<LoginNotifier, AsyncValue>(
  (ref) => LoginNotifier(service: service),
);
