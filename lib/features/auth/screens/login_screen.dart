import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parlo/core/di.dart';
import 'package:parlo/core/extensions/dimensions.dart';
import 'package:parlo/core/extensions/navigation.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/providers/login_provider.dart';
import 'package:parlo/features/auth/services/auth_service.dart';
import 'package:parlo/features/auth/widgets/custom_input_field.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final provider = getLoginProvider(getIt<AuthService>());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen(provider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is AsyncData<UserCredential?>) {
        if (next.value != null) {
          context.popAndPushNamed(Routes.voices);
        }
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
                      context.height - MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.06,
                    vertical: context.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogoSection(context),
                      SizedBox(height: context.height * 0.04),
                      _buildHeaderSection(),
                      SizedBox(height: context.height * 0.05),
                      _buildInputSection(notifier),
                      SizedBox(height: context.height * 0.07),
                      _buildLoginButton(context, state, notifier),
                      SizedBox(height: context.height * 0.02),
                      _buildSocialLoginSection(context, state, notifier),
                      SizedBox(height: context.height * 0.04),
                      _buildSignUpSection(context),
                      SizedBox(height: context.height * 0.02),
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
                child: CircularProgressIndicator(color: ColorsManager.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.height * 0.03),
      child: Image.asset(
        'assets/logos/smooth_parrot.png',
        height: context.height * 0.12,
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
        const SizedBox(height: 16),
        CustomInputField(
          hint: 'Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: notifier.passwordController,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    AsyncValue state,
    LoginNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (state is AsyncLoading) return;
          await notifier.login();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          minimumSize: Size(double.infinity, context.height * 0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text('Login', style: TextStyleManger.white16Medium),
      ),
    );
  }

  Widget _buildSocialLoginSection(
    BuildContext context,
    AsyncValue state,
    LoginNotifier notifier,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
          child: Row(
            children: [
              const Expanded(
                child: Divider(color: ColorsManager.border, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or sign in with',
                  style: TextStyleManger.dimmed14Medium,
                ),
              ),
              const Expanded(
                child: Divider(color: ColorsManager.border, thickness: 1),
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
    AsyncValue state,
    LoginNotifier notifier,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          if (state is AsyncLoading) return;
          await notifier.signinWithGoogle();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.incomingBox,
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
            Text('Sign in with Google', style: TextStyleManger.white16Regular),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
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
            onPressed: () => context.popAndPushNamed(Routes.signup),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Sign up here', style: TextStyleManger.primary14Bold),
          ),
        ],
      ),
    );
  }
}
