import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';

class AuthState {
  final ProviderState _providerState;
  final Codes? code;
  final String? error;

  const AuthState({required ProviderState providerState, this.code, this.error}) : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isData => _providerState == ProviderState.data;
  bool get isError => _providerState == ProviderState.error;

  AuthState copyWith({ProviderState? providerState, Codes? code, String? error}) {
    return AuthState(
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
    );
  }
}
