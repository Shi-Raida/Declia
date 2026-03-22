import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Unified ThemeData composing colors, typography, and component themes
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.crepuscule,
      onPrimary: AppColors.bgCard,
      primaryContainer: AppColors.crepusculeLight,
      onPrimaryContainer: AppColors.bgCard,
      secondary: AppColors.terracotta,
      onSecondary: AppColors.bgCard,
      secondaryContainer: AppColors.terracottaLight,
      onSecondaryContainer: AppColors.terracottaHover,
      tertiary: AppColors.or,
      onTertiary: AppColors.bgCard,
      error: AppColors.error,
      onError: AppColors.bgCard,
      surface: AppColors.bg,
      onSurface: AppColors.encre,
      surfaceContainerHighest: AppColors.bgCard,
      outline: AppColors.border,
      outlineVariant: AppColors.borderDark,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: AppTypography.textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.terracotta,
        foregroundColor: AppColors.bgCard,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        textStyle: AppTypography.button(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.crepuscule,
        side: const BorderSide(color: AppColors.crepuscule, width: 1.5),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        textStyle: AppTypography.button(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      hintStyle: AppTypography.bodyMedium().copyWith(
        fontWeight: FontWeight.w300,
        color: const Color(0xFFB8B3AC),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgCard,
      foregroundColor: AppColors.encre,
      elevation: 0,
      titleTextStyle: AppTypography.heading4(),
    ),
  );
}
