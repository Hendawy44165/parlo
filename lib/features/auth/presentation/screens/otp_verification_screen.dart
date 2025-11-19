import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/routing/routes.dart';
import 'package:parlo/core/themes/color.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/presentation/providers/otp_verification_provider.dart';
import 'package:parlo/features/auth/presentation/providers/auth_state.dart' as m_auth_state;

class OtpVerificationScreen extends ConsumerStatefulWidget {
  OtpVerificationScreen({super.key, required this.email}) : otpProvider = getOtpVerificationProvider(email);

  final String email;
  final StateNotifierProvider<OtpVerificationNotifier, m_auth_state.AuthState> otpProvider;

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.otpProvider);
    final notifier = ref.read(widget.otpProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (state.isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!), duration: const Duration(seconds: 2)));
        notifier.setToDefaultState();
      });
    } else if (state.isData && state.code == Codes.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // TODO: how to know which account to change password to
        Navigator.of(context).popAndPushNamed(Routes.resetPassword);
      });
    } else if (state.isData && state.code == Codes.otpResentSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP code resent successfully'), duration: Duration(seconds: 2)));
        notifier.setToDefaultState();
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        appBar: AppBar(
          backgroundColor: ColorsManager.black,
          leading: Icon(Icons.arrow_back, color: ColorsManager.white, size: 40.0),
          title: Text('Verify OTP', style: TextStyleManager.white32Regular),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.04),

                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to your email',
                  style: TextStyleManager.white16Regular,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.05),
                _buildOtpInputRow(notifier),
                SizedBox(height: height * 0.03),
                _buildResendSection(notifier),
                SizedBox(height: height * 0.05),
                _buildConfirmButton(notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputRow(OtpVerificationNotifier notifier) {
    return TextField(
      controller: notifier.otpController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: TextStyleManager.white16Medium,
      decoration: InputDecoration(
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorsManager.darkGray, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorsManager.primaryPurple, width: 2),
        ),
        filled: true,
        fillColor: ColorsManager.black,
      ),
    );
  }

  Widget _buildResendSection(OtpVerificationNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive the code? ", style: TextStyleManager.dimmed14Regular),
        TextButton(
          onPressed: () async {
            notifier.resendCode();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('Resend Code', style: TextStyleManager.primaryPurple14Bold),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(OtpVerificationNotifier notifier) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => notifier.verifyOtp(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryPurple,
          minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.06),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text('Verify OTP', style: TextStyleManager.white16Medium),
      ),
    );
  }
}
