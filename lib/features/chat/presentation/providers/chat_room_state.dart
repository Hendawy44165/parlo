import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/online_status_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/core/enums/typing_status_enum.dart';
import 'package:parlo/features/chat/logic/entities/message_entity.dart';

class ChatRoomState {
  ChatRoomState({
    required ProviderState providerState,
    this.code,
    this.error,
    this.username,
    this.avatarUrl,
    this.onlineStatus = OnlineStatus.offline,
    this.messages = const [],
    this.typingStatus = TypingStatus.none,
  }) : _providerState = providerState;

  final ProviderState _providerState;
  final Codes? code;
  final String? error;
  final String? username;
  final String? avatarUrl;
  final OnlineStatus onlineStatus;
  final List<MessageEntity> messages;
  final TypingStatus typingStatus;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isError => _providerState == ProviderState.error;
  bool get isData => _providerState == ProviderState.data;
  bool get isInitial => _providerState == ProviderState.initial;

  ChatRoomState copyWith({
    ProviderState? providerState,
    Codes? code,
    String? error,
    String? username,
    String? avatarUrl,
    OnlineStatus? onlineStatus,
    List<MessageEntity>? messages,
    TypingStatus? typingStatus,
  }) {
    return ChatRoomState(
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      messages: messages ?? this.messages,
      typingStatus: typingStatus ?? this.typingStatus,
    );
  }
}
