import 'package:parlo/features/api_keys_manager/data/models/api_keys_model.dart';

class ApiKeyEntity {
  final String id;
  final String name;
  final String key;
  final bool isSelected;

  const ApiKeyEntity({required this.id, required this.name, required this.key, this.isSelected = false});

  ApiKeyEntity copyWith({String? id, String? name, String? key, bool? isSelected}) {
    return ApiKeyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      key: key ?? this.key,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory ApiKeyEntity.fromJson(Map<String, dynamic> json) {
    return ApiKeyEntity(id: json['id'], name: json['name'], key: json['key']);
  }

  factory ApiKeyEntity.fromModel(ApiKeyModel model) {
    return ApiKeyEntity(id: model.id, name: model.name, key: model.key);
  }

  ApiKeyModel toModel() {
    return ApiKeyModel(id: id, name: name, key: key, isSelected: isSelected);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'key': key};
  }
}
