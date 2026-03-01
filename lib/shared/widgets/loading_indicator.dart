import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_animations.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.accent, width: 2),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 0.8,
                end: 1.2,
                duration: AppAnimations.medium,
                curve: AppAnimations.easeOutExpo,
              )
              .fadeOut(duration: AppAnimations.medium)
              .fadeIn(duration: AppAnimations.medium),
        ],
      ),
    );
  }
}
