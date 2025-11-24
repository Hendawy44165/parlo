import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/features/chat/logic/entities/chat_entry_entity.dart';
import 'package:parlo/features/chat/presentation/providers/chat_state.dart';
import 'package:parlo/features/chat/presentation/providers/chats_provider.dart';
import 'package:parlo/features/chat/presentation/widgets/chat_entry.dart';

class ChatsAnimatedList extends StatefulWidget {
  const ChatsAnimatedList({super.key, required this.state, required this.notifier, required this.provider});

  final ChatState state;
  final ChatNotifier notifier;
  final StateNotifierProvider<ChatNotifier, ChatState> provider;

  @override
  State<ChatsAnimatedList> createState() => _ChatsAnimatedListState();
}

class _ChatsAnimatedListState extends State<ChatsAnimatedList> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<ChatEntryEntity> _displayList;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    // Add listener to detect when animation is complete
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.notifier.animationFinished();
      }
    });

    // Reconstruct the "old" list state before the move
    // widget.state.chats is already in the NEW state (moved item at index 0)
    // We need to show the OLD state initially
    _displayList = List.from(widget.state.chats);
    final movedItem = _displayList.removeAt(0);

    // Insert it back at the old position
    if (widget.state.animatingIndex != null) {
      _displayList.insert(widget.state.animatingIndex!, movedItem);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animate();
    });
  }

  void _animate() async {
    if (widget.state.animatingIndex == null) return;

    final oldIndex = widget.state.animatingIndex!;
    final movedItem = widget.state.chats[0];

    // Remove from old position
    _listKey.currentState?.removeItem(
      oldIndex,
      (context, animation) => SizeTransition(sizeFactor: animation, child: _buildItem(movedItem)),
      duration: const Duration(milliseconds: 300),
    );

    // Update display list to remove from old position
    _displayList.removeAt(oldIndex);

    // Insert at top
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
    _displayList.insert(0, movedItem);

    // Start the animation controller
    _animationController.forward();
  }

  Widget _buildItem(ChatEntryEntity chat) {
    return ChatEntry(
      provider: widget.provider,
      conversationId: chat.conversationId,
      username: chat.username,
      lastMessage: chat.lastMessage,
      time: chat.lastMessageTimestamp,
      profileImageUrl: chat.profilePictureUrl,
      unreadCount: chat.unreadCount,
      status: chat.status,
      isAudio: chat.isAudio,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _displayList.length,
      itemBuilder: (context, index, animation) {
        if (index < _displayList.length) {
          return SizeTransition(sizeFactor: animation, child: _buildItem(_displayList[index]));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
