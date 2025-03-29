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

  login() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!AuthFieldsValidatorService.isValidEmail(email))
      return state = AsyncError('Invalid email format', StackTrace.current);

    if (!AuthFieldsValidatorService.isValidPassword(password))
      return state = AsyncError('Invalid password format', StackTrace.current);

    final response = await _service.login(email: email, password: password);

    if (response.isSuccess) {
      state = AsyncData(response.data);
    } else {
      state = AsyncError(response.error!, StackTrace.current);
    }
  }

  signinWithGoogle() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    final response = await _service.signInWithGoogle();

    if (response.isSuccess) {
      state = AsyncData(response.data);
    } else {
      state = AsyncError(response.error!, StackTrace.current);
    }
  }
}

StateNotifierProvider<LoginNotifier, AsyncValue> getLoginProvider(
  AuthService service,
) => StateNotifierProvider<LoginNotifier, AsyncValue>(
  (ref) => LoginNotifier(service: service),
);
