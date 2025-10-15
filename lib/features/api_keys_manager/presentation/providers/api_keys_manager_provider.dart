import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';
import 'package:parlo/features/api_keys_manager/logic/services/api_keys_service.dart';
import 'package:parlo/features/api_keys_manager/presentation/providers/api_keys_manager_state.dart';

class ApiKeyManagerNotifier extends StateNotifier<ApiKeyManagerState> {
  final ApiKeysService _service;

  ApiKeyManagerNotifier(this._service)
    : super(
        const ApiKeyManagerState(
          apiKeys: [],
          providerState: ProviderState.initial,
        ),
      ) {
    _loadInitialKeys();
  }

  void selectApiKey(String id) {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final updatedKeys =
        state.apiKeys.map((key) {
          return key.copyWith(isSelected: key.id == id);
        }).toList();

    state = state.copyWith(
      apiKeys: updatedKeys,
      providerState: ProviderState.data,
    );
  }

  Future<void> deleteApiKey(String id) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.deleteApiKey(id);

    if (response.isSuccess) {
      state = state.copyWith(
        apiKeys: state.apiKeys.where((key) => key.id != id).toList(),
        providerState: ProviderState.data,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  void deselectAll() {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final updatedKeys =
        state.apiKeys.map((key) {
          return key.copyWith(isSelected: false);
        }).toList();

    state = state.copyWith(
      apiKeys: updatedKeys,
      providerState: ProviderState.data,
    );
  }

  void setToDefaultState() {
    if (state.isError)
      state = state.copyWith(
        providerState: ProviderState.data,
        code: null,
        error: null,
      );
  }

  Future<void> addNewApiKey({required String name, required String key}) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final newKey = ApiKeyEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      key: key,
    );

    final response = await _service.addNewApiKey(newKey);

    if (response.isSuccess) {
      state = state.copyWith(
        apiKeys: [...state.apiKeys, newKey],
        providerState: ProviderState.data,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  Future<void> _loadInitialKeys() async {
    state = state.copyWith(providerState: ProviderState.loading);

    await Future.delayed(const Duration(seconds: 2));
    final response = await _service.getAllApiKeys();

    if (response.isSuccess) {
      state = state.copyWith(
        apiKeys: response.data,
        providerState: ProviderState.data,
      );
    } else {
      state = state.copyWith(
        apiKeys: [],
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }
}

StateNotifierProvider<ApiKeyManagerNotifier, ApiKeyManagerState>
getApiKeyManagerProvider() =>
    StateNotifierProvider<ApiKeyManagerNotifier, ApiKeyManagerState>((ref) {
      return ApiKeyManagerNotifier(getIt<ApiKeysService>());
    });
