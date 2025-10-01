import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;

class LoginNotifier extends StateNotifier<m_auth_state.AuthState> {
  LoginNotifier(this._service)
    : super(const m_auth_state.AuthState(providerState: ProviderState.initial));

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _service;

  Future<void> login() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      // TODO: make the error codes constants in separate file
      state = state.copyWith(
        providerState: ProviderState.error,
        code:
            101564, // 1 0 1564 (feature 1, local is 0, code 1564) make this constant outside file
        error: 'Invalid email format. Please enter a valid email.',
      );
      return;
    }
    if (!AuthFieldsValidatorService.isValidPassword(password)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 101565,
        // TODO: make the error codes constants in separate file to support localization
        error:
            'Password must be at least 8 characters and include uppercase, lowercase, and a number.',
      );
      return;
    }

    final response = await _service.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, code: 200);
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

    // final response = await _service.signInWithGoogle();
    // if (response.isSuccess) {
    //   state = state.copyWith(providerState: ProviderState.data);
    // } else {
    //   state = state.copyWith(
    //     providerState: ProviderState.error,
    //     code: response.errorCode,
    //     error: response.error,
    //   );
    // }
  }

  Future<void> sendPasswordResetEmail() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: 101564,
        error: 'Invalid email format. Please enter a valid email.',
      );
      return;
    }

    // TODO: the email is sent but the reset link doesn't work
    final response = await _service.resetPassword(email);
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

StateNotifierProvider<LoginNotifier, m_auth_state.AuthState>
getLoginProvider() =>
    StateNotifierProvider<LoginNotifier, m_auth_state.AuthState>(
      (ref) => LoginNotifier(getIt<AuthService>()),
    );
