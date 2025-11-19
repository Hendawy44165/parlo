import 'package:flutter/material.dart';
import 'package:parlo/core/enums/message_type_enum.dart';
import 'package:parlo/features/chat/logic/entities/message_entity.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_state.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_room_audio_message_bubble.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_room_day_separator.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_room_text_message_bubble.dart';

class MessageEntitiesList extends StatelessWidget {
  const MessageEntitiesList({super.key, required this.state, required this.notifier, required this.conversationId});

  final ChatRoomState state;
  final ChatRoomNotifier notifier;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final List<_ChatListEntry> entries = _buildEntries(state.messages);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final bool isNearTop = notification.metrics.pixels <= notification.metrics.minScrollExtent + 24;
        if (isNearTop && !state.isLoading) {
          notifier.loadNextMessages(conversationId);
        }
        return false;
      },
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: entries.length + (state.isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (state.isLoading && index == entries.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final _ChatListEntry entry = entries[entries.length - 1 - index];

          return entry.map(
            message:
                (MessageEntity message) => switch (message.type) {
                  ChatMessageType.text => ChatRoomTextMessageBubble(message: message),
                  ChatMessageType.audio => ChatRoomAudioMessageBubble(
                    message: message,
                    onTogglePlayback: () {
                      // TODO: toggle audio
                    },
                  ),
                },
            separator: (String label) => ChatRoomDaySeparator(label: label),
          );
        },
      ),
    );
  }

  List<_ChatListEntry> _buildEntries(List<MessageEntity> items) {
    if (items.isEmpty) return const [];

    final List<_ChatListEntry> entries = [];
    DateTime? previousDate;
    for (final MessageEntity message in items) {
      final DateTime date = DateTime(message.timestamp.year, message.timestamp.month, message.timestamp.day);
      if (previousDate == null || date.isAfter(previousDate)) {
        entries.add(_ChatListEntry.separator(_resolveLabel(message.timestamp)));
        previousDate = date;
      }
      entries.add(_ChatListEntry.message(message));
    }
    return entries;
  }

  String _resolveLabel(DateTime timestamp) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (date == today) return 'TODAY';
    if (date == yesterday) return 'YESTERDAY';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}';
  }
}

class _ChatListEntry {
  const _ChatListEntry._(this._message, this._label);

  factory _ChatListEntry.message(MessageEntity message) => _ChatListEntry._(message, null);

  factory _ChatListEntry.separator(String label) => _ChatListEntry._(null, label);

  final MessageEntity? _message;
  final String? _label;

  T map<T>({required T Function(MessageEntity message) message, required T Function(String label) separator}) {
    if (_message != null) {
      return message(_message);
    }
    return separator(_label!);
  }
}
