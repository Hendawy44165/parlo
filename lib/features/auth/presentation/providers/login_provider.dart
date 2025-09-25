import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart';

class LoginNotifier extends StateNotifier<AuthState> {
  LoginNotifier(this._service)
    : super(const AuthState(providerState: ProviderState.initial));

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _service;

  Future<void> login() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

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

    final response = await _service.login(email: email, password: password);
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

  Future<void> sendPasswordResetEmail() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 400,
        error: 'Invalid email format',
      );
      return;
    }

    final response = await _service.sendPasswordResetEmail(email: email);
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

StateNotifierProvider<LoginNotifier, AuthState> getLoginProvider() =>
    StateNotifierProvider<LoginNotifier, AuthState>(
      (ref) => LoginNotifier(getIt<AuthService>()),
    );
