import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepSpace,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentCyan,
        tertiary: AppColors.highlightGreen,
        surface: AppColors.darkNavy,
        surfaceContainerHighest: AppColors.charcoal,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.gray100,
        onError: Colors.white,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTypography.display1.copyWith(color: AppColors.gray100),
        displayMedium: AppTypography.display2.copyWith(color: AppColors.gray100),
        displaySmall: AppTypography.display3.copyWith(color: AppColors.gray100),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.gray100),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.gray100),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.gray100),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.gray100),
        titleMedium: AppTypography.h5.copyWith(color: AppColors.gray100),
        titleSmall: AppTypography.h6.copyWith(color: AppColors.gray100),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.gray200),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.gray200),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.gray300),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.gray100),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.gray200),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.gray300),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.gray100),
        titleTextStyle: AppTypography.h5.copyWith(color: AppColors.gray100),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.charcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.gray600.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray600.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray600.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray300),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.gray600.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.gray200,
        size: 24,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.charcoal,
        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium,
        side: BorderSide(color: AppColors.gray600.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,

      // Color Scheme - 높은 대비
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentCyan,
        tertiary: AppColors.highlightGreen,
        surface: AppColors.lightCard,
        surfaceContainerHighest: AppColors.lightBg2,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightText,
        onError: Colors.white,
      ),

      // Typography - 높은 대비
      textTheme: TextTheme(
        displayLarge: AppTypography.display1.copyWith(color: AppColors.lightText),
        displayMedium: AppTypography.display2.copyWith(color: AppColors.lightText),
        displaySmall: AppTypography.display3.copyWith(color: AppColors.lightText),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.lightText),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.lightText),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.lightText),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.lightText),
        titleMedium: AppTypography.h5.copyWith(color: AppColors.lightText2),
        titleSmall: AppTypography.h6.copyWith(color: AppColors.lightText2),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.lightText2),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.lightText2),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.lightText3),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.lightText),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.lightText2),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.lightText3),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.lightText),
        titleTextStyle: AppTypography.h5.copyWith(color: AppColors.lightText),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.lightGray300.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonMedium.copyWith(color: Colors.white),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBg2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.lightText3),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextMuted),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.lightGray300,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.lightText2,
        size: 24,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBg2,
        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.1),
        labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.lightText),
        side: BorderSide(color: AppColors.lightGray300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // System UI Overlay Styles
  static SystemUiOverlayStyle get darkSystemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.deepSpace,
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }

  static SystemUiOverlayStyle get lightSystemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.lightBg,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }
}
