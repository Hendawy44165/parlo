import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart';
import 'package:parlo/features/auth/presentation/providers/update_password_provider.dart';
import 'package:parlo/features/auth/presentation/widgets/custom_input_field.dart';

class UpdatePasswordScreen extends ConsumerWidget {
  UpdatePasswordScreen({super.key});

  final provider = getUpdatePasswordProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    if (state.isData && state.code == Codes.passwordUpdatedSuccessfully) {
      notifier.signOut();
    } else if (state.isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            duration: const Duration(seconds: 2),
          ),
        );
        notifier.setToDefaultState();
      });
    }

    if (state.isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            duration: const Duration(seconds: 2),
          ),
        );
        notifier.setToDefaultState();
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildHeaderSection(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                _buildInputSection(notifier),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                _buildUpdateButton(context, state, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: ColorsManager.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Text('Update Password', style: TextStyleManager.white32Regular),
      ],
    );
  }

  Widget _buildInputSection(UpdatePasswordNotifier notifier) {
    return Column(
      children: [
        CustomInputField(
          hint: 'New Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: notifier.newPasswordController,
          isPassword: true,
        ),
        notifier.newPasswordErrorMessage != null
            ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  notifier.newPasswordErrorMessage!,
                  style: TextStyleManager.error12Regular,
                ),
              ),
            )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        CustomInputField(
          hint: 'Confirm Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: notifier.confirmPasswordController,
          isPassword: true,
        ),
        notifier.confirmPasswordErrorMessage != null
            ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  notifier.confirmPasswordErrorMessage!,
                  style: TextStyleManager.error12Regular,
                ),
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildUpdateButton(
    BuildContext context,
    AuthState state,
    UpdatePasswordNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => notifier.updatePassword(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryPurple,
          minimumSize: Size(
            double.infinity,
            MediaQuery.of(context).size.height * 0.06,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:
            state.isLoading
                ? CircularProgressIndicator(color: ColorsManager.white)
                : Text(
                  'Update Password',
                  style: TextStyleManager.white16Medium,
                ),
      ),
    );
  }
}
