import 'package:parlo/features/chat/data/datasources/online_chat_entries_datasource.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatEntryRepository {
  ChatEntryRepository({required this.onlineDataSource, required this.supabase});

  final OnlineChatEntriesDataSource onlineDataSource;
  final SupabaseClient supabase;

  Future<List<ChatEntryEntity>> getChats() async {
    final chatEntries = <ChatEntryEntity>[];
    // TODO: check network connection, if no connection, fetch from local storage
    final chatEntryModels = await onlineDataSource.getChatEntryModels();
    for (final model in chatEntryModels) {
      final chatEntry = ChatEntryEntity.fromModels(
        conversation: model['conversation'],
        conversationParticipant: model['participant'],
        lastMessage: model['message'],
        user: model['user'],
      );
      if (chatEntry != null) chatEntries.add(chatEntry);
    }
    return chatEntries;
  }

  Future<String> createNewConversation(String targetEmail) async {
    return await supabase.rpc(
      'create_or_get_conversation',
      params: {'target_user_email': targetEmail},
    );
  }
}
