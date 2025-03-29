import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/features/auth/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/services/auth_service.dart';

class SignupNotifier extends StateNotifier<AsyncValue> {
  SignupNotifier() : super(const AsyncData(null));

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _service = AuthService();

  signup() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    if (!AuthFieldsValidatorService.isValidEmail(email))
      return state = AsyncError('Invalid email format', StackTrace.current);

    if (!AuthFieldsValidatorService.isValidPassword(password))
      return state = AsyncError('Invalid password format', StackTrace.current);

    if (!AuthFieldsValidatorService.isValidUsername(username))
      return state = AsyncError('Invalid username format', StackTrace.current);

    final response = await _service.signup(
      email: email,
      password: password,
      username: username,
    );

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

StateNotifierProvider<SignupNotifier, AsyncValue> getSignupProvider() =>
    StateNotifierProvider<SignupNotifier, AsyncValue>(
      (ref) => SignupNotifier(),
    );
