import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';
import 'package:parlo/features/chat/data/repositories/chat_room_repository.dart';
import 'package:parlo/features/chat/logic/entities/message_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRoomService {
  ChatRoomService({required this.chatRoomRepository, required this.supabase});
  final ChatRoomRepository chatRoomRepository;
  final SupabaseClient supabase;

  Future<ResponseModel<List<MessageEntity>>> getUnreadMessages(String conversationId) async {
    try {
      final messages = await chatRoomRepository.getUnreadMessages(conversationId);
      return ResponseModel.success(
        messages.map((e) => MessageEntity.fromModel(e, e.senderId == supabase.auth.currentUser!.id)).toList(),
      );
    } catch (e) {
      return ResponseModel.failure(
        Codes.noUnreadMessagesFound,
        ErrorHandlingService.getMessage(Codes.couldNotGetMessages),
      );
    }
  }

  Future<ResponseModel<List<MessageEntity>>> getMessages(String conversationId, {int start = 0, int end = 5}) async {
    try {
      final messages = await chatRoomRepository.getMessages(conversationId, start: start, end: end);
      return ResponseModel.success(
        messages.map((e) => MessageEntity.fromModel(e, e.senderId == supabase.auth.currentUser!.id)).toList(),
      );
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetMessages,
        ErrorHandlingService.getMessage(Codes.couldNotGetMessages),
      );
    }
  }

  Future<ResponseModel<MessageEntity>> sendTextMessage(String conversationId, String text) async {
    try {
      final message = await supabase.rpc(
        'send_message',
        params: {
          'conversation_id': conversationId,
          'content': text,
          'sender_ephemeral_key': 'LDJFALSDKJF', // TODO: send the actual one for e2ee
          'message_counter': 5, // TODO: send the actual one for e2ee
        },
      );
      final messageModel = MessageModel.fromMap(message);
      return ResponseModel.success(MessageEntity.fromModel(messageModel, true));
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotSendTextMessage,
        ErrorHandlingService.getMessage(Codes.couldNotSendTextMessage),
      );
    }
  }

  Future<ResponseModel<String>> getOtherUsername(String conversationId) async {
    try {
      final res =
          await supabase
              .from('conversation_participants')
              .select('users(username)')
              .eq('conversation_id', conversationId)
              .neq('user_id', supabase.auth.currentUser!.id)
              .single();
      return ResponseModel.success(res['users']['username']);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetOtherUsername,
        ErrorHandlingService.getMessage(Codes.couldNotGetOtherUsername),
      );
    }
  }

  Future<ResponseModel<String?>> getOtherAvatarUrl(String conversationId) async {
    try {
      final res =
          await supabase
              .from('conversation_participants')
              .select('users(avatar_url)')
              .eq('conversation_id', conversationId)
              .neq('user_id', supabase.auth.currentUser!.id)
              .single();
      return ResponseModel.success(res['users']['avatar_url']);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetOtherAvatarUrl,
        ErrorHandlingService.getMessage(Codes.couldNotGetOtherAvatarUrl),
      );
    }
  }
}
