import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Colors ──────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color accent = Color(0xFFFF6584);
  static const Color success = Color(0xFF43D9A2);
  static const Color warning = Color(0xFFFFB800);

  static const Color bgDark = Color(0xFF0D0D1A);
  static const Color bgCard = Color(0xFF161628);
  static const Color bgSurface = Color(0xFF1E1E35);

  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF9090B0);
  static const Color textMuted = Color(0xFF5A5A7A);

  static const Color divider = Color(0xFF252540);
  static const Color shimmerBase = Color(0xFF1E1E35);
  static const Color shimmerHighlight = Color(0xFF2A2A50);

  // ── Gradients ───────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E38), Color(0xFF161628)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text Styles ─────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get headingLarge => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle get headingMedium => GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textMuted,
    letterSpacing: 0.5,
  );

  static TextStyle get priceLarge => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: success,
  );

  static TextStyle get priceMedium => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: success,
  );

  // ── Theme Data ──────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: bgCard,
      background: bgDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: headingLarge,
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    // cardTheme: CardTheme(
    //   color: bgCard,
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    // ),
    dividerColor: divider,
    useMaterial3: true,
  );
}