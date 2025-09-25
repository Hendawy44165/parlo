import 'package:parlo/features/api_keys_manager/data/datasources/api_keys_datasource.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';

class ApiKeysRepository {
  final ApiKeysLocalDataSource _localDataSource;

  ApiKeysRepository(this._localDataSource);

  Future<List<ApiKeyEntity>> getAllApiKeys() async {
    final models = await _localDataSource.getAllApiKeys();
    return models.map((model) => ApiKeyEntity.fromModel(model)).toList();
  }

  Future<void> addNewApiKey(ApiKeyEntity apiKey) async {
    final models = await _localDataSource.getAllApiKeys();
    if (models.any((model) => model.id == apiKey.id))
      throw Exception('API key with id ${apiKey.id} already exists');
    models.add(apiKey.toModel());
    await _localDataSource.saveApiKeys(models);
  }

  Future<void> deleteApiKey(String id) async {
    final models = await _localDataSource.getAllApiKeys();
    if (!models.any((model) => model.id == id))
      throw Exception('API key with id $id does not exist');
    models.removeWhere((model) => model.id == id);
    await _localDataSource.saveApiKeys(models);
  }
}
