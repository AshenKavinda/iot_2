import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AquaColors {
  static const bg = Color(0xFFF0F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const cardAlt = Color(0xFFE8F4FD);
  static const primary = Color(0xFF0097A7);
  static const primaryDark = Color(0xFF00838F);
  static const primaryLight = Color(0xFF4DD0E1);
  static const onPrimary = Color(0xFFFFFFFF);
  static const success = Color(0xFF26A69A);
  static const warning = Color(0xFFFFB300);
  static const errorColor = Color(0xFFEF5350);
  static const textPrimary = Color(0xFF0D2137);
  static const textSec = Color(0xFF4A6572);
  static const textHint = Color(0xFF90A4AE);
  static const divider = Color(0xFFDCE8EF);
  static const pumpGlow = Color(0xFF00BCD4);
}

class AquaTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AquaColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AquaColors.primary,
        brightness: Brightness.light,
        primary: AquaColors.primary,
        onPrimary: AquaColors.onPrimary,
        surface: AquaColors.surface,
        error: AquaColors.errorColor,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        bodyLarge: GoogleFonts.nunito(color: AquaColors.textPrimary, fontSize: 15),
        bodyMedium: GoogleFonts.nunito(color: AquaColors.textPrimary, fontSize: 14),
        bodySmall: GoogleFonts.nunito(color: AquaColors.textSec, fontSize: 12),
        titleLarge: GoogleFonts.nunito(
            color: AquaColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
        titleMedium: GoogleFonts.nunito(
            color: AquaColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        titleSmall: GoogleFonts.nunito(
            color: AquaColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: GoogleFonts.nunito(
            color: AquaColors.textHint,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AquaColors.surface,
        foregroundColor: AquaColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.nunito(
          color: AquaColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: AquaColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AquaColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.nunito(
            color: AquaColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AquaColors.primary,
        contentTextStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AquaColors.primary : AquaColors.textHint,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AquaColors.primary.withValues(alpha: 0.4)
              : AquaColors.textHint.withValues(alpha: 0.3),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AquaColors.divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AquaColors.cardAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
