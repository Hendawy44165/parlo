import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;

class OtpVerificationNotifier extends StateNotifier<m_auth_state.AuthState> {
  OtpVerificationNotifier({required AuthService service, required String email})
    : _service = service,
      _email = email,
      super(const m_auth_state.AuthState(providerState: ProviderState.initial));

  final otpController = TextEditingController();

  Future<void> verifyOtp() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: null,
        error: 'Enter your OTP',
      );
      return;
    }

    final response = await _service.verifyOtpCode(_email, otp);
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

  Future<void> resendCode() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.resetPassword(_email);
    if (response.isSuccess) {
      state = state.copyWith(
        providerState: ProviderState.data,
        code: Codes.otpResentSuccessfully,
      );
      otpController.clear();
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  void setToDefaultState() {
    state = state.copyWith(
      providerState: ProviderState.data,
      code: null,
      error: null,
    );
  }

  //! private members
  final AuthService _service;
  final String _email;
}

StateNotifierProvider<OtpVerificationNotifier, m_auth_state.AuthState>
getOtpVerificationProvider(String email) =>
    StateNotifierProvider<OtpVerificationNotifier, m_auth_state.AuthState>(
      (ref) =>
          OtpVerificationNotifier(service: getIt<AuthService>(), email: email),
    );
