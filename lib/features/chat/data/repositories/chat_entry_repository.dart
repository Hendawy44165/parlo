import 'dart:async';

import 'package:parlo/features/chat/data/datasources/online_chat_entries_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatEntryRepository {
  ChatEntryRepository({required this.onlineDataSource, required this.supabase});

  final OnlineChatEntriesDataSource onlineDataSource;
  final SupabaseClient supabase;

  Future<List<Map<String, dynamic>>> getChats() async {
    return await onlineDataSource.getChatEntries();
  }

  Future<String> createNewConversation(String targetEmail) async {
    return await supabase.rpc('create_conversation', params: {'target_user_email': targetEmail});
  }

  Future<Map<String, dynamic>?> getConversationInfo(String conversationId) async {
    return await onlineDataSource.getChatEntry(conversationId);
  }

  Stream<String> listenToConversationsChanges() {
    final StreamController<String> controller = StreamController.broadcast();
    final channel = supabase.channel(Supabase.instance.client.auth.currentUser!.id);
    channel
        .onBroadcast(
          event: 'conversation_participant_created',
          callback: (payload) {
            controller.add(payload['payload']['conversation_id']);
          },
        )
        .onBroadcast(
          event: 'conversation_has_new_message',
          callback: (payload) {
            controller.add(payload['payload']['conversation_id']);
          },
        )
        .subscribe();
    return controller.stream;
  }

  Stream<Map<String, dynamic>> listenToNewMessages(String conversationId) {
    final StreamController<Map<String, dynamic>> controller = StreamController.broadcast();
    final channel = supabase.channel(conversationId);
    channel
        .onBroadcast(
          event: 'message_inserted',
          callback: (msg) {
            controller.add(msg);
          },
        )
        .subscribe();
    return controller.stream;
  }
}
