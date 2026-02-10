import 'package:flutter/material.dart';

/// App color constants based on Figma design
class AppColors {
  AppColors._();

  // Vantage Palette
  static const Color primary = Color(0xFFFF9F1C); // Sunset Orange
  static const Color accent = Color(0xFF2EC4B6);  // Glacier Teal
  static const Color obsidian = Color(0xFF0F1419); // Midnight Forest
  static const Color slate = Color(0xFF1E252B);    // Slate Smoke

  // Background Colors
  static const Color background = obsidian;
  static const Color surface = slate;
  static const Color glass = Color(0x661E252B); // 40% Opacity Slate

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFF8F9FA); // Morning Mist
  static const Color grey = Color(0xFF8E8E93);
  static const Color greyLight = Color(0xFFC7C7CC);
  static const Color greyExtraLight = Color(0xFFF2F2F7);
  static const Color greyDark = Color(0xFF636366);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8F9FA); // Morning Mist
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF636366);
  static const Color textOnPrimary = Color(0xFF0F1419);

  // Status Colors
  static const Color success = Color(0xFF2EC4B6);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9F1C);
  static const Color info = Color(0xFF2EC4B6);

  // Tints & Shades for backward compatibility
  static Color primaryLight = primary.withOpacity(0.3);
  static Color primaryExtraLight = primary.withOpacity(0.1);
  static const Color secondary = accent;
  static const Color backgroundSecondary = slate;

  // Functional Colors
  static const Color divider = Color(0x1AFFFFFF);
  static const Color shadow = Color(0x66000000);
  static const Color overlay = Color(0x99000000);

  // Gradient Colors
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF9F1C), Color(0xFFFFBF69)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
