import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';

class ApiKeyModel extends ApiKeyEntity {
  const ApiKeyModel({
    required super.id,
    required super.name,
    required super.key,
    required super.isSelected,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) {
    return ApiKeyModel(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      isSelected: json['isSelected'],
    );
  }

  factory ApiKeyModel.fromEntity(ApiKeyEntity entity) {
    return ApiKeyModel(
      id: entity.id,
      name: entity.name,
      key: entity.key,
      isSelected: entity.isSelected,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'key': key, 'isSelected': isSelected};
  }
}
