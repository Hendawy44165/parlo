import 'package:parlo/core/enums/error_codes_enum.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';
import 'package:parlo/features/api_keys_manager/data/repositories/api_keys_repository.dart';

class ApiKeysService {
  final ApiKeysRepository _repository;

  ApiKeysService(this._repository);

  Future<ResponseModel<List<ApiKeyEntity>>> getAllApiKeys() async {
    try {
      final apiKeys = await _repository.getAllApiKeys();
      return ResponseModel.success(apiKeys);
    } catch (e) {
      return ResponseModel.failure(
        ErrorCodes.couldNotGetElevenLabsApiKeys,
        ErrorHandlingService.getMessage(
          ErrorCodes.couldNotGetElevenLabsApiKeys,
        ),
      );
    }
  }

  Future<ResponseModel<void>> addNewApiKey(ApiKeyEntity apiKey) async {
    try {
      await _repository.addNewApiKey(apiKey);
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(
        ErrorCodes.couldNotAddElevenLabsApiKey,
        ErrorHandlingService.getMessage(ErrorCodes.couldNotAddElevenLabsApiKey),
      );
    }
  }

  Future<ResponseModel<void>> deleteApiKey(String id) async {
    try {
      await _repository.deleteApiKey(id);
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(
        ErrorCodes.couldNotDeleteElevenLabsApiKey,
        ErrorHandlingService.getMessage(
          ErrorCodes.couldNotDeleteElevenLabsApiKey,
        ),
      );
    }
  }
}
