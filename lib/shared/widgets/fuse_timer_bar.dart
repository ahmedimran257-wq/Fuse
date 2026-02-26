import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_animations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/time_formatter.dart';

class FuseTimerBar extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const FuseTimerBar({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp progress between 0 and 1
    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Time text (monospace from AppTypography)
        Text(
          TimeFormatter.formatDuration(Duration(seconds: remainingSeconds)),
          style: AppTypography.timer.copyWith(
            fontSize: 24, // Optimized for the bar
            color: progress < 0.2 ? AppColors.danger : AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        // Glowing progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Background track
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Glowing progress fill
                AnimatedContainer(
                  duration: AppAnimations.medium,
                  curve: AppAnimations.easeOutExpo,
                  height: 4,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: progress < 0.2 ? AppColors.danger : AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (progress < 0.2
                                    ? AppColors.danger
                                    : AppColors.accent)
                                .withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
