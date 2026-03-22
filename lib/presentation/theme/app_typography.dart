import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Text styles: Cormorant Garamond (headings), Outfit (body)
abstract final class AppTypography {
  static TextStyle heading1() => GoogleFonts.cormorantGaramond(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.96,
    color: AppColors.encre,
  );

  static TextStyle heading2() => GoogleFonts.cormorantGaramond(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.36,
    color: AppColors.encre,
  );

  static TextStyle heading3() => GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.encre,
  );

  static TextStyle heading4() => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.encre,
  );

  static TextStyle bodyLarge() => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
    color: AppColors.encre,
  );

  static TextStyle bodyMedium() => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.encre,
  );

  static TextStyle bodySmall() => GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.pierre,
  );

  static TextStyle label() => GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
    color: AppColors.terracotta,
  );

  static TextStyle button() => GoogleFonts.outfit(
    fontSize: 14.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static TextStyle statValue() => GoogleFonts.cormorantGaramond(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.encre,
  );

  static TextStyle statLabel() => GoogleFonts.outfit(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.3,
    color: AppColors.grisTexte,
  );

  static TextStyle sectionTitle() => GoogleFonts.outfit(
    fontSize: 9.6,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.pierre,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: heading1(),
    displayMedium: heading2(),
    displaySmall: heading3(),
    headlineMedium: heading4(),
    bodyLarge: bodyLarge(),
    bodyMedium: bodyMedium(),
    bodySmall: bodySmall(),
    labelLarge: button(),
    labelSmall: label(),
  );
}
