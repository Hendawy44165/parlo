import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/logic/entities/message_entity.dart';

class ChatRoomTextMessageBubble extends StatelessWidget {
  const ChatRoomTextMessageBubble({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final Alignment alignment = message.isMine ? Alignment.centerRight : Alignment.centerLeft;

    final Color bubbleColor = message.isMine ? ColorsManager.primaryPurple : ColorsManager.lightNavyBlue;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(22)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(message.text ?? '', style: TextStyleManager.white16Regular),
              const SizedBox(height: 8),
              Text(
                _formatTime(message.timestamp),
                style: TextStyleManager.dimmed12Regular.copyWith(color: ColorsManager.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final String hours = time.hour.toString().padLeft(2, '0');
    final String minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
