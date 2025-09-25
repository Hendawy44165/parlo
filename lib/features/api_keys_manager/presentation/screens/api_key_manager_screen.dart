import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/api_keys_manager/presentation/providers/api_keys_manager_provider.dart';
import 'package:parlo/features/api_keys_manager/presentation/providers/api_keys_manager_state.dart';
import 'package:parlo/features/api_keys_manager/presentation/widgets/api_key_item.dart';
import 'package:parlo/features/api_keys_manager/presentation/widgets/add_api_key_dialog.dart';

class ApiKeyManagerScreen extends ConsumerStatefulWidget {
  const ApiKeyManagerScreen({super.key});

  @override
  ConsumerState<ApiKeyManagerScreen> createState() =>
      _ApiKeyManagerScreenState();
}

class _ApiKeyManagerScreenState extends ConsumerState<ApiKeyManagerScreen> {
  late ApiKeyManagerState state;
  late ApiKeyManagerNotifier notifier;
  late StateNotifierProvider<ApiKeyManagerNotifier, ApiKeyManagerState>
  apiKeyManagerProvider;

  @override
  Widget build(BuildContext context) {
    state = ref.watch(apiKeyManagerProvider);
    notifier = ref.read(apiKeyManagerProvider.notifier);
    if (state.isLoading)
      return Scaffold(
        backgroundColor: ColorsManager.black,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(context),
              Expanded(
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      );
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
          if (state.apiKeys.any((key) => key.isSelected))
            GestureDetector(
              onTap: () => notifier.deselectAll(),
              child: Text(
                'Deselect All',
                style: TextStyleManger.primaryPurple14Regular,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApiKeysList() {
    final apiKeys = state.apiKeys;

    if (apiKeys.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.key_off, size: 64, color: ColorsManager.lightGray),
            const SizedBox(height: 16),
            Text('No API Keys', style: TextStyleManger.dimmed16Regular),
            const SizedBox(height: 8),
            Text(
              'Add your first API key to get started',
              style: TextStyleManger.dimmed14Regular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => _addApiKey(),
              child: Text(
                'Add API Key',
                style: TextStyleManger.primaryPurple14Bold,
              ),
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
          keyName: apiKey.name,
          isSelected: apiKey.isSelected,
          onSelectionChanged: () => notifier.selectApiKey(apiKey.id),
          onDelete: () => notifier.deleteApiKey(apiKey.id),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    if (state.apiKeys.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.all(16),
      child: FloatingActionButton(
        onPressed: _addApiKey,
        backgroundColor: ColorsManager.primaryPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: ColorsManager.white, size: 24),
      ),
    );
  }

  void _addApiKey() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddApiKeyDialog(),
    );

    if (result != null) {
      notifier.addNewApiKey(name: result['name']!, key: result['key']!);
    }
  }

  @override
  void initState() {
    super.initState();
    apiKeyManagerProvider = getApiKeyManagerProvider();
    notifier = ref.read(apiKeyManagerProvider.notifier);
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }
}
