import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/timer_tick_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class FuseTimerBar extends ConsumerStatefulWidget {
  final DateTime expirationTimestamp;
  final int totalSeconds;

  const FuseTimerBar({
    super.key,
    required this.expirationTimestamp,
    required this.totalSeconds,
  });

  @override
  ConsumerState<FuseTimerBar> createState() => _FuseTimerBarState();
}

class _FuseTimerBarState extends ConsumerState<FuseTimerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Isolate timer repaints from the parent PostWidget
    return RepaintBoundary(
      child: _TimerContent(
        expirationTimestamp: widget.expirationTimestamp,
        totalSeconds: widget.totalSeconds,
        pulseController: _pulseController,
        pulseAnimation: _pulseAnimation,
      ),
    );
  }
}

class _TimerContent extends ConsumerWidget {
  final DateTime expirationTimestamp;
  final int totalSeconds;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const _TimerContent({
    required this.expirationTimestamp,
    required this.totalSeconds,
    required this.pulseController,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(timerTickProvider);

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

    // Pulse when critical
    final isCritical = timeLeft.inMinutes < 1 && timeLeft.inSeconds > 0;
    if (isCritical && !pulseController.isAnimating) {
      pulseController.repeat(reverse: true);
    } else if (!isCritical && pulseController.isAnimating) {
      pulseController.stop();
      pulseController.reset();
    }

    final progress = (timeLeft.inMilliseconds / (totalSeconds * 1000)).clamp(
      0.0,
      1.0,
    );

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
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isCritical ? pulseAnimation.value : 1.0,
              child: child,
            );
          },
          child: Text(
            "$minutes:$seconds.$milliseconds",
            style: AppTypography.timerDisplay.copyWith(
              fontSize: 24,
              color: activeColor,
              shadows: [
                Shadow(
                  color: activeColor.withValues(alpha: 0.5),
                  blurRadius: isCritical ? 20.0 : 12.0,
                ),
              ],
            ),
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
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear,
                  height: 4,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.6),
                        blurRadius: isCritical ? 16 : 10,
                        spreadRadius: isCritical ? 4 : 2,
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
