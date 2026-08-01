import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.manrope(
      fontSize: 48,
      height: 56 / 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 48,
      color: AppColors.onSurface,
    ),
    displayMedium: GoogleFonts.manrope(
      fontSize: 36, 
      height: 44 / 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 36,
      color: AppColors.onSurface,
    ),
    headlineMedium: GoogleFonts.manrope(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    bodyLarge: GoogleFonts.manrope(
      fontSize: 28,
      height: 28 / 28,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurface,
    ),
    bodyMedium: GoogleFonts.manrope(
      fontSize: 22,
      height: 22 / 22,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurface,
    ),
    bodySmall: GoogleFonts.manrope(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    labelSmall: GoogleFonts.jetBrainsMono(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05 * 12,
      color: AppColors.onSurfaceVariant,
    ),
  );
}