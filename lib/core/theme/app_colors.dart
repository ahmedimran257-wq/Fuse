import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ──
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceHighlight = Color(0xFF1C1C1E);
  static const Color surfaceElevated = Color(0xFF2C2C2E);
  static const Color surfaceOverlay = Color(0xFF3A3A3C);

  // ── Brand ──
  static const Color accent = Color(
    0xFFFF5722,
  ); // Warm Orange (softened from #FF4500)
  static const Color accentCyan = Color(0xFF06B6D4); // Refined Cyan
  static const Color accentGold = Color(0xFFD4A017); // Premium Gold

  // ── Text ──
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF636366);

  // ── Semantic ──
  static const Color danger = Color(0xFFFF453A); // iOS-style red
  static const Color success = Color(0xFF34D399); // Emerald green

  // ── Timer stages (HSL-tuned, not raw RGB) ──
  static const Color timerSafe = Color(
    0xFF34D399,
  ); // Soft Emerald (was #00FF00)
  static const Color timerWarning = Color(
    0xFFFBBF24,
  ); // Warm Amber (was #FFFF00)
  static const Color timerCritical = Color(0xFFFF453A); // Pulse Red

  // ── Glass / Overlays ──
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0xB3000000);

  // ── Gradients ──
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
    stops: [0.1, 0.5, 0.9],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}
