import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/enums/message_status_enum.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_entry.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_search_field.dart';
import 'package:parlo/features/chat/presentation/widgets/new_chat_dialog.dart';

class _ChatData {
  final String uid;
  final String name;
  final String lastMessage;
  final String time;
  final String? profileImageUrl;
  final MessageStatus? status;
  final int unreadCount;
  final bool isAudio;

  _ChatData({
    required this.uid,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.profileImageUrl,
    this.status,
    this.unreadCount = 0,
    this.isAudio = false,
  });
}

class ChatsScreen extends ConsumerWidget {
  ChatsScreen({super.key});

  final _searchController = TextEditingController();

  final _chats = [
    _ChatData(
      uid: '1',
      name: 'Jossef Ahmed',
      lastMessage: 'How are you doing today Bro',
      time: '18:12',
      unreadCount: 4,
    ),
    _ChatData(
      uid: '2',
      name: 'Jossef Ahmed',
      lastMessage: 'Some Message',
      time: '18:12',
      unreadCount: 10000,
    ),
    _ChatData(
      uid: '3',
      name: 'Jossef Ahmed',
      lastMessage: '14:38',
      time: '18:12',
      isAudio: true,
      status: MessageStatus.sent,
    ),
    _ChatData(
      uid: '4',
      name: 'Jossef Ahmed',
      lastMessage: 'Some Message',
      time: '18:12',
      status: MessageStatus.read,
    ),
    _ChatData(
      uid: '5',
      name: 'Jossef Ahmed',
      lastMessage: 'Some Message',
      time: '18:12',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ChatSearchField(controller: _searchController),
              const SizedBox(height: 16),
              _buildChatList(context),
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

  Widget _buildChatList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.chatRoom,
                arguments: {'conversationId': chat.uid},
              );
            },
            child: ChatEntry(
              username: chat.name,
              lastMessage: chat.lastMessage,
              time: chat.time,
              profileImageUrl: chat.profileImageUrl,
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
