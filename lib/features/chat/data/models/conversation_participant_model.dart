import 'dart:convert';

class ConversationParticipantModel {
  final String id;
  final String userId;
  final int unreadCount;
  final DateTime createdAt;
  final bool isBlocked;
  final DateTime? lastOpen;
  final String conversationId;

  ConversationParticipantModel({
    required this.id,
    required this.userId,
    required this.unreadCount,
    required this.createdAt,
    required this.isBlocked,
    this.lastOpen,
    required this.conversationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
      'is_blocked': isBlocked,
      'last_open': lastOpen?.toIso8601String(),
      'conversation_id': conversationId,
    };
  }

  factory ConversationParticipantModel.fromMap(Map<String, dynamic> map) {
    return ConversationParticipantModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      unreadCount: map['unread_count']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      isBlocked: map['is_blocked'] ?? false,
      lastOpen: map['last_open'] != null ? DateTime.parse(map['last_open']) : null,
      conversationId: map['conversation_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationParticipantModel.fromJson(String source) =>
      ConversationParticipantModel.fromMap(json.decode(source));

  ConversationParticipantModel copyWith({
    String? id,
    String? userId,
    int? unreadCount,
    DateTime? createdAt,
    bool? isBlocked,
    DateTime? lastOpen,
    String? conversationId,
  }) {
    return ConversationParticipantModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      isBlocked: isBlocked ?? this.isBlocked,
      lastOpen: lastOpen ?? this.lastOpen,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  String toString() {
    return 'ConversationParticipantModel(id: $id, userId: $userId, unreadCount: $unreadCount, createdAt: $createdAt, isBlocked: $isBlocked, lastOpen: $lastOpen, conversationId: $conversationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationParticipantModel &&
        other.id == id &&
        other.userId == userId &&
        other.unreadCount == unreadCount &&
        other.createdAt == createdAt &&
        other.isBlocked == isBlocked &&
        other.lastOpen == lastOpen &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        unreadCount.hashCode ^
        createdAt.hashCode ^
        isBlocked.hashCode ^
        lastOpen.hashCode ^
        conversationId.hashCode;
  }
}
