import 'package:parlo/core/enums/online_status_enum.dart';
import 'package:parlo/core/enums/typing_status_enum.dart';

//! the online status is online when the user opens the conversation, it's not global

class PresenceDataModel {
  PresenceDataModel({
    required this.userId,
    required this.onlineStatus,
    required this.typingStatus,
    this.lastSeen,
  });

  final String userId;
  final OnlineStatus onlineStatus;
  final TypingStatus typingStatus;
  final DateTime? lastSeen;

  factory PresenceDataModel.fromMap(Map<String, dynamic> map) {
    return PresenceDataModel(
      userId: map['user_id'] as String,
      onlineStatus: OnlineStatus.values.firstWhere(
        (e) => e.name == map['online_status'],
        orElse: () => OnlineStatus.offline,
      ),
      typingStatus: TypingStatus.values.firstWhere(
        (e) => e.name == map['typing_status'],
        orElse: () => TypingStatus.none,
      ),
      lastSeen:
          map['last_seen'] != null
              ? DateTime.parse(map['last_seen'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'online_status': onlineStatus.name,
      'typing_status': typingStatus.name,
      'last_seen': lastSeen?.toIso8601String(),
    };
  }

  PresenceDataModel copyWith({
    String? userId,
    OnlineStatus? onlineStatus,
    TypingStatus? typingStatus,
    DateTime? lastSeen,
  }) {
    return PresenceDataModel(
      userId: userId ?? this.userId,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      typingStatus: typingStatus ?? this.typingStatus,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  String toString() {
    return 'PresenceDataModel(userId: $userId, onlineStatus: $onlineStatus, typingStatus: $typingStatus, lastSeen: $lastSeen)';
  }
}
