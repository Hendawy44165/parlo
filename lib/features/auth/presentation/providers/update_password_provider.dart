import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;

class UpdatePasswordNotifier extends StateNotifier<m_auth_state.AuthState> {
  UpdatePasswordNotifier(this._service)
    : super(const m_auth_state.AuthState(providerState: ProviderState.initial));

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? get newPasswordErrorMessage => _newPasswordErrorMessage;
  String? get confirmPasswordErrorMessage => _confirmPasswordErrorMessage;

  Future<void> updatePassword() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    _newPasswordErrorMessage = null;
    _confirmPasswordErrorMessage = null;

    if (!AuthFieldsValidatorService.isValidPassword(newPassword)) {
      _newPasswordErrorMessage =
          'Password must be at least 8 characters and include uppercase, lowercase, and a number.';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }

    if (newPassword != confirmPassword) {
      _confirmPasswordErrorMessage = 'Passwords do not match.';
      state = state.copyWith(providerState: ProviderState.initial);
      return;
    }

    final response = await _service.updatePassword(newPassword);
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

  Future<void> signOut() async {
    await _service.signOut();
  }

  void setToDataState() {
    if (state.isError)
      state = state.copyWith(
        providerState: ProviderState.data,
        code: 0,
        error: null,
      );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  //! private members
  final AuthService _service;
  String? _newPasswordErrorMessage;
  String? _confirmPasswordErrorMessage;
}

StateNotifierProvider<UpdatePasswordNotifier, m_auth_state.AuthState>
getUpdatePasswordProvider() =>
    StateNotifierProvider<UpdatePasswordNotifier, m_auth_state.AuthState>(
      (ref) => UpdatePasswordNotifier(getIt<AuthService>()),
    );
