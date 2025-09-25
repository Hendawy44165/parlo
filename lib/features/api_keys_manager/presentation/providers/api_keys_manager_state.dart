import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';

class ApiKeyManagerState {
  final List<ApiKeyEntity> apiKeys;
  final ProviderState _providerState;
  final int code;
  final String? error;

  const ApiKeyManagerState({
    required this.apiKeys,
    required ProviderState providerState,
    this.code = 0,
    this.error,
  }) : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isData => _providerState == ProviderState.data;
  bool get isError => _providerState == ProviderState.error;

  ApiKeyManagerState copyWith({
    List<ApiKeyEntity>? apiKeys,
    ProviderState? providerState,
    int? code,
    String? error,
  }) {
    return ApiKeyManagerState(
      apiKeys: apiKeys ?? this.apiKeys,
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
    );
  }
}
