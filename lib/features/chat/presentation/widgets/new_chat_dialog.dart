import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/widgets/custom_input_field.dart';

class NewChatDialog extends StatelessWidget {
  const NewChatDialog({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.darkNavyBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Start a New Chat', style: TextStyleManager.white16Medium),
      content: CustomInputField(
        hint: "Enter user's email",
        prefixIcon: 'assets/icons/mail.svg', // Assuming you have this icon
        controller: emailController,
      ),
      actions: [_buildCancelButton(context), _buildCreateButton(context)],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Dismiss the dialog without returning any data
        Navigator.of(context).pop();
      },
      child: Text('Cancel', style: TextStyleManager.dimmed14Medium),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Dismiss the dialog and return the email address
        if (emailController.text.isNotEmpty) {
          Navigator.of(context).pop(emailController.text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primaryPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Text('Create Chat', style: TextStyleManager.white16Regular),
    );
  }
}
