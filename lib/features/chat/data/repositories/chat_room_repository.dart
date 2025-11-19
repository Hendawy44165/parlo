import 'package:parlo/features/chat/data/datasources/offline_chat_room_datasource.dart';
import 'package:parlo/features/chat/data/datasources/online_chat_room_datasource.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRoomRepository {
  ChatRoomRepository({required this.onlineDataSource, required this.offlineDataSource, required this.supabase});

  final OnlineChatRoomDatasource onlineDataSource;
  final OfflineChatRoomDatasource offlineDataSource;
  final SupabaseClient supabase;

  Future<List<MessageModel>> getMessages(String conversationId, {int start = 0, int end = 5}) async {
    // TODO: final app will only fetch from offline due to e2ee
    final messageModels = <MessageModel>[];
    final messages = await supabase
        .from('messages')
        .select('*')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false)
        .limit(end);
    for (int i = start; i < end; i++) {
      final message = messages[i];
      final messageModel = MessageModel.fromMap(message);
      messageModels.add(messageModel);
    }
    return messageModels;
  }

  Future<List<MessageModel>> getUnreadMessages(String conversationId) async {
    final userId = supabase.auth.currentUser!.id;
    final messages = await supabase
        .from('messages')
        .select('*')
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId)
        .eq('is_seen', false)
        .order('created_at', ascending: false);
    final messageModels = messages.map((e) => MessageModel.fromMap(e)).toList();
    return messageModels;
  }
}
