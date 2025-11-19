import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';

class ChatSearchField extends StatelessWidget {
  const ChatSearchField({super.key, required this.controller, this.hint = 'Search'});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyleManager.white16Regular,
      cursorColor: ColorsManager.primaryPurple,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: ColorsManager.darkNavyBlue,
        filled: true,
        hintStyle: TextStyleManager.dimmed16Regular,
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(Icons.search, color: ColorsManager.lightGray),
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: ColorsManager.primaryPurple),
        ),
      ),
    );
  }
}
