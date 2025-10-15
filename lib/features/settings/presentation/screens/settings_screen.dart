import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/settings/logic/services/profile_service.dart';
import 'package:parlo/features/settings/presentation/providers/settings_provider.dart';

// Filler constants
const String kDefaultUsername = 'john_doe';
const String kDefaultEmail = 'john.doe@example.com';
const String kCharacterJessica = 'Jessica';
const String kCharacterMike = 'Mike';
const String? kDefaultSelectedCharacter = null;
const String kStabilityCreative = 'Creative';
const String kStabilityNeutral = 'Neutral';
const String kStabilityRobust = 'Robust';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  final provider = getSettingsProvider(ProfileService());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    // Initialize controllers with default values
    if (notifier.usernameController.text.isEmpty) {
      notifier.usernameController.text = kDefaultUsername;
    }

    ref.listen(provider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is AsyncData && next.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.value.toString()),
            backgroundColor: ColorsManager.primaryPurple,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                  ),
                  //! UI hierarchy
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      _buildHeaderSection(context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      _buildProfileSection(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      _buildInputSection(notifier),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      _buildCharacterSelectionSection(notifier, ref),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      _buildStabilitySelectionSection(notifier, ref),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      //! temp logout button
                      ElevatedButton(
                        onPressed: () async {
                          AuthService().signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyleManager.white16Medium,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (state is AsyncLoading)
            Container(
              color: ColorsManager.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: ColorsManager.white,
            size: 24,
          ),
        ),
        Expanded(
          child: Text(
            'Settings',
            style: TextStyleManager.white16Medium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(SettingsNotifier notifier) {
    return Column(
      children: [
        _buildReadOnlyField(kDefaultUsername),
        const SizedBox(height: 16),
        _buildReadOnlyField(kDefaultEmail),
      ],
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: ColorsManager.darkNavyBlue,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: ColorsManager.darkNavyBlue),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.mail_outline,
              color: ColorsManager.lightGray,
              size: 20,
            ),
          ),
          Text(text, style: TextStyleManager.dimmed16Regular),
        ],
      ),
    );
  }

  Widget _buildCharacterSelectionSection(
    SettingsNotifier notifier,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Select Character',
            style: TextStyleManager.white16Medium,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: ColorsManager.darkNavyBlue,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: ColorsManager.darkNavyBlue),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: notifier.selectedCharacter,
              hint: Text(
                'Choose a character',
                style: TextStyleManager.dimmed16Regular,
              ),
              dropdownColor: ColorsManager.darkNavyBlue,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: ColorsManager.lightGray,
              ),
              items:
                  [kCharacterJessica, kCharacterMike].map((String character) {
                    return DropdownMenuItem<String>(
                      value: character,
                      child: Text(
                        character,
                        style: TextStyleManager.white16Regular,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                notifier.updateSelectedCharacter(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStabilitySelectionSection(
    SettingsNotifier notifier,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Voice Stability', style: TextStyleManager.white16Medium),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: ColorsManager.darkNavyBlue,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: ColorsManager.darkNavyBlue),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: notifier.selectedStability,
              hint: Text(
                'Choose stability level',
                style: TextStyleManager.dimmed16Regular,
              ),
              dropdownColor: ColorsManager.darkNavyBlue,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: ColorsManager.lightGray,
              ),
              items:
                  [kStabilityCreative, kStabilityNeutral, kStabilityRobust].map(
                    (String stability) {
                      return DropdownMenuItem<String>(
                        value: stability,
                        child: Text(
                          stability,
                          style: TextStyleManager.white16Regular,
                        ),
                      );
                    },
                  ).toList(),
              onChanged: (String? newValue) {
                notifier.updateSelectedStability(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
