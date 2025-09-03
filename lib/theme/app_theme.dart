import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Spatial Minimalism with Cinematic Depth color scheme
/// optimized for media consumption and professional intimacy.
class AppTheme {
  AppTheme._();

  // Cinematic Depth Color Palette
  static const Color primaryLight = Color(0xFF1A1A1A); // Deep charcoal
  static const Color primaryDark = Color(0xFF1A1A1A); // Deep charcoal

  static const Color secondaryLight = Color(0xFF2D2D2D); // Elevated surface
  static const Color secondaryDark = Color(0xFF2D2D2D); // Elevated surface

  static const Color accentLight = Color(0xFF4A9EFF); // Vibrant blue
  static const Color accentDark = Color(0xFF4A9EFF); // Vibrant blue

  static const Color successLight = Color(0xFF00C851); // Clean green
  static const Color successDark = Color(0xFF00C851); // Clean green

  static const Color warningLight = Color(0xFFFF8800); // Warm orange
  static const Color warningDark = Color(0xFFFF8800); // Warm orange

  static const Color errorLight = Color(0xFFFF4444); // Clear red
  static const Color errorDark = Color(0xFFFF4444); // Clear red

  static const Color surfaceLight = Color(0xFF0F0F0F); // Deep background
  static const Color surfaceDark = Color(0xFF0F0F0F); // Deep background

  static const Color backgroundLight = Color(0xFF0F0F0F); // Deep background
  static const Color backgroundDark = Color(0xFF0F0F0F); // Deep background

  // Text colors for optimal contrast and hierarchy
  static const Color textPrimaryLight = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // Pure white

  static const Color textSecondaryLight = Color(0xFFB0B0B0); // Muted gray
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Muted gray

  static const Color textTertiaryLight = Color(0xFF808080); // Subtle gray
  static const Color textTertiaryDark = Color(0xFF808080); // Subtle gray

  // Card and dialog colors for spatial hierarchy
  static const Color cardLight = Color(0xFF2D2D2D);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color dialogLight = Color(0xFF2D2D2D);
  static const Color dialogDark = Color(0xFF2D2D2D);

  // Shadow colors for subtle depth communication
  static const Color shadowLight = Color(0x33000000); // 20% opacity maximum
  static const Color shadowDark = Color(0x33000000); // 20% opacity maximum

  // Divider colors for minimal separation
  static const Color dividerLight = Color(0x26FFFFFF); // 15% opacity
  static const Color dividerDark = Color(0x26FFFFFF); // 15% opacity

  /// Light theme (optimized for OLED displays and battery efficiency)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark, // Using dark brightness for cinematic depth
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentLight,
      onPrimary: textPrimaryLight,
      primaryContainer: primaryLight,
      onPrimaryContainer: textPrimaryLight,
      secondary: secondaryLight,
      onSecondary: textPrimaryLight,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: textPrimaryLight,
      tertiary: accentLight,
      onTertiary: textPrimaryLight,
      tertiaryContainer: secondaryLight,
      onTertiaryContainer: textPrimaryLight,
      error: errorLight,
      onError: textPrimaryLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: dividerLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: textPrimaryLight,
      onInverseSurface: primaryLight,
      inversePrimary: accentLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,

    // AppBar theme for media-focused interface
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      toolbarTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
    ),

    // Card theme with subtle elevation for spatial hierarchy
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation optimized for media controls
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: accentLight,
      unselectedItemColor: textSecondaryLight,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button for media actions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentLight,
      foregroundColor: textPrimaryLight,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for consistent interaction patterns
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimaryLight,
        backgroundColor: accentLight,
        disabledForegroundColor: textTertiaryLight,
        disabledBackgroundColor: secondaryLight,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentLight,
        disabledForegroundColor: textTertiaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: accentLight, width: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentLight,
        disabledForegroundColor: textTertiaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
    ),

    // Typography using Inter for exceptional mobile legibility
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for media metadata and search
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textTertiaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondaryLight,
      suffixIconColor: textSecondaryLight,
    ),

    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return textSecondaryLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight.withValues(alpha: 0.3);
        }
        return textTertiaryLight.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textPrimaryLight),
      side: BorderSide(color: textSecondaryLight, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return textSecondaryLight;
      }),
    ),

    // Progress indicators for media loading
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentLight,
      linearTrackColor: secondaryLight,
      circularTrackColor: secondaryLight,
    ),

    // Slider theme for media scrubbing
    sliderTheme: SliderThemeData(
      activeTrackColor: accentLight,
      inactiveTrackColor: secondaryLight,
      thumbColor: accentLight,
      overlayColor: accentLight.withValues(alpha: 0.2),
      valueIndicatorColor: accentLight,
      valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
        color: textPrimaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tab bar theme for content organization
    tabBarTheme: TabBarTheme(
      labelColor: accentLight,
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: accentLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryLight,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0,
    ),

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: dialogLight,
      surfaceTintColor: Colors.transparent,
      elevation: 8.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Bottom sheet theme for contextual options
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: dialogLight,
      surfaceTintColor: Colors.transparent,
      elevation: 8.0,
      shadowColor: shadowLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    ),
  );

  /// Dark theme (identical to light theme for cinematic consistency)
  static ThemeData darkTheme = lightTheme;

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;
    final Color textTertiary = isLight ? textTertiaryLight : textTertiaryDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for cards and lists
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Additional color getters for specific use cases
  static Color get success => successLight;
  static Color get warning => warningLight;
  static Color get accent => accentLight;

  /// Shadow configurations for subtle depth
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: shadowLight,
          blurRadius: 4.0,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: shadowLight,
          blurRadius: 8.0,
          offset: const Offset(0, 4),
        ),
      ];
}
