import 'package:parlo/core/models/user_model.dart';
import 'package:parlo/features/chat/data/models/conversation_model.dart';
import 'package:parlo/features/chat/data/models/conversation_participant_model.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineChatEntriesDataSource {
  OnlineChatEntriesDataSource({required this.supabase});

  final Supabase supabase;

  Future<List<Map<String, dynamic>>> getChatEntries() async {
    final models = <Map<String, dynamic>>[];

    // 1 get conversations
    final conversations = await _getConversations(supabase.client.auth.currentUser!.id);

    for (final conversation in conversations) {
      if (conversation.lastMessageId == null) continue;

      // 2 get messages
      final messageMaps = await supabase.client
          .from('messages')
          .select('*')
          .eq('id', conversation.lastMessageId!)
          .limit(1);
      if (messageMaps.isEmpty) continue;
      final messageModel = MessageModel.fromMap(messageMaps[0]);

      // 3 get other participant
      final conversationParticipantMap =
          (await supabase.client
              .from('conversation_participants')
              .select('*')
              .eq('conversation_id', conversation.id)
              .eq('user_id', supabase.client.auth.currentUser!.id))[0];
      final conversationParticipantModel = ConversationParticipantModel.fromMap(conversationParticipantMap);

      // 4 get other user
      final userMap =
          (await supabase.client
              .from('conversation_participants')
              .select('users(*)')
              .eq('conversation_id', conversation.id)
              .neq('user_id', supabase.client.auth.currentUser!.id)
              .maybeSingle())?['users'];

      final userModel = UserModel.fromMap(userMap);

      final model = {
        'conversation': conversation,
        'message': messageModel,
        'participant': conversationParticipantModel,
        'user': userModel,
      };
      models.add(model);
    }
    return models;
  }

  Future<Map<String, dynamic>?> getChatEntry(String conversationId) async {
    // 1 get conversation
    final conversationMap =
        await supabase.client.from('conversations').select('*').eq('id', conversationId).maybeSingle();
    if (conversationMap == null) return null;

    final conversation = ConversationModel.fromMap(conversationMap);

    if (conversation.lastMessageId == null) return null;

    // 2 get message
    final messageMaps = await supabase.client
        .from('messages')
        .select('*')
        .eq('id', conversation.lastMessageId!)
        .limit(1);
    if (messageMaps.isEmpty) return null;
    final messageModel = MessageModel.fromMap(messageMaps[0]);

    // 3 get conversation participant
    final conversationParticipantMap =
        (await supabase.client
            .from('conversation_participants')
            .select('*')
            .eq('conversation_id', conversationId)
            .eq('user_id', supabase.client.auth.currentUser!.id)
            .maybeSingle());
    if (conversationParticipantMap == null) return null;

    final conversationParticipantModel = ConversationParticipantModel.fromMap(conversationParticipantMap);

    // 4 get other user
    final userMap =
        (await supabase.client
            .from('conversation_participants')
            .select('users(*)')
            .eq('conversation_id', conversationId)
            .neq('user_id', supabase.client.auth.currentUser!.id)
            .maybeSingle())?['users'];
    if (userMap == null) return null;

    final userModel = UserModel.fromMap(userMap);

    final model = {
      'conversation': conversation,
      'message': messageModel,
      'participant': conversationParticipantModel,
      'user': userModel,
    };
    return model;
  }

  // TODO: refactor by removing this for consistency in filew
  Future<List<ConversationModel>> _getConversations(String userId) async {
    final response = await supabase.client
        .from('conversations')
        .select('*, conversation_participants!inner(user_id)')
        .eq('conversation_participants.user_id', supabase.client.auth.currentUser!.id);
    final conversations = (response as List).map((e) => ConversationModel.fromMap(e as Map<String, dynamic>)).toList();
    return conversations;
  }
}
