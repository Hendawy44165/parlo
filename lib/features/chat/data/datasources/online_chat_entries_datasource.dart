import 'package:parlo/core/models/user_model.dart';
import 'package:parlo/features/chat/data/models/conversation_model.dart';
import 'package:parlo/features/chat/data/models/conversation_participant_model.dart';
import 'package:parlo/features/chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineChatEntriesDataSource {
  OnlineChatEntriesDataSource({required this.supabase});

  final Supabase supabase;

  Future<List<Map<String, dynamic>>> getChatEntryModels() async {
    final models = <Map<String, dynamic>>[];
    final conversations = await _getConversations(
      supabase.client.auth.currentUser!.id,
    );
    for (final conversation in conversations) {
      final messageMaps = await supabase.client
          .from('messages')
          .select('*')
          .eq('conversation_id', conversation.id);
      if (messageMaps.isEmpty) continue;
      final messageModel = MessageModel.fromMap(messageMaps[0]);
      final conversationParticipantMap =
          (await supabase.client
              .from('conversation_participants')
              .select('*')
              .eq('conversation_id', conversation.id)
              .neq('user_id', supabase.client.auth.currentUser!.id))[0];
      final conversationParticipantModel = ConversationParticipantModel.fromMap(
        conversationParticipantMap,
      );
      // get user model based on conversationParticipantModel.userId
      final userMap =
          (await supabase.client
              .from('users')
              .select('*')
              .eq('id', conversationParticipantModel.userId))[0];
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

  Future<List<ConversationModel>> _getConversations(String userId) async {
    final response = await supabase.client
        .from('conversations')
        .select('*, conversation_participants!inner(user_id)')
        .eq(
          'conversation_participants.user_id',
          supabase.client.auth.currentUser!.id,
        );
    final conversations =
        (response as List)
            .map((e) => ConversationModel.fromMap(e as Map<String, dynamic>))
            .toList();
    return conversations;
  }
}
