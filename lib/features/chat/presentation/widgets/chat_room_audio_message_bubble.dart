import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/logic/entities/message_entity.dart';

class ChatRoomAudioMessageBubble extends StatelessWidget {
  const ChatRoomAudioMessageBubble({super.key, required this.message, this.onTogglePlayback});

  final MessageEntity message;
  final VoidCallback? onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final Alignment alignment = message.isMine ? Alignment.centerRight : Alignment.centerLeft;

    final Color bubbleColor =
        message.isMine ? ColorsManager.primaryPurple.withValues(alpha: 0.9) : ColorsManager.lightNavyBlue;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(22)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180, maxWidth: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPlayPauseButton(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildProgressBar()),
                  const SizedBox(width: 12),
                  Text(
                    _formatDuration(message.audioDuration),
                    style: TextStyleManager.dimmed12Regular.copyWith(color: ColorsManager.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: onTogglePlayback,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: ColorsManager.white.withValues(alpha: 0.12), shape: BoxShape.circle),
        child: Icon(message.isPlaying ? Icons.pause : Icons.play_arrow, color: ColorsManager.white, size: 24),
      ),
    );
  }

  Widget _buildProgressBar() {
    final double progress = message.audioProgress.clamp(0, 1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 4,
        backgroundColor: ColorsManager.white.withValues(alpha: 0.15),
        valueColor: const AlwaysStoppedAnimation<Color>(ColorsManager.white),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final String hours = time.hour.toString().padLeft(2, '0');
    final String minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
