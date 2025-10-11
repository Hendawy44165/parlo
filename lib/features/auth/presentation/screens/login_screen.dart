import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart'
    as m_auth_state;
import 'package:parlo/features/auth/presentation/providers/login_provider.dart';
import 'package:parlo/features/auth/presentation/widgets/custom_input_field.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final provider = getLoginProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    if (state.isData && state.code == 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      });
    } else if (state.isData && state.code == 201) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(
          Routes.otpVerification,
          arguments: {'email': notifier.emailController.text.trim()},
        );
        notifier.setToDataState();
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
        notifier.setToDataState();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                _buildHeaderSection(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                _buildInputSection(notifier),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                _buildLoginButton(context, state, notifier),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildSocialLoginSection(context, state, notifier),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                _buildSignUpSection(context, state),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Text('Login', style: TextStyleManger.white32Regular),
        const SizedBox(height: 8),
        Text(
          'Sign in to connect and share your voice!',
          style: TextStyleManger.white16Regular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputSection(LoginNotifier notifier) {
    return Column(
      children: [
        CustomInputField(
          hint: 'Email',
          prefixIcon: 'assets/icons/mail.svg',
          controller: notifier.emailController,
        ),
        notifier.emailErrorMessage != null
            ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  notifier.emailErrorMessage!,
                  style: TextStyleManger.error12Regular,
                ),
              ),
            )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        CustomInputField(
          hint: 'Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: notifier.passwordController,
          isPassword: true,
        ),
        notifier.passwordErrorMessage != null
            ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  notifier.passwordErrorMessage!,
                  style: TextStyleManger.error12Regular,
                ),
              ),
            )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => notifier.resetPassword(),
              child: Text(
                "Forgot Password?",
                style: TextStyleManger.dimmed14Medium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    m_auth_state.AuthState state,
    LoginNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => notifier.login(),
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
                : Text('Login', style: TextStyleManger.white16Medium),
      ),
    );
  }

  Widget _buildSocialLoginSection(
    BuildContext context,
    m_auth_state.AuthState state,
    LoginNotifier notifier,
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
                  'or sign in with',
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
    LoginNotifier notifier,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () => notifier.signInWithGoogle(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.darkNavyBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:
            state.isLoading
                ? CircularProgressIndicator(color: ColorsManager.primaryPurple)
                : Row(
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
                    Text(
                      'Sign in with Google',
                      style: TextStyleManger.white16Regular,
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildSignUpSection(
    BuildContext context,
    m_auth_state.AuthState state,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an Account? ',
            style: TextStyleManger.dimmed14Regular,
          ),
          TextButton(
            onPressed: () {
              if (state.isLoading) return;
              Navigator.of(context).popAndPushNamed(Routes.signup);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign up here',
              style: TextStyleManger.primaryPurple14Bold,
            ),
          ),
        ],
      ),
    );
  }
}
