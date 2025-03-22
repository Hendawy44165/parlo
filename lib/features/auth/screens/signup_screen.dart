import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parlo/core/extensions/dimensions.dart';
import 'package:parlo/core/extensions/navigation.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/widgets/custom_input_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.height - MediaQuery.of(context).padding.top,
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
                  SizedBox(height: context.height * 0.01),
                  _buildHeaderSection(),
                  SizedBox(height: context.height * 0.03),
                  _buildInputSection(),
                  SizedBox(height: context.height * 0.07),
                  _buildSignupButton(context),
                  SizedBox(height: context.height * 0.02),
                  _buildSocialLoginSection(context),
                  SizedBox(height: context.height * 0.04),
                  _buildLoginSection(context),
                  SizedBox(height: context.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.height * 0.03),
      child: Image.asset(
        'assets/logos/parrot.png',
        height: context.height * 0.12,
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

  Widget _buildInputSection() {
    return Column(
      children: [
        CustomInputField(
          hint: 'Username',
          prefixIcon: 'assets/icons/user.svg',
          controller: TextEditingController(),
        ),
        const SizedBox(height: 12),
        CustomInputField(
          hint: 'Email',
          prefixIcon: 'assets/icons/mail.svg',
          controller: TextEditingController(),
        ),
        const SizedBox(height: 12),
        CustomInputField(
          hint: 'Password',
          prefixIcon: 'assets/icons/lock.svg',
          controller: TextEditingController(),
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          minimumSize: Size(double.infinity, context.height * 0.06),
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

  Widget _buildSocialLoginSection(BuildContext context) {
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
                  'or sign up with',
                  style: TextStyleManger.dimmed14Medium,
                ),
              ),
              const Expanded(
                child: Divider(color: ColorsManager.border, thickness: 1),
              ),
            ],
          ),
        ),
        _buildSocialButton(context),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {},
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
            Text('Sign up with Google', style: TextStyleManger.white16Regular),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an Account? ',
            style: TextStyleManger.dimmed14Regular,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: GestureDetector(
              onTap: () => context.popAndPushNamed(Routes.login),
              child: Text('Login here', style: TextStyleManger.primary14Bold),
            ),
          ),
        ],
      ),
    );
  }
}
