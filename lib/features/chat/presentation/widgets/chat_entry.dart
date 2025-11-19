import 'package:flutter/material.dart';
import 'package:parlo/core/enums/message_status_enum.dart';
import 'package:parlo/core/services/time_service.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';

class ChatEntry extends StatelessWidget {
  const ChatEntry({
    super.key,
    required this.username,
    required this.lastMessage,
    required this.time,
    this.profileImageUrl,
    this.status,
    this.unreadCount = 0,
    this.isAudio = false,
  });

  final String username;
  final String lastMessage;
  final DateTime time;
  final String? profileImageUrl;
  final MessageStatus? status;
  final int unreadCount;
  final bool isAudio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white24,
        backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
        child: profileImageUrl == null ? const Icon(Icons.person, color: Colors.white, size: 30) : null,
      ),
      title: Text(username, style: TextStyleManager.white16Bold),
      subtitle: Row(
        children: [
          if (status != null) ...[_buildStatusIcon(status!, ColorsManager.lightGray), const SizedBox(width: 4)],
          if (isAudio) ...[const Icon(Icons.mic, color: ColorsManager.lightGray, size: 18), const SizedBox(width: 4)],
          Expanded(
            child: Text(
              lastMessage,
              style: TextStyleManager.dimmed14Regular,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(TimeService.formatMessageTime(time), style: TextStyleManager.dimmed12Regular),
          const SizedBox(height: 6),
          if (unreadCount > 0)
            Container(
              height: 22,
              width: unreadCount < 10 ? 22 : 38,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(color: ColorsManager.primaryPurple, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(unreadCount < 100 ? '$unreadCount' : '99+', style: TextStyleManager.white12Bold),
              ),
            )
          else
            const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status, Color color) {
    IconData iconData;
    switch (status) {
      case MessageStatus.sent:
        iconData = Icons.done;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        break;
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 18, color: ColorsManager.primaryPurple);
      case MessageStatus.received:
        return const SizedBox.shrink();
    }
    return Icon(iconData, size: 18, color: color);
  }
}
