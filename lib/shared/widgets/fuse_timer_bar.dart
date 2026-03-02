import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/timer_tick_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class FuseTimerBar extends ConsumerWidget {
  final DateTime expirationTimestamp;
  final int totalSeconds;

  const FuseTimerBar({
    super.key,
    required this.expirationTimestamp,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // THIS IS THE MAGIC: It rebuilds the widget exactly when the global tick fires
    ref.watch(timerTickProvider);

    // Time Math (Using UTC to prevent Timezone death)
    final now = DateTime.now().toUtc();
    final expiration = expirationTimestamp.toUtc();
    final timeLeft = expiration.isAfter(now)
        ? expiration.difference(now)
        : Duration.zero;

    // Premium 3-stage color shift
    Color activeColor;
    if (timeLeft.inMinutes >= 5) {
      activeColor = AppColors.timerSafe;
    } else if (timeLeft.inMinutes >= 1) {
      activeColor = AppColors.timerWarning;
    } else {
      activeColor = AppColors.timerCritical;
    }

    // Math for the visual line
    final progress = (timeLeft.inMilliseconds / (totalSeconds * 1000)).clamp(
      0.0,
      1.0,
    );

    // Monospace text formatting
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(timeLeft.inMinutes.remainder(60));
    final String seconds = twoDigits(timeLeft.inSeconds.remainder(60));
    final String milliseconds = twoDigits(
      (timeLeft.inMilliseconds.remainder(1000) / 10).floor(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$minutes:$seconds:$milliseconds",
          style: AppTypography.timerDisplay.copyWith(
            fontSize: 24,
            color: activeColor,
            shadows: [
              Shadow(
                color: activeColor.withValues(alpha: 0.4),
                blurRadius: 12.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 30),
                  curve: Curves.linear,
                  height: 4,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.6),
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
