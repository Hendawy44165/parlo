import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/dependency_injection.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/chat/logic/services/chat_room_service.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_state.dart';

class ChatRoomNotifier extends StateNotifier<ChatRoomState> {
  ChatRoomNotifier(this._service) : super(ChatRoomState(providerState: ProviderState.initial));

  final TextEditingController messageController = TextEditingController();

  Future<void> loadUserInfo(String conversationId) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response1 = await _service.getOtherUsername(conversationId);
    final response2 = await _service.getOtherAvatarUrl(conversationId);

    if (response1.isSuccess || response2.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, username: response1.data, avatarUrl: response2.data);
    } else if (response1.isFailure) {
      state = state.copyWith(providerState: ProviderState.error, error: response1.error, code: response1.errorCode);
    } else if (response2.isFailure) {
      state = state.copyWith(providerState: ProviderState.error, error: response2.error, code: response2.errorCode);
    }
  }

  Future<void> loadUnreadMessages(String conversationId) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.getUnreadMessages(conversationId);
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, messages: response.data);
    } else {
      state = state.copyWith(providerState: ProviderState.error, error: response.error, code: response.errorCode);
    }
  }

  Future<void> loadNextMessages(String conversationId) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final response = await _service.getMessages(
      conversationId,
      start: state.messages.length,
      end: state.messages.length + 5,
    );
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, messages: [...state.messages, ...response.data!]);
    } else {
      state = state.copyWith(providerState: ProviderState.error, error: response.error, code: response.errorCode);
    }
  }

  Future<void> sendTextMessage(String conversationId) async {
    if (state.isLoading) return;
    state = state.copyWith(providerState: ProviderState.loading);

    final message = messageController.text.trim();
    if (message.isEmpty) return;
    messageController.clear();

    final response = await _service.sendTextMessage(conversationId, message);
    if (response.isSuccess) {
      state = state.copyWith(providerState: ProviderState.data, messages: [...state.messages, response.data!]);
    } else {
      state = state.copyWith(providerState: ProviderState.error, error: response.error, code: response.errorCode);
    }
  }

  void setToDefaultState() {
    state = state.copyWith(providerState: ProviderState.data, error: null, code: null);
  }

  //! private members
  final ChatRoomService _service;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

StateNotifierProvider<ChatRoomNotifier, ChatRoomState> getChatRoomProvider() =>
    StateNotifierProvider<ChatRoomNotifier, ChatRoomState>((ref) => ChatRoomNotifier(getIt<ChatRoomService>()));
