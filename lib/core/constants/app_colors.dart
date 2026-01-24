import 'package:flutter/material.dart';

/// App color constants based on Figma design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF007AFF); // Blue from Figma
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color primaryLight = Color(0xFF4DA3FF);

  // Secondary Colors
  static const Color secondary = Color(0xFF5856D6);
  static const Color secondaryDark = Color(0xFF3634A3);
  static const Color secondaryLight = Color(0xFF8B89E6);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8E8E93);
  static const Color greyLight = Color(0xFFC7C7CC);
  static const Color greyExtraLight = Color(0xFFF2F2F7);
  static const Color greyDark = Color(0xFF636366);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // Functional Colors
  static const Color divider = Color(0xFFE5E5EA);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x4D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
