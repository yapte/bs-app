import 'package:flutter/material.dart';

abstract final class SpaThemeColors {
  static const blue = Color(0xFF4AA3DF);
  static const blueDark = Color(0xFF237DBB);
  static const gold = Color(0xFFC2B45B);
  static const ink = Color(0xFF374151);
  static const paper = Color(0xFFF8F8F6);
}

abstract final class SpaTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: SpaThemeColors.blue,
      brightness: Brightness.light,
      primary: SpaThemeColors.blue,
      secondary: SpaThemeColors.gold,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: SpaThemeColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SpaThemeColors.paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: SpaThemeColors.ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: SpaThemeColors.blue,
          fontSize: 40,
          fontWeight: FontWeight.w300,
          height: 1.12,
        ),
        headlineMedium: TextStyle(
          color: SpaThemeColors.blue,
          fontSize: 30,
          fontWeight: FontWeight.w300,
        ),
        titleLarge: TextStyle(
          color: SpaThemeColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: SpaThemeColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: SpaThemeColors.ink,
          fontSize: 16,
          height: 1.55,
        ),
        bodyMedium: TextStyle(
          color: SpaThemeColors.ink,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SpaThemeColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SpaThemeColors.blueDark,
          side: const BorderSide(color: SpaThemeColors.blue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: SpaThemeColors.gold.withValues(alpha: 0.16),
        selectedColor: SpaThemeColors.gold,
        labelStyle: const TextStyle(
          color: SpaThemeColors.ink,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
