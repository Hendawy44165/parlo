import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';

class ChatState {
  final ProviderState providerState;
  final List<ChatEntryEntity> chats;
  final Codes? code;
  final String? error;
  final dynamic extraData;
  final int? animatingIndex;
  final Map<String, ChatEntryEntity> chatsMap;

  ChatState({
    required this.providerState,
    this.code,
    this.error,
    this.chats = const [],
    this.extraData,
    this.animatingIndex,
    required this.chatsMap,
  });

  bool get isLoading => providerState == ProviderState.loading;
  bool get isData => providerState == ProviderState.data;
  bool get isError => providerState == ProviderState.error;
  bool get isInitial => providerState == ProviderState.initial;

  ChatState copyWith({
    ProviderState? providerState,
    Codes? code,
    String? error,
    List<ChatEntryEntity>? chats,
    dynamic extraData,
    int? animatingIndex,
  }) {
    return ChatState(
      providerState: providerState ?? this.providerState,
      code: code ?? this.code,
      error: error ?? this.error,
      chats: chats ?? this.chats,
      extraData: extraData ?? this.extraData,
      animatingIndex: animatingIndex ?? this.animatingIndex,
      //! do NOT update the chatsMap here because it's watched without needing to be in the chats screen just to get access to it
      chatsMap: chatsMap,
    );
  }
}
