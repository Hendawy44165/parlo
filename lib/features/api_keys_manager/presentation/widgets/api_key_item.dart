import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';

class ApiKeyItem extends StatelessWidget {
  const ApiKeyItem({
    super.key,
    required this.keyName,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onDelete,
  });

  final String keyName;
  final bool isSelected;
  final VoidCallback onSelectionChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Radio button
          GestureDetector(
            onTap: onSelectionChanged,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? ColorsManager.primaryPurple
                          : ColorsManager.white,
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsManager.primaryPurple,
                          ),
                        ),
                      )
                      : null,
            ),
          ),
          const SizedBox(width: 16),
          // Key name
          Expanded(
            child: Text(keyName, style: TextStyleManager.white16Regular),
          ),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
