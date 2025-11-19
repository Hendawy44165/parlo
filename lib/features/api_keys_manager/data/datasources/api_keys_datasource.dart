import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parlo/features/api_keys_manager/data/models/api_keys_model.dart';

class ApiKeysLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const _apiKeysStorageKey = 'api_keys';

  ApiKeysLocalDataSource(this._secureStorage);

  Future<List<ApiKeyModel>> getAllApiKeys() async {
    if (await _secureStorage.containsKey(key: _apiKeysStorageKey) == false) return [];
    final jsonString = await _secureStorage.read(key: _apiKeysStorageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ApiKeyModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load API keys');
  }

  Future<void> saveApiKeys(List<ApiKeyModel> apiKeys) async {
    final jsonList = apiKeys.map((apiKey) => apiKey.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _secureStorage.write(key: _apiKeysStorageKey, value: jsonString);
  }
}
