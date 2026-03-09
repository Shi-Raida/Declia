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
          primary: AppColors.prune,
          onPrimary: AppColors.bgCard,
          primaryContainer: AppColors.pruneLight,
          onPrimaryContainer: AppColors.bgCard,
          secondary: AppColors.rose,
          onSecondary: AppColors.bgCard,
          secondaryContainer: AppColors.roseLight,
          onSecondaryContainer: AppColors.roseHover,
          tertiary: AppColors.or,
          onTertiary: AppColors.bgCard,
          error: AppColors.error,
          onError: AppColors.bgCard,
          surface: AppColors.bg,
          onSurface: AppColors.charcoal,
          surfaceContainerHighest: AppColors.bgCard,
          outline: AppColors.border,
          outlineVariant: AppColors.borderDark,
        ),
        scaffoldBackgroundColor: AppColors.bg,
        textTheme: AppTypography.textTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.rose,
            foregroundColor: AppColors.bgCard,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            textStyle: AppTypography.button(),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.prune,
            side: const BorderSide(color: AppColors.prune, width: 1.5),
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
            borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          foregroundColor: AppColors.charcoal,
          elevation: 0,
          titleTextStyle: AppTypography.heading4(),
        ),
      );
}
