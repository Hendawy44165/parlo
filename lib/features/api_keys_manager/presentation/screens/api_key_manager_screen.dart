import 'package:flutter/material.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/api_keys_manager/presentation/widgets/api_key_item.dart';
import 'package:parlo/features/api_keys_manager/presentation/widgets/add_api_key_dialog.dart';

class ApiKeyManagerScreen extends StatefulWidget {
  const ApiKeyManagerScreen({super.key});

  @override
  State<ApiKeyManagerScreen> createState() => _ApiKeyManagerScreenState();
}

class _ApiKeyManagerScreenState extends State<ApiKeyManagerScreen> {
  // Mock data for API keys - this will be replaced with actual data management later
  List<Map<String, dynamic>> apiKeys = [
    {
      'id': '1',
      'name': 'Key Name',
      'key': 'sk-1234567890abcdef',
      'isSelected': false,
    },
    {
      'id': '2',
      'name': 'Key Name',
      'key': 'sk-abcdef1234567890',
      'isSelected': true,
    },
    {
      'id': '3',
      'name': 'Key Name',
      'key': 'sk-0987654321fedcba',
      'isSelected': false,
    },
    {
      'id': '4',
      'name': 'Key Name',
      'key': 'sk-fedcba0987654321',
      'isSelected': false,
    },
    {
      'id': '5',
      'name': 'Key Name',
      'key': 'sk-1111222233334444',
      'isSelected': false,
    },
    {
      'id': '6',
      'name': 'Key Name',
      'key': 'sk-4444333322221111',
      'isSelected': false,
    },
  ];

  //TODO: could be optimized by using some indexing mechanism
  void _selectApiKey(String id) {
    setState(() {
      for (var key in apiKeys) {
        key['isSelected'] = key['id'] == id;
      }
    });
  }

  void _deleteApiKey(String id) {
    setState(() {
      apiKeys.removeWhere((key) => key['id'] == id);
    });
  }

  void _deselectAll() {
    setState(() {
      for (var key in apiKeys) {
        key['isSelected'] = false;
      }
    });
  }

  void _addApiKey() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddApiKeyDialog(),
    );

    if (result != null) {
      setState(() {
        apiKeys.add({
          // TODO: id shouldn't be the "created_at" value
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': result['name']!,
          'key': result['key']!,
          'isSelected': false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(context),
            Expanded(child: _buildApiKeysList()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back,
              color: ColorsManager.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Manage API Keys',
              style: TextStyleManger.white16Medium,
            ),
          ),
          // Deselect all button (only show if there are selected keys)
          if (apiKeys.any((key) => key['isSelected'] == true))
            GestureDetector(
              onTap: _deselectAll,
              child: Text(
                'Deselect All',
                style: TextStyleManger.primary14Regular,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApiKeysList() {
    if (apiKeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.key_off, size: 64, color: ColorsManager.dimmedText),
            const SizedBox(height: 16),
            Text('No API Keys', style: TextStyleManger.dimmed16Regular),
            const SizedBox(height: 8),
            Text(
              'Add your first API key to get started',
              style: TextStyleManger.dimmed14Regular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      itemCount: apiKeys.length,
      itemBuilder: (context, index) {
        final apiKey = apiKeys[index];
        return ApiKeyItem(
          keyName: apiKey['name'],
          isSelected: apiKey['isSelected'],
          onSelectionChanged: () => _selectApiKey(apiKey['id']),
          onDelete: () => _deleteApiKey(apiKey['id']),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: FloatingActionButton(
        onPressed: _addApiKey,
        backgroundColor: ColorsManager.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: ColorsManager.white, size: 24),
      ),
    );
  }
}
