import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';

class ApiKeyManagerState {
  final List<ApiKeyEntity> apiKeys;
  final ProviderState _providerState;

  const ApiKeyManagerState({
    required this.apiKeys,
    required ProviderState providerState,
  }) : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isSuccess => _providerState == ProviderState.success;
  bool get isError => _providerState == ProviderState.error;

  ApiKeyManagerState copyWith({
    List<ApiKeyEntity>? apiKeys,
    ProviderState? providerState,
  }) {
    return ApiKeyManagerState(
      apiKeys: apiKeys ?? this.apiKeys,
      providerState: providerState ?? _providerState,
    );
  }
}
