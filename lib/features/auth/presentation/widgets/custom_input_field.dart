import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
  });
  final String hint;
  final String prefixIcon;
  final TextEditingController controller;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyleManger.white16Regular,
      cursorColor: ColorsManager.primary,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: ColorsManager.incomingBox,
        filled: true,
        hintStyle: TextStyleManger.dimmed16Regular,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            prefixIcon,
            colorFilter: const ColorFilter.mode(
              ColorsManager.dimmedText,
              BlendMode.srcIn,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: ColorsManager.incomingBox),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: ColorsManager.primary),
        ),
      ),
    );
  }
}
