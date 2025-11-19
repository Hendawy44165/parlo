import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';

class ChatRoomDaySeparator extends StatelessWidget {
  const ChatRoomDaySeparator({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: ColorsManager.lightNavyBlue, borderRadius: BorderRadius.circular(14)),
          child: Text(label, style: TextStyleManager.white12Bold),
        ),
      ),
    );
  }
}
