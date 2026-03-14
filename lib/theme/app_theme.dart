import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2E6F88);
  static const Color secondary = Color(0xFF1F4F5F);
  static const Color accent = Color(0xFFC9A227);
  static const Color background = Color(0xFFF8FAFB);
  static const Color textPrimary = Color(0xFF1A2A33);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
      ),
    );
  }

  static Gradient? get backgroundGradient => null;
}
