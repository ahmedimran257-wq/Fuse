import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FuseGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blurIntensity;

  /// Set to true ONLY for static overlays (dialogs, modals).
  /// False (default) uses a performant opaque-glass look for scrolling lists.
  final bool useBlur;

  const FuseGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.blurIntensity = 10,
    this.useBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: useBlur ? AppColors.glassOverlay : const Color(0xE6121212),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.08),
        width: 0.5,
      ),
    );

    if (useBlur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            padding: padding,
            decoration: decoration,
            child: child,
          ),
        ),
      );
    }

    // Performant path: no BackdropFilter
    return Container(padding: padding, decoration: decoration, child: child);
  }
}
