import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/provider_state_enum.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';
import 'package:parlo/features/chat/presentation/providers/chat_state.dart';
import 'package:parlo/features/chat/presentation/providers/chats_provider.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_entry.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_search_field.dart';
import 'package:parlo/features/chat/presentation/widgets/chats_animated_list.dart';
import 'package:parlo/features/chat/presentation/widgets/new_chat_dialog.dart';

class ChatsScreen extends ConsumerWidget {
  ChatsScreen({super.key});

  final StateNotifierProvider<ChatNotifier, ChatState> chatProvider = getChatProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider.select((state) => state.chats));
    final providerState = ref.watch(chatProvider.select((state) => state.providerState));
    final animatingIndex = ref.watch(chatProvider.select((state) => state.animatingIndex));
    final code = ref.watch(chatProvider.select((state) => state.code));
    final extraData = ref.watch(chatProvider.select((state) => state.extraData));
    final error = ref.watch(chatProvider.select((state) => state.error));
    //! careful of updaing the chatsMap here because it will get triggered everywhere for no reason
    final chatsMap = ref.watch(chatProvider.select((state) => state.chatsMap));

    final notifier = ref.read(chatProvider.notifier);

    if (providerState == ProviderState.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.getChats();
      });
      return const Center(child: CircularProgressIndicator(color: ColorsManager.primaryPurple));
    } else if (providerState == ProviderState.loading) {
      return const Center(child: CircularProgressIndicator(color: ColorsManager.primaryPurple));
    }

    if (code == Codes.chatCreated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(Routes.chatRoom, arguments: {'conversationId': extraData as String});
      });
    }

    if (providerState == ProviderState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(backgroundColor: ColorsManager.red, content: Text(error ?? 'An error occurred')));
        notifier.setToDefaultState();
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        floatingActionButton: _buildFloatingActionButton(context, notifier),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              ChatSearchField(controller: notifier.searchController),
              const SizedBox(height: 16),
              _buildChatList(context, chats, providerState, animatingIndex, notifier, chatsMap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Parlo', style: TextStyleManager.white32Regular),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.settings);
          },
          icon: const Icon(Icons.settings, color: ColorsManager.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ChatNotifier notifier) {
    return FloatingActionButton(
      onPressed: () => _showNewChatDialog(context, notifier),

      backgroundColor: ColorsManager.primaryPurple,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: ColorsManager.white, size: 32),
    );
  }

  Widget _buildChatList(
    BuildContext context,
    List<ChatEntryEntity> chats,
    ProviderState providerState,
    int? animatingIndex,
    ChatNotifier notifier,
    Map<String, ChatEntryEntity> chatsMap,
  ) {
    if (chats.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No chats available.', style: TextStyleManager.white14Bold),
              GestureDetector(
                onTap: () => _showNewChatDialog(context, notifier),
                child: Text('Create a new chat!', style: TextStyleManager.primaryPurple14Bold),
              ),
            ],
          ),
        ),
      );
    }

    if (providerState == ProviderState.animating) {
      // TODO: allow chat animated list to accept only the needed info for clean code
      final state = ChatState(
        providerState: providerState,
        chats: chats,
        animatingIndex: animatingIndex,
        chatsMap: chatsMap,
      );
      return Expanded(child: ChatsAnimatedList(provider: chatProvider, state: state, notifier: notifier));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.chatRoom, arguments: {'conversationId': chat.conversationId});
            },
            child: ChatEntry(
              provider: chatProvider,
              conversationId: chat.conversationId,
              username: chat.username,
              lastMessage: chat.lastMessage,
              time: chat.lastMessageTimestamp,
              profileImageUrl: chat.profilePictureUrl,
              unreadCount: chat.unreadCount,
              status: chat.status,
              isAudio: chat.isAudio,
            ),
          );
        },
      ),
    );
  }

  void _showNewChatDialog(BuildContext context, ChatNotifier notifier) async {
    final emailController = TextEditingController();

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final String? newChatUserEmail = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return NewChatDialog(emailController: emailController);
      },
    );

    if (newChatUserEmail != null && newChatUserEmail.isNotEmpty) {
      notifier.createChat(newChatUserEmail);
    }
  }
}
