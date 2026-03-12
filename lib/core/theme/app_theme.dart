import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Dark Palette ──────────────────────────────────────────────────────────
  static const Color _dPrimary      = Color(0xFF6C63FF);
  static const Color _dPrimaryDark  = Color(0xFF4B44CC);
  static const Color _dAccent       = Color(0xFFFF6584);
  static const Color _dSuccess      = Color(0xFF43D9A2);
  static const Color _dWarning      = Color(0xFFFFB800);

  static const Color _dBgDark       = Color(0xFF0D0D1A);
  static const Color _dBgCard       = Color(0xFF161628);
  static const Color _dBgSurface    = Color(0xFF1E1E35);

  static const Color _dTextPrimary  = Color(0xFFF0F0FF);
  static const Color _dTextSecondary= Color(0xFF9090B0);
  static const Color _dTextMuted    = Color(0xFF5A5A7A);
  static const Color _dDivider      = Color(0xFF252540);

  static const Color _dShimmerBase      = Color(0xFF1E1E35);
  static const Color _dShimmerHighlight = Color(0xFF2A2A50);

  // ─── Light Palette ─────────────────────────────────────────────────────────
  static const Color _lPrimary      = Color(0xFF5B52F0);
  static const Color _lPrimaryDark  = Color(0xFF3D36C8);
  static const Color _lAccent       = Color(0xFFFF4D6D);
  static const Color _lSuccess      = Color(0xFF14B87B);
  static const Color _lWarning      = Color(0xFFE09B00);

  static const Color _lBgDark       = Color(0xFFF4F4FF);   // page bg
  static const Color _lBgCard       = Color(0xFFFFFFFF);   // card bg
  static const Color _lBgSurface    = Color(0xFFEEEEFA);   // input / qty bg

  static const Color _lTextPrimary  = Color(0xFF0D0D2B);
  static const Color _lTextSecondary= Color(0xFF5A5A80);
  static const Color _lTextMuted    = Color(0xFF9090B0);
  static const Color _lDivider      = Color(0xFFE0E0EF);

  static const Color _lShimmerBase      = Color(0xFFE8E8F5);
  static const Color _lShimmerHighlight = Color(0xFFF8F8FF);

  // ─── Resolved getters (mode-aware) ─────────────────────────────────────────
  // Usage: AppTheme.of(context).primary  OR  use the static helpers below
  // with a BuildContext-free approach via ThemeController.isDark.

  // Static helpers for when you have a BuildContext:
  static AppThemeData of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? _dark : _light;
  }

  // Static helpers for GetX (context-free, drive from ThemeController.isDark):
  static AppThemeData get dark  => _dark;
  static AppThemeData get light => _light;

  // ─── Gradients (same hues, opacity adjusted per mode) ─────────────────────
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF5B52F0), Color(0xFF8040D0)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF8E53)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static LinearGradient cardGradientDark = const LinearGradient(
    colors: [Color(0xFF1E1E38), Color(0xFF161628)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static LinearGradient cardGradientLight = const LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F8FF)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // ─── ThemeData ──────────────────────────────────────────────────────────────
  static ThemeData get darkThemeData => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _dBgDark,
    primaryColor: _dPrimary,
    colorScheme: const ColorScheme.dark(
      primary: _dPrimary,
      secondary: _dAccent,
      surface: _dBgCard,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: _dark.headingLarge,
      iconTheme: const IconThemeData(color: _dTextPrimary),
    ),
    dividerColor: _dDivider,
    useMaterial3: true,
  );

  static ThemeData get lightThemeData => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lBgDark,
    primaryColor: _lPrimary,
    colorScheme: const ColorScheme.light(
      primary: _lPrimary,
      secondary: _lAccent,
      surface: _lBgCard,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: _light.headingLarge,
      iconTheme: const IconThemeData(color: _lTextPrimary),
    ),
    dividerColor: _lDivider,
    useMaterial3: true,
  );

  // ─── Internal singleton instances ──────────────────────────────────────────
  static final AppThemeData _dark = AppThemeData(
    isDark: true,
    primary: _dPrimary,
    primaryDark: _dPrimaryDark,
    accent: _dAccent,
    success: _dSuccess,
    warning: _dWarning,
    bgDark: _dBgDark,
    bgCard: _dBgCard,
    bgSurface: _dBgSurface,
    textPrimary: _dTextPrimary,
    textSecondary: _dTextSecondary,
    textMuted: _dTextMuted,
    divider: _dDivider,
    shimmerBase: _dShimmerBase,
    shimmerHighlight: _dShimmerHighlight,
    primaryGradient: primaryGradientDark,
    cardGradient: cardGradientDark,
  );

  static final AppThemeData _light = AppThemeData(
    isDark: false,
    primary: _lPrimary,
    primaryDark: _lPrimaryDark,
    accent: _lAccent,
    success: _lSuccess,
    warning: _lWarning,
    bgDark: _lBgDark,
    bgCard: _lBgCard,
    bgSurface: _lBgSurface,
    textPrimary: _lTextPrimary,
    textSecondary: _lTextSecondary,
    textMuted: _lTextMuted,
    divider: _lDivider,
    shimmerBase: _lShimmerBase,
    shimmerHighlight: _lShimmerHighlight,
    primaryGradient: primaryGradientLight,
    cardGradient: cardGradientLight,
  );
}

// ─── AppThemeData ────────────────────────────────────────────────────────────
/// Carry all resolved tokens for a single brightness.
/// Widgets access this via  AppTheme.of(context)  or  ThemeController.theme
class AppThemeData {
  final bool isDark;

  final Color primary;
  final Color primaryDark;
  final Color accent;
  final Color success;
  final Color warning;

  final Color bgDark;
  final Color bgCard;
  final Color bgSurface;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color divider;

  final Color shimmerBase;
  final Color shimmerHighlight;

  final LinearGradient primaryGradient;
  final LinearGradient cardGradient;

  // Accent gradient is mode-independent
  LinearGradient get accentGradient => AppTheme.accentGradient;

  const AppThemeData({
    required this.isDark,
    required this.primary,
    required this.primaryDark,
    required this.accent,
    required this.success,
    required this.warning,
    required this.bgDark,
    required this.bgCard,
    required this.bgSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.primaryGradient,
    required this.cardGradient,
  });

  // ─── Text Styles ─────────────────────────────────────────────────────────
  TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
    fontSize: 32, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: -0.5,
  );
  TextStyle get headingLarge => GoogleFonts.spaceGrotesk(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: textPrimary, letterSpacing: -0.3,
  );
  TextStyle get headingMedium => GoogleFonts.spaceGrotesk(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: textPrimary, height: 1.5,
  );
  TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: textSecondary, height: 1.4,
  );
  TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: textMuted, letterSpacing: 0.5,
  );
  TextStyle get priceLarge => GoogleFonts.spaceGrotesk(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: success,
  );
  TextStyle get priceMedium => GoogleFonts.spaceGrotesk(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: success,
  );
}