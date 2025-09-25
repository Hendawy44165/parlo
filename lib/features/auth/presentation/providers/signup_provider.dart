import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart';

class SignupNotifier extends StateNotifier<AuthState> {
  SignupNotifier(this._service)
    : super(const AuthState(providerState: ProviderState.initial));

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _service;

  Future<void> signup() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 400,
        error: 'Invalid email format',
      );
      return;
    }

    if (!AuthFieldsValidatorService.isValidPassword(password)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 400,
        error: 'Invalid password format',
      );
      return;
    }

    if (!AuthFieldsValidatorService.isValidUsername(username)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 400,
        error: 'Invalid username format',
      );
      return;
    }

    final response = await _service.signup(
      email: email,
      password: password,
      username: username,
    );

    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data);
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  Future<void> signinWithGoogle() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.signInWithGoogle();

    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data);
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  void setToDataState() {
    if (state.isError)
      state = state.copyWith(
        providerState: ProviderState.data,
        code: 0,
        error: null,
      );
  }
}

StateNotifierProvider<SignupNotifier, AuthState> getSignupProvider() =>
    StateNotifierProvider<SignupNotifier, AuthState>(
      (ref) => SignupNotifier(getIt<AuthService>()),
    );
