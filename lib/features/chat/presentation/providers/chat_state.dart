import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';

class ChatState {
  final ProviderState _providerState;
  final List<ChatEntryEntity> chats;
  final Codes? code;
  final String? error;
  final dynamic extraData;

  const ChatState({required ProviderState providerState, this.code, this.error, this.chats = const [], this.extraData})
    : _providerState = providerState;

  bool get isLoading => _providerState == ProviderState.loading;
  bool get isData => _providerState == ProviderState.data;
  bool get isError => _providerState == ProviderState.error;
  bool get isInitial => _providerState == ProviderState.initial;

  ChatState copyWith({
    ProviderState? providerState,
    Codes? code,
    String? error,
    List<ChatEntryEntity>? chats,
    dynamic extraData,
  }) {
    return ChatState(
      providerState: providerState ?? _providerState,
      code: code ?? this.code,
      error: error ?? this.error,
      chats: chats ?? this.chats,
      extraData: extraData ?? this.extraData,
    );
  }
}
