import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/presentation/providers/chat_state.dart';
import 'package:parlo/features/chat/presentation/providers/chats_provider.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_entry.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_search_field.dart';
import 'package:parlo/features/chat/presentation/widgets/new_chat_dialog.dart';

class ChatsScreen extends ConsumerWidget {
  ChatsScreen({super.key});

  final StateNotifierProvider<ChatNotifier, ChatState> chatProvider =
      getChatProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        floatingActionButton: _buildFloatingActionButton(context),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              ChatSearchField(controller: notifier.searchController),
              const SizedBox(height: 16),
              _buildChatList(context, state),
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
          icon: const Icon(
            Icons.settings,
            color: ColorsManager.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNewChatDialog(context),

      backgroundColor: ColorsManager.primaryPurple,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: ColorsManager.white, size: 32),
    );
  }

  Widget _buildChatList(BuildContext context, ChatState state) {
    if (state.chats.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No chats available.', style: TextStyleManager.white14Bold),
              GestureDetector(
                onTap: () => _showNewChatDialog(context),
                child: Text(
                  'Create a new chat!',
                  style: TextStyleManager.primaryPurple14Bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: state.chats.length,
        itemBuilder: (context, index) {
          final chat = state.chats[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.chatRoom,
                arguments: {'conversationId': chat.conversationId},
              );
            },
            child: ChatEntry(
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

  void _showNewChatDialog(BuildContext context) async {
    final emailController = TextEditingController();

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final String? newChatUserEmail = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return NewChatDialog(emailController: emailController);
      },
    );

    // TODO: use riverpod
    // After the dialog is dismissed, check if we got an email address back.
    if (newChatUserEmail != null && newChatUserEmail.isNotEmpty) {
      // TODO: Implement the logic to create a new chat
      // For example, you might call a method from your state notifier:
      // ref.read(chatProvider.notifier).createNewChat(newChatUserEmail);

      print('Starting new chat with: $newChatUserEmail');
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Starting chat with $newChatUserEmail'),
          backgroundColor: ColorsManager.lightNavyBlue,
        ),
      );
    }
  }
}
