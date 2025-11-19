import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/chat/presentation/providers/chat_room_provider.dart';

class ChatRoomInputBar extends StatefulWidget {
  const ChatRoomInputBar({super.key, required this.notifier, required this.conversationId});

  final ChatRoomNotifier notifier;
  final String conversationId;

  @override
  State<ChatRoomInputBar> createState() => _ChatRoomInputBarState();
}

class _ChatRoomInputBarState extends State<ChatRoomInputBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sendScaleAnimation;
  late final Animation<double> _sendFadeAnimation;
  late final Animation<double> _floatingScaleAnimation;
  late final Animation<double> _floatingFadeAnimation;
  late final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorsManager.darkNavyBlue),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: ColorsManager.lightNavyBlue,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: TextField(
                        controller: widget.notifier.messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message',
                          hintStyle: TextStyleManager.dimmed14Regular,
                          border: InputBorder.none,
                        ),
                        style: TextStyleManager.white16Regular,
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildTrailingButton(),
                ],
              ),
            ),
            Positioned(
              right: 4,
              bottom: 68,
              child: IgnorePointer(
                ignoring: widget.notifier.messageController.text.isEmpty,
                child: FadeTransition(
                  opacity: _floatingFadeAnimation,
                  child: ScaleTransition(
                    scale: _floatingScaleAnimation,
                    child:
                        widget.notifier.messageController.text.isNotEmpty
                            ? _FloatingAudioHintButton()
                            : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _messageController = widget.notifier.messageController;
    _messageController.addListener(_handleMessageControllerChange);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _sendScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _sendFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _floatingScaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _floatingFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _syncControllerWithText();
  }

  @override
  void didUpdateWidget(ChatRoomInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.notifier.messageController.text.isNotEmpty && !_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    } else if (widget.notifier.messageController.text.isEmpty && _controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleMessageControllerChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleMessageControllerChange() {
    if (!mounted) {
      return;
    }
    final hasText = _messageController.text.isNotEmpty;
    if (hasText) {
      if (_controller.status != AnimationStatus.forward && _controller.status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (_controller.status != AnimationStatus.reverse && _controller.status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    setState(() {});
  }

  void _syncControllerWithText() {
    final hasText = _messageController.text.isNotEmpty;
    _controller.value = hasText ? 1 : 0;
  }

  Widget _buildTrailingButton() {
    if (widget.notifier.messageController.text.isEmpty) {
      return _buildMicButton();
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: ScaleTransition(
        scale: _sendScaleAnimation,
        child: FadeTransition(opacity: _sendFadeAnimation, child: _buildSendButton(widget.notifier)),
      ),
    );
  }

  Widget _buildSendButton(ChatRoomNotifier notifier) {
    return IconButton(
      onPressed: () {
        notifier.sendTextMessage(widget.conversationId);
      },
      icon: Icon(Icons.send, color: ColorsManager.white, size: 28),
    );
  }

  Widget _buildMicButton() {
    return IconButton(
      onPressed: () {
        // TODO: record the message
      },
      icon: Icon(Icons.mic, color: ColorsManager.white, size: 28),
    );
  }
}

class _FloatingAudioHintButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(color: ColorsManager.lightNavyBlue, shape: BoxShape.circle),
      child: const Icon(Icons.multitrack_audio, color: ColorsManager.white, size: 28),
    );
  }
}
