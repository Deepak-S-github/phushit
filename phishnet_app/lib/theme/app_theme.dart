import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1E1E1E);
  static const Color secondaryColor = Color(0xFF2A2A2A);
  static const Color accentColor = Color(0xFF4A9EFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color surfaceColor = Color(0xFF1A1A1A);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: secondaryColor,
        background: primaryColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: secondaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentColor;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return accentColor.withOpacity(0.3);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }
}