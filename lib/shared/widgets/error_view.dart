import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_animations.dart';
import 'fuse_glass_card.dart';
import 'premium_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FuseGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 48)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(end: 1.1, duration: AppAnimations.medium),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                PremiumButton(text: 'Retry', onPressed: onRetry!),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: AppAnimations.short);
  }
}

void showErrorSnackbar(
  BuildContext context,
  String message, {
  VoidCallback? onRetry,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(16),
      content: FuseGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: 8),
              PremiumButton(
                text: 'Retry',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onRetry();
                },
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
