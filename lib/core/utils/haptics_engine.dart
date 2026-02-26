import 'package:flutter/services.dart';

class HapticsEngine {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void success() {
    HapticFeedback.heavyImpact(); // or use vibration patterns
  }

  static void error() {
    HapticFeedback.vibrate(); // Better distinction for error
  }
}
