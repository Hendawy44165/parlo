import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/codes_enum.dart';
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
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;

  Future<void> login() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    _emailErrorMessage = null;
    _passwordErrorMessage = null;

    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      _emailErrorMessage = 'Invalid email format.';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }
    if (!AuthFieldsValidatorService.isValidPassword(password)) {
      _passwordErrorMessage =
          'Password must be at least 8 characters and include uppercase, lowercase, and a number.';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }

    final response = await _service.login(email: email, password: password);
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, code: null);
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.signInWithGoogle();
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, code: null);
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  Future<void> resetPassword() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      _emailErrorMessage = 'Invalid Email Format';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }

    final response = await _service.resetPassword(email);
    if (response.isSuccess) {
      state = state.copyWith(
        providerState: ProviderState.data,
        code: Codes.forgotPassword,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  void setToDefaultState() {
    if (state.isError)
      state = state.copyWith(
        providerState: ProviderState.data,
        code: null,
        error: null,
      );
  }

  //! private members
  final AuthService _service;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
}

StateNotifierProvider<LoginNotifier, m_auth_state.AuthState>
getLoginProvider() =>
    StateNotifierProvider<LoginNotifier, m_auth_state.AuthState>(
      (ref) => LoginNotifier(getIt<AuthService>()),
    );
