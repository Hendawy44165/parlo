import 'package:parlo/core/enums/message_type_enum.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';

class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.timestamp,
    required this.isMine,
    required this.type,
    this.text,
    this.audioDuration,
    this.audioProgress = 0,
    this.isPlaying = false,
  });

  final String id;
  final DateTime timestamp;
  final bool isMine;
  final ChatMessageType type;
  final String? text;
  final Duration? audioDuration;
  final double audioProgress;
  final bool isPlaying;

  MessageEntity copyWith({
    DateTime? timestamp,
    bool? isMine,
    ChatMessageType? type,
    String? text,
    Duration? audioDuration,
    double? audioProgress,
    bool? isPlaying,
  }) {
    return MessageEntity(
      id: id,
      timestamp: timestamp ?? this.timestamp,
      isMine: isMine ?? this.isMine,
      type: type ?? this.type,
      text: text ?? this.text,
      audioDuration: audioDuration ?? this.audioDuration,
      audioProgress: audioProgress ?? this.audioProgress,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  factory MessageEntity.fromModel(MessageModel model, bool isMine) {
    final type = model.audioLength == null ? ChatMessageType.text : ChatMessageType.audio;
    final audioDuration = model.audioLength != null ? Duration(seconds: model.audioLength!) : null;
    final String text = model.text ?? model.audioLength as String;

    return MessageEntity(
      id: model.id,
      timestamp: model.createdAt,
      isMine: isMine,
      type: type,
      text: text,
      audioDuration: audioDuration,
    );
  }
}
