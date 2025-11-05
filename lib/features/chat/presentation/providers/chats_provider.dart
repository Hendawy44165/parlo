import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/auth/logic/services/auth_fields_validator_service.dart';
import 'package:parlo/features/chat/logic/services/chat_service.dart';
import 'package:parlo/features/chat/presentation/providers/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._service)
    : super(const ChatState(providerState: ProviderState.initial)) {
    searchController.addListener(_onSearchChanged);
  }

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  Future<void> getChats() async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.getChats();
    if (response.isSuccess) {
      state = state.copyWith(
        providerState: ProviderState.data,
        chats: response.data,
        code: null,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
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

    final response = await _service.createNewConversation(email);
    if (response.isSuccess) {
      state = state.copyWith(
        providerState: ProviderState.data,
        code: Codes.chatCreated,
        extraData: response.data,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  Future<void> searchChatName(String chatName) async {
    // TODO: Optimize by searching locally first before making a service call.
    if (chatName.isEmpty) {
      return;
    }

    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.searchChat(chatName);
    if (response.isSuccess) {
      state = state.copyWith(
        providerState: ProviderState.data,
        chats: response.data,
        code: null,
      );
    } else {
      state = state.copyWith(
        providerState: ProviderState.error,
        code: response.errorCode,
        error: response.error,
      );
    }
  }

  void setToDefaultState() {
    state = state.copyWith(
      providerState: ProviderState.data,
      code: null,
      error: null,
      extraData: null,
    );
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
  final ChatService _service;
}

StateNotifierProvider<ChatNotifier, ChatState> getChatProvider() =>
    StateNotifierProvider<ChatNotifier, ChatState>(
      (ref) => ChatNotifier(getIt<ChatService>()),
    );
