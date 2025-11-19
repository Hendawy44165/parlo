import 'dart:convert';

class ConversationModel {
  final String id;
  final String? lastMessageId;
  final DateTime createdAt;
  final DateTime? deletedAt;

  ConversationModel({required this.id, this.lastMessageId, required this.createdAt, this.deletedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last_message_id': lastMessageId,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      lastMessageId: map['last_message_id'],
      createdAt: DateTime.parse(map['created_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) => ConversationModel.fromMap(json.decode(source));

  ConversationModel copyWith({String? id, String? lastMessageId, DateTime? createdAt, DateTime? deletedAt}) {
    return ConversationModel(
      id: id ?? this.id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  String toString() {
    return 'ConversationModel(id: $id, lastMessageId: $lastMessageId, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationModel &&
        other.id == id &&
        other.lastMessageId == lastMessageId &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ lastMessageId.hashCode ^ createdAt.hashCode ^ deletedAt.hashCode;
  }
}
