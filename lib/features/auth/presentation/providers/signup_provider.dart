import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;

class SignupNotifier extends StateNotifier<m_auth_state.AuthState> {
  SignupNotifier(this._service)
    : super(const m_auth_state.AuthState(providerState: ProviderState.initial));

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get usernameErrorMessage => _usernameErrorMessage;

  Future<void> signup() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    _usernameErrorMessage = null;
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

    if (!AuthFieldsValidatorService.isValidUsername(username)) {
      _usernameErrorMessage =
          'Username must be 3–20 characters long and can only contain letters, numbers, and underscores.';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }

    final response = await _service.signUp(
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

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.signInWithGoogle();

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

  void setToDataState() {
    if (state.isError)
      state = state.copyWith(
        providerState: ProviderState.data,
        code: 0,
        error: null,
      );
  }

  //! private members
  final AuthService _service;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _usernameErrorMessage;
}

StateNotifierProvider<SignupNotifier, m_auth_state.AuthState>
getSignupProvider() =>
    StateNotifierProvider<SignupNotifier, m_auth_state.AuthState>(
      (ref) => SignupNotifier(getIt<AuthService>()),
    );
