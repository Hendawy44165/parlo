import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/chat/data/repositories/chat_entry_repository.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  ChatService({required this.chatEntryRepository});
  final ChatEntryRepository chatEntryRepository;

  Future<ResponseModel<List<ChatEntryEntity>>> getChats() async {
    try {
      final chats = await chatEntryRepository.getChats();
      return ResponseModel.success(chats);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetChatEntries,
        ErrorHandlingService.getMessage(Codes.couldNotGetChatEntries),
      );
    }
  }

  Future<ResponseModel<String>> createNewConversation(
    String targetEmail,
  ) async {
    try {
      final String conversationId = await chatEntryRepository
          .createNewConversation(targetEmail);
      return ResponseModel.success(conversationId);
    } on PostgrestException {
      return ResponseModel.failure(
        Codes.couldNotCreateNewConversation,
        ErrorHandlingService.getMessage(Codes.couldNotCreateNewConversation),
      );
    } catch (e) {
      return ResponseModel.failure(
        Codes.unknown,
        ErrorHandlingService.getMessage(Codes.unknown),
      );
    }
  }

  Future<ResponseModel> searchChat(String chatName) async {
    throw UnimplementedError();
  }
}
