import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Mindful Minimalism design with Serene Neutrals color palette
/// optimized for personal journaling and contemplative focus.
class AppTheme {
  AppTheme._();

  // Serene Neutrals Color Palette - optimized for extended reading/writing sessions
  static const Color primaryLight =
      Color(0xFF6B73FF); // Calming purple-blue for primary actions
  static const Color secondaryLight =
      Color(0xFF9C27B0); // Supporting accent for secondary actions
  static const Color surfaceLight =
      Color(0xFFFEFBFF); // Warm white background that reduces eye strain
  static const Color surfaceVariantLight =
      Color(0xFFF4F0F7); // Subtle container backgrounds
  static const Color onSurfaceLight =
      Color(0xFF1C1B1F); // High contrast text color
  static const Color onSurfaceVariantLight =
      Color(0xFF49454F); // Secondary text color
  static const Color outlineLight = Color(0xFF79747E); // Minimal border color
  static const Color outlineVariantLight = Color(0xFFCAC4D0); // Lighter borders
  static const Color successLight = Color(0xFF4CAF50); // Confirmation states
  static const Color errorLight = Color(0xFFF44336); // Error states

  // Dark theme colors - maintaining serene aesthetic
  static const Color primaryDark = Color(0xFF8B93FF);
  static const Color secondaryDark = Color(0xFFBA68C8);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantDark = Color(0xFF49454F);
  static const Color successDark = Color(0xFF66BB6A);
  static const Color errorDark = Color(0xFFEF5350);

  // Additional semantic colors
  static const Color backgroundLight = Color(0xFFFEFBFF);
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color cardLight = Color(0xFFFEFBFF);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color shadowLight =
      Color(0x1F000000); // 8% opacity for subtle shadows
  static const Color shadowDark = Color(0x1FFFFFFF);

  /// Light theme with Mindful Minimalism approach
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primaryLight.withAlpha(26),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withAlpha(26),
      onSecondaryContainer: secondaryLight,
      tertiary: primaryLight,
      onTertiary: Colors.white,
      tertiaryContainer: primaryLight.withAlpha(26),
      onTertiaryContainer: primaryLight,
      error: errorLight,
      onError: Colors.white,
      errorContainer: errorLight.withAlpha(26),
      onErrorContainer: errorLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      surfaceContainerHighest: surfaceVariantLight,
      onSurfaceVariant: onSurfaceVariantLight,
      outline: outlineLight,
      outlineVariant: outlineVariantLight,
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryDark,
      surfaceTint: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: outlineVariantLight,

    // AppBar theme - clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: onSurfaceLight,
      elevation: 0, // Flat design for contemplative focus
      scrolledUnderElevation: 1, // Minimal elevation when scrolled
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: onSurfaceLight,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: onSurfaceLight, size: 24),
      actionsIconTheme: IconThemeData(color: onSurfaceLight, size: 24),
    ),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 1, // Minimal elevation per design standards
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation with serene aesthetics
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: onSurfaceVariantLight,
      elevation: 3, // Maximum elevation per design standards
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

    // FAB with contextual states
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 3,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes with contemplative design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 1,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        side: BorderSide(color: outlineLight, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography with Inter font family
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration with minimal borders
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // Eliminated borders per design
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryLight, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: onSurfaceVariantLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: onSurfaceVariantLight.withAlpha(153),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return outlineLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(77);
        }
        return outlineVariantLight;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: outlineLight, width: 1),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return outlineLight;
      }),
    ),

    // Progress indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: outlineVariantLight,
      circularTrackColor: outlineVariantLight,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withAlpha(51),
      inactiveTrackColor: outlineVariantLight,
      trackHeight: 4,
    ),

    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: onSurfaceVariantLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceLight.withAlpha(230),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceLight,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 3,
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurfaceLight,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariantLight,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: outlineVariantLight,
      thickness: 1,
      space: 1,
    ),
  );

  /// Dark theme with Mindful Minimalism approach
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.black,
      primaryContainer: primaryDark.withAlpha(51),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: Colors.black,
      secondaryContainer: secondaryDark.withAlpha(51),
      onSecondaryContainer: secondaryDark,
      tertiary: primaryDark,
      onTertiary: Colors.black,
      tertiaryContainer: primaryDark.withAlpha(51),
      onTertiaryContainer: primaryDark,
      error: errorDark,
      onError: Colors.black,
      errorContainer: errorDark.withAlpha(51),
      onErrorContainer: errorDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      surfaceContainerHighest: surfaceVariantDark,
      onSurfaceVariant: onSurfaceVariantDark,
      outline: outlineDark,
      outlineVariant: outlineVariantDark,
      shadow: shadowDark,
      scrim: Colors.black54,
      inverseSurface: surfaceLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: primaryLight,
      surfaceTint: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: outlineVariantDark,

    // AppBar theme - clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: onSurfaceDark,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: onSurfaceDark, size: 24),
      actionsIconTheme: IconThemeData(color: onSurfaceDark, size: 24),
    ),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 1,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation with serene aesthetics
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: onSurfaceVariantDark,
      elevation: 3,
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

    // FAB with contextual states
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.black,
      elevation: 3,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes with contemplative design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        side: BorderSide(color: outlineDark, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography with Inter font family
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration with minimal borders
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryDark, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: onSurfaceVariantDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: onSurfaceVariantDark.withAlpha(153),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return outlineDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(77);
        }
        return outlineVariantDark;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.black),
      side: BorderSide(color: outlineDark, width: 1),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return outlineDark;
      }),
    ),

    // Progress indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: outlineVariantDark,
      circularTrackColor: outlineVariantDark,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withAlpha(51),
      inactiveTrackColor: outlineVariantDark,
      trackHeight: 4,
    ),

    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryDark,
      unselectedLabelColor: onSurfaceVariantDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceDark.withAlpha(230),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceDark,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 3,
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurfaceDark,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariantDark,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: outlineVariantDark,
      thickness: 1,
      space: 1,
    ),
  );

  /// Helper method to build text theme with Inter font family
  /// Implements typography standards for headings, body text, and captions
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? onSurfaceLight : onSurfaceDark;
    final Color textSecondary =
        isLight ? onSurfaceVariantLight : onSurfaceVariantDark;

    return TextTheme(
      // Display styles - for large headings
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

      // Headline styles - for section headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600, // SemiBold for headings
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w500, // Medium for headings
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - for component titles
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular for body text
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

      // Label styles - for UI elements
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
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data text style using JetBrains Mono for word counts and timestamps
  static TextStyle dataTextStyle(
      {required bool isLight, double fontSize = 12}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isLight ? onSurfaceVariantLight : onSurfaceVariantDark,
      letterSpacing: 0,
      height: 1.33,
    );
  }

  /// Caption text style for metadata
  static TextStyle captionTextStyle({required bool isLight}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isLight ? onSurfaceVariantLight : onSurfaceVariantDark,
      letterSpacing: 0.4,
      height: 1.33,
    );
  }
}
