import 'package:flutter/material.dart';
import 'package:fuse/core/theme/app_colors.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Phone Input Screen\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
        ),
      ),
    );
  }
}
