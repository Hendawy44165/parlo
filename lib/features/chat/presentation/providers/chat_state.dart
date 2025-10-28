import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';

class ChatState {
  final ProviderState _providerState;
  final List<ChatEntryEntity> chats;
  final Codes? code;
  final String? error;

  const ChatState({
    required ProviderState providerState,
    this.code,
    this.error,
    this.chats = const [],
  }) : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isData => _providerState == ProviderState.data;
  bool get isError => _providerState == ProviderState.error;

  ChatState copyWith({
    ProviderState? providerState,
    Codes? code,
    String? error,
    List<ChatEntryEntity>? chats,
  }) {
    return ChatState(
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
      chats: chats ?? this.chats,
    );
  }
}
