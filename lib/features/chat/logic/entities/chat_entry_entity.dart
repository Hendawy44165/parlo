import 'package:parlo/core/enums/message_status_enum.dart';
import 'package:parlo/core/models/user_model.dart';
import 'package:parlo/features/chat/data/models/conversation_model.dart';
import 'package:parlo/features/chat/data/models/conversation_participant_model.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';

class ChatEntryEntity {
  final String conversationId;
  final String username;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final bool isAudio;
  final String? profilePictureUrl;
  final MessageStatus status;
  final int unreadCount;

  ChatEntryEntity({
    required this.conversationId,
    required this.username,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.isAudio = false,
    this.profilePictureUrl,
    this.status = MessageStatus.received,
    this.unreadCount = 0,
  });

  static ChatEntryEntity? fromModels({
    required ConversationModel conversation,
    required MessageModel? lastMessage,
    required ConversationParticipantModel conversationParticipant,
    required UserModel user,
  }) {
    if (lastMessage == null) return null;

    final bool isAudioMessage =
        lastMessage.audioUrl != null && lastMessage.audioUrl!.isNotEmpty;

    final String messageContent =
        isAudioMessage
            ? _getAudioLengthString(lastMessage.audioLength ?? 0)
            : lastMessage.text ?? '';

    MessageStatus messageStatus = MessageStatus.received;
    if (lastMessage.senderId != user.id) // my message
      messageStatus =
          lastMessage.isSeen ? MessageStatus.read : MessageStatus.sent;

    return ChatEntryEntity(
      conversationId: conversation.id,
      username: user.username,
      lastMessage: messageContent,
      lastMessageTimestamp: lastMessage.createdAt,
      isAudio: isAudioMessage,
      profilePictureUrl: user.avatarUrl,
      status: messageStatus,
      unreadCount: conversationParticipant.unreadCount,
    );
  }

  static String _getAudioLengthString(int lengthInSeconds) {
    final hours = lengthInSeconds ~/ 3600;
    lengthInSeconds -= hours * 3600;
    final minutes = lengthInSeconds ~/ 60;
    final seconds = lengthInSeconds % 60;
    final hoursStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
    final minutesStr = '${minutes.toString().padLeft(2, '0')}:';
    final secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr$secondsStr';
  }
}
