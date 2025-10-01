import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;
import 'package:parlo/features/auth/presentation/providers/signup_provider.dart';
import 'package:parlo/features/auth/presentation/widgets/custom_input_field.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final provider = getSignupProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    if (state.isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            duration: const Duration(seconds: 2),
          ),
        );
        notifier.setToDataState();
      });
    }

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
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      _buildHeaderSection(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      _buildInputSection(notifier),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      _buildSignupButton(context, state, notifier),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildSocialLoginSection(context, state, notifier),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      _buildLoginSection(context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (state.isLoading)
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

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Text('Sign Up', style: TextStyleManger.white32Regular),
        const SizedBox(height: 8),
        Text(
          'Create an account to get started!',
          style: TextStyleManger.white16Regular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputSection(SignupNotifier notifier) {
    return Column(
      children: [
        CustomInputField(
          hint: 'Username',
          prefixIcon: 'assets/icons/user.svg',
          controller: notifier.usernameController,
        ),
        const SizedBox(height: 12),
        CustomInputField(
          hint: 'Email',
          prefixIcon: 'assets/icons/mail.svg',
          controller: notifier.emailController,
        ),
        const SizedBox(height: 12),
        CustomInputField(
          hint: 'Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: notifier.passwordController,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildSignupButton(
    BuildContext context,
    m_auth_state.AuthState state,
    SignupNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (state.isLoading) return;
          // TODO: implement signup
          // await notifier.signup();
        },
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
        child: Text('Sign Up', style: TextStyleManger.white16Medium),
      ),
    );
  }

  Widget _buildSocialLoginSection(
    BuildContext context,
    m_auth_state.AuthState state,
    SignupNotifier notifier,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            children: [
              const Expanded(
                child: Divider(color: ColorsManager.darkGray, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or sign up with',
                  style: TextStyleManger.dimmed14Medium,
                ),
              ),
              const Expanded(
                child: Divider(color: ColorsManager.darkGray, thickness: 1),
              ),
            ],
          ),
        ),
        _buildSocialButton(context, state, notifier),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    m_auth_state.AuthState state,
    SignupNotifier notifier,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          if (state.isLoading) return;
          // TODO: Implement Google Sign-In
          // await notifier.signinWithGoogle();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.darkNavyBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: SvgPicture.asset(
                'assets/icons/google.svg',
                width: 20,
                height: 20,
              ),
            ),
            Text('Sign up with Google', style: TextStyleManger.white16Regular),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an Account? ',
            style: TextStyleManger.dimmed14Regular,
          ),
          TextButton(
            onPressed:
                () => Navigator.of(context).popAndPushNamed(Routes.login),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Login here',
              style: TextStyleManger.primaryPurple14Bold,
            ),
          ),
        ],
      ),
    );
  }
}
