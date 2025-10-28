import 'dart:convert';

class MessageModel {
  final String id;
  final String senderId;
  final int? audioLength;
  final String? audioUrl;
  final bool isSeen;
  final DateTime createdAt;
  final String conversationId;
  final String? text;
  final String? senderEphemeralPublicKey;
  final int counter;

  MessageModel({
    required this.id,
    required this.senderId,
    this.audioLength,
    this.audioUrl,
    required this.isSeen,
    required this.createdAt,
    required this.conversationId,
    this.text,
    this.senderEphemeralPublicKey,
    required this.counter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'audio_length': audioLength,
      'audio_url': audioUrl,
      'is_seen': isSeen,
      'created_at': createdAt.toIso8601String(),
      'conversation_id': conversationId,
      'text': text,
      'sender_ephemeral_public_key': senderEphemeralPublicKey,
      'counter': counter,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      audioLength: map['audio_length']?.toInt(),
      audioUrl: map['audio_url'],
      isSeen: map['is_seen'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      conversationId: map['conversation_id'] ?? '',
      text: map['text'],
      senderEphemeralPublicKey: map['sender_ephemeral_public_key'],
      counter: map['counter']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  MessageModel copyWith({
    String? id,
    String? senderId,
    int? audioLength,
    String? audioUrl,
    bool? isSeen,
    DateTime? createdAt,
    String? conversationId,
    String? text,
    String? senderEphemeralPublicKey,
    int? counter,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      audioLength: audioLength ?? this.audioLength,
      audioUrl: audioUrl ?? this.audioUrl,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      senderEphemeralPublicKey:
          senderEphemeralPublicKey ?? this.senderEphemeralPublicKey,
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, audioLength: $audioLength, audioUrl: $audioUrl, isSeen: $isSeen, createdAt: $createdAt, conversationId: $conversationId, text: $text, senderEphemeralPublicKey: $senderEphemeralPublicKey, counter: $counter)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.id == id &&
        other.senderId == senderId &&
        other.audioLength == audioLength &&
        other.audioUrl == audioUrl &&
        other.isSeen == isSeen &&
        other.createdAt == createdAt &&
        other.conversationId == conversationId &&
        other.text == text &&
        other.senderEphemeralPublicKey == senderEphemeralPublicKey &&
        other.counter == counter;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        audioLength.hashCode ^
        audioUrl.hashCode ^
        isSeen.hashCode ^
        createdAt.hashCode ^
        conversationId.hashCode ^
        text.hashCode ^
        senderEphemeralPublicKey.hashCode ^
        counter.hashCode;
  }
}
