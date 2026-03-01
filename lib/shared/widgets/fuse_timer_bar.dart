import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

import '../../core/theme/app_typography.dart';

class FuseTimerBar extends StatefulWidget {
  final DateTime
  expirationTimestamp; // MUST be a DateTime to track absolute real-world time
  final int totalSeconds;

  const FuseTimerBar({
    super.key,
    required this.expirationTimestamp,
    required this.totalSeconds,
  });

  @override
  State<FuseTimerBar> createState() => _FuseTimerBarState();
}

class _FuseTimerBarState extends State<FuseTimerBar> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTime();
    // 30ms refresh rate for the buttery smooth millisecond blur
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => _calculateTime(),
    );
  }

  void _calculateTime() {
    // Lock both times to UTC to prevent Timezone math errors
    final now = DateTime.now().toUtc();
    final expiration = widget.expirationTimestamp.toUtc();

    if (expiration.isBefore(now)) {
      if (_timeLeft != Duration.zero) {
        setState(() => _timeLeft = Duration.zero);
        _timer.cancel();
      }
    } else {
      setState(() {
        _timeLeft = expiration.difference(now);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Critical to prevent memory leaks when scrolling!
    super.dispose();
  }

  // Premium 3-stage color shift
  Color get _activeColor {
    if (_timeLeft.inMinutes >= 5) {
      return AppColors.accentCyan; // Safe (Electric Cyan)
    }
    if (_timeLeft.inMinutes >= 1) {
      return AppColors.accent; // Warning (Blood Orange)
    }
    return AppColors.danger; // Critical (Crimson Red)
  }

  @override
  Widget build(BuildContext context) {
    // Clamp progress between 0.0 (empty) and 1.0 (full)
    final progress = (_timeLeft.inMilliseconds / (widget.totalSeconds * 1000))
        .clamp(0.0, 1.0);

    // High-precision formatting: MM:SS:ms (e.g. 14:59:82)
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    final String seconds = twoDigits(_timeLeft.inSeconds.remainder(60));
    final String milliseconds = twoDigits(
      (_timeLeft.inMilliseconds.remainder(1000) / 10).floor(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Monospace Digital Readout
        Text(
          "$minutes:$seconds:$milliseconds",
          style: AppTypography.timer.copyWith(
            fontSize: 24,
            color: _activeColor,
            shadows: [
              Shadow(
                color: _activeColor.withValues(alpha: 0.4),
                blurRadius: 12.0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 2. Glowing Physics-Based Depletion Line
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Empty background track
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // The glowing active fuse
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves
                      .linear, // Strictly linear so the bar doesn't "bounce" as it shrinks
                  height: 4,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: _activeColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: _activeColor.withValues(alpha: 0.6),
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
