import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';
import 'package:parlo/features/chat/logic/services/chat_service.dart';
import 'package:parlo/features/chat/presentation/providers/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._chatService) : super(ChatState(providerState: ProviderState.initial, chatsMap: {})) {
    searchController.addListener(_onSearchChanged);
  }

  final TextEditingController searchController = TextEditingController();

  Future<void> setupStreams() async {
    _chatService.listenToConversationsChanges().data?.listen((response) {
      _handleNewOrUpdatedChat(response.data!);
    });
  }

  void _handleNewOrUpdatedChat(ChatEntryEntity chat) {
    final isNewConversation = !state.chatsMap.containsKey(chat.conversationId);

    if (isNewConversation) {
      state.chatsMap[chat.conversationId] = chat;
      _chatsSet.add(chat);
      state = state.copyWith(chats: _chatsSet.toList());
    } else {
      final currentChat = state.chatsMap[chat.conversationId]!;
      final isAtTop = _chatsSet.first.conversationId == chat.conversationId;

      _chatsSet.remove(currentChat);
      _chatsSet.add(chat);
      state.chatsMap[chat.conversationId] = chat;

      if (!isAtTop) {
        final oldIndex = _chatsSet.toList().indexOf(currentChat);

        state = state.copyWith(
          providerState: ProviderState.animating,
          animatingIndex: oldIndex,
          chats: _chatsSet.toList(),
        );
      } else {
        state = state.copyWith(chats: _chatsSet.toList());
      }
    }
  }

  void animationFinished() {
    state = state.copyWith(providerState: ProviderState.data, animatingIndex: null);
  }

  Future<void> getChats() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _chatService.getChats();
    if (response.isSuccess) {
      state.chatsMap.clear();
      _chatsSet.clear();
      for (final chat in response.data!) {
        state.chatsMap[chat.conversationId] = chat;
        _chatsSet.add(chat);
      }
      state = state.copyWith(providerState: ProviderState.data, chats: _chatsSet.toList(), code: null);
      setupStreams();
    } else {
      state = state.copyWith(providerState: ProviderState.error, code: response.errorCode, error: response.error);
    }
  }

  Future<void> createChat(String email) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    if (!AuthFieldsValidatorService.isValidEmail(email)) {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: Codes.invalidEmail,
        error: ErrorHandlingService.getMessage(Codes.invalidEmail),
      );
      return;
    }

    final response = await _chatService.createNewConversation(email);
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, code: Codes.chatCreated, extraData: response.data);
    } else {
      state = state.copyWith(providerState: ProviderState.error, code: response.errorCode, error: response.error);
    }
  }

  Future<void> searchChatName(String chatName) async {
    // TODO: Optimize by searching locally first before making a service call.
    if (chatName.isEmpty) {
      return;
    }

    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _chatService.searchChat(chatName);
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, chats: response.data, code: null);
    } else {
      state = state.copyWith(providerState: ProviderState.error, code: response.errorCode, error: response.error);
    }
  }

  void setToDefaultState() {
    state = state.copyWith(providerState: ProviderState.data, code: null, error: null, extraData: null);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () {
      searchChatName(searchController.text.trim());
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  //! private members
  Timer? _debounce;
  final ChatService _chatService;
  SplayTreeSet<ChatEntryEntity> _chatsSet = SplayTreeSet<ChatEntryEntity>(
    (a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp),
  );
}

StateNotifierProvider<ChatNotifier, ChatState> getChatProvider() =>
    StateNotifierProvider<ChatNotifier, ChatState>((ref) => ChatNotifier(getIt<ChatService>()));
