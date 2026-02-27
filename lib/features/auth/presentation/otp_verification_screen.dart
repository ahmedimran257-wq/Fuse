import 'package:flutter/material.dart';
import 'package:fuse/core/theme/app_colors.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'OTP Verification Screen\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
        ),
      ),
    );
  }
}
