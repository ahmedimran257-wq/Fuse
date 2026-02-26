import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 96,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 60,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 48,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 34,
          letterSpacing: 0.25,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 24,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 1.25,
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Monospace for timers
  static TextStyle get timer => GoogleFonts.jetBrainsMono(
    fontWeight: FontWeight.w400,
    fontSize: 48,
    letterSpacing: 2,
  );
}
