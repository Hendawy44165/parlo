import 'dart:async';

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
      final chatsMaps = await chatEntryRepository.getChats();
      final chats =
          chatsMaps
              .map(
                (chatMap) => ChatEntryEntity.fromModels(
                  conversation: chatMap['conversation'],
                  conversationParticipant: chatMap['participant'],
                  lastMessage: chatMap['message'],
                  user: chatMap['user'],
                ),
              )
              .toList();

      return ResponseModel.success(chats);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetChatEntries,
        ErrorHandlingService.getMessage(Codes.couldNotGetChatEntries),
      );
    }
  }

  Future<ResponseModel<String>> createNewConversation(String targetEmail) async {
    try {
      final String conversationId = await chatEntryRepository.createNewConversation(targetEmail);
      return ResponseModel.success(conversationId);
    } on PostgrestException {
      return ResponseModel.failure(
        Codes.couldNotCreateNewConversation,
        ErrorHandlingService.getMessage(Codes.couldNotCreateNewConversation),
      );
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel> searchChat(String chatName) async {
    throw UnimplementedError();
  }

  ResponseModel<Stream<ResponseModel<ChatEntryEntity>>> listenToNewConversations() {
    try {
      final streamController = StreamController<ResponseModel<ChatEntryEntity>>.broadcast();

      chatEntryRepository.listenToNewConversations().listen((conversationId) async {
        final conversationModels = await chatEntryRepository.getConversationInfo(conversationId);
        if (conversationModels == null)
          ResponseModel.failure(
            Codes.couldNotGetConversationInfo,
            ErrorHandlingService.getMessage(Codes.couldNotGetConversationInfo),
          );
        final conversationEntity = ChatEntryEntity.fromModels(
          conversation: conversationModels!['conversation'],
          conversationParticipant: conversationModels['participant'],
          lastMessage: conversationModels['message'],
          user: conversationModels['user'],
        );
        streamController.add(ResponseModel.success(conversationEntity));
      });

      return ResponseModel.success(streamController.stream);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotSubscribeToNewConversations,
        ErrorHandlingService.getMessage(Codes.couldNotSubscribeToNewConversations),
      );
    }
  }

  ResponseModel<Stream<ResponseModel<ChatEntryEntity>>> listenToConversationChanges(String conversationId) {
    try {
      final streamController = StreamController<ResponseModel<ChatEntryEntity>>.broadcast();
      chatEntryRepository.listenToConversationChanges(conversationId).listen((messageModel) async {
        // get the conversation info of the current new message
        final conversationModels = await chatEntryRepository.getConversationInfo(conversationId);
        // stream it back
        if (conversationModels == null)
          streamController.add(
            ResponseModel.failure(
              Codes.couldNotGetConversationInfo,
              ErrorHandlingService.getMessage(Codes.couldNotGetConversationInfo),
            ),
          );
        final conversationEntity = ChatEntryEntity.fromModels(
          conversation: conversationModels!['conversation'],
          conversationParticipant: conversationModels['participant'],
          lastMessage: conversationModels['message'],
          user: conversationModels['user'],
        );
        streamController.add(ResponseModel.success(conversationEntity));
      });

      return ResponseModel.success(streamController.stream);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotSubscribeToConversationChanges,
        ErrorHandlingService.getMessage(Codes.couldNotSubscribeToConversationChanges),
      );
    }
  }

  Future<ResponseModel<ChatEntryEntity>> getConversationInfo(String conversationId) async {
    try {
      final conversation = await chatEntryRepository.getConversationInfo(conversationId);

      if (conversation == null) {
        return ResponseModel.failure(
          Codes.couldNotGetConversationInfo,
          ErrorHandlingService.getMessage(Codes.couldNotGetConversationInfo),
        );
      }

      final conversationEntity = ChatEntryEntity.fromModels(
        conversation: conversation['conversation'],
        conversationParticipant: conversation['participant'],
        lastMessage: conversation['message'],
        user: conversation['user'],
      );

      return ResponseModel.success(conversationEntity);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotGetConversationInfo,
        ErrorHandlingService.getMessage(Codes.couldNotGetConversationInfo),
      );
    }
  }
}
