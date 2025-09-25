import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/widgets/custom_input_field.dart';

class AddApiKeyDialog extends StatefulWidget {
  const AddApiKeyDialog({super.key});

  @override
  State<AddApiKeyDialog> createState() => _AddApiKeyDialogState();
}

class _AddApiKeyDialogState extends State<AddApiKeyDialog> {
  final TextEditingController keyNameController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();

  @override
  void dispose() {
    keyNameController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsManager.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add API Key',
                    style: TextStyleManger.white16Medium,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: ColorsManager.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Key Name Input
            CustomInputField(
              hint: 'Key Name',
              prefixIcon: 'assets/icons/user.svg',
              controller: keyNameController,
            ),
            const SizedBox(height: 16),
            // API Key Input
            CustomInputField(
              hint: 'API Key',
              prefixIcon: 'assets/icons/lock.svg',
              controller: apiKeyController,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.incomingBox,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyleManger.white16Regular,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final keyName = keyNameController.text.trim();
                      final apiKey = apiKeyController.text.trim();
                      
                      if (keyName.isNotEmpty && apiKey.isNotEmpty) {
                        Navigator.of(context).pop({
                          'name': keyName,
                          'key': apiKey,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyleManger.white16Medium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}