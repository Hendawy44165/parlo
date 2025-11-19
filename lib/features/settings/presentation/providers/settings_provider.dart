import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/features/settings/logic/services/profile_service.dart';

class SettingsNotifier extends StateNotifier<AsyncValue> {
  SettingsNotifier({required ProfileService service}) : _service = service, super(const AsyncData(null));

  final TextEditingController usernameController = TextEditingController();
  final ProfileService _service;

  String? selectedCharacter;
  String? selectedStability = 'Neutral'; // Default stability value

  void updateSelectedCharacter(String? character) {
    if (state.isLoading) return;
    selectedCharacter = character;
    // Trigger a state update to notify listeners
    state = AsyncData(state.value);
  }

  void updateSelectedStability(String? stability) {
    if (state.isLoading) return;
    selectedStability = stability;
    // Trigger a state update to notify listeners
    state = AsyncData(state.value);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}

StateNotifierProvider<SettingsNotifier, AsyncValue> getSettingsProvider(ProfileService service) =>
    StateNotifierProvider<SettingsNotifier, AsyncValue>((ref) => SettingsNotifier(service: service));
