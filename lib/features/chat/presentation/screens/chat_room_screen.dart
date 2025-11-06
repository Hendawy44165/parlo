import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/enums/online_status_enum.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_state.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_room_input_bar.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_room_messages_list.dart';

class ChatRoomScreen extends ConsumerWidget {
  ChatRoomScreen({super.key, required this.conversationId});

  final String conversationId;

  final StateNotifierProvider<ChatRoomNotifier, ChatRoomState>
  chatRoomProvider = getChatRoomProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatRoomProvider);
    final notifier = ref.read(chatRoomProvider.notifier);

    // TODO: fix frame lag when opening a new chat room
    if (state.isInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await notifier.loadUserInfo(conversationId);
        await notifier.loadUnreadMessages(conversationId);
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _buildHeader(context, state),
            ),
            Expanded(
              child:
                  state.isLoading && state.messages.isEmpty
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.primaryPurple,
                        ),
                      )
                      : _buildMessages(state, notifier),
            ),
            _buildInputBar(notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ChatRoomState state) {
    final name = state.username;
    final isOnline = state.onlineStatus == OnlineStatus.online;
    final avatarUrl = state.avatarUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorsManager.white,
                size: 20,
              ),
            ),
            CircleAvatar(
              radius: 22,
              backgroundColor: ColorsManager.lightNavyBlue,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child:
                  avatarUrl == null
                      ? const Icon(Icons.person, color: ColorsManager.white)
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Loading Username...',
                    style: TextStyleManager.white16Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyleManager.dimmed12Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }

  Widget _buildMessages(ChatRoomState state, ChatRoomNotifier notifier) {
    return MessageEntitiesList(
      state: state,
      notifier: notifier,
      conversationId: conversationId,
    );
  }

  Widget _buildInputBar(ChatRoomNotifier notifier) {
    return ChatRoomInputBar(notifier: notifier, conversationId: conversationId);
  }
}
