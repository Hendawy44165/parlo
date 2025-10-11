import 'package:parlo/core/enums/provider_state_enum.dart';

class AuthState {
  final ProviderState _providerState;
  final int code;
  final String? error;

  const AuthState({
    required ProviderState providerState,
    this.code = 0,
    this.error,
  }) : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isData => _providerState == ProviderState.data;
  bool get isError => _providerState == ProviderState.error;

  AuthState copyWith({ProviderState? providerState, int? code, String? error}) {
    return AuthState(
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
    );
  }
}
