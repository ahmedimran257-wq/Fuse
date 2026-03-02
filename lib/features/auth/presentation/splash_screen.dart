import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'FUSE',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 32,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
