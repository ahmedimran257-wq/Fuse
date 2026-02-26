import 'package:flutter/material.dart';

class AppAnimations {
  // Snappy, physics-based easing
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve easeInExpo = Curves.easeInExpo;

  // Custom spring for button presses
  static const spring = SpringDescription(mass: 1, stiffness: 300, damping: 30);

  // Duration constants
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 800);
}
