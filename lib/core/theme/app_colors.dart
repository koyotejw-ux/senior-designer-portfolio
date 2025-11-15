import 'package:flutter/material.dart';

/// Design System Colors - Based on Jaewoong Jung's Brand Identity
/// Primary: #0068B3, Accent: #009DDC, Highlight: #C1D72E
class AppColors {
  AppColors._();

  // Brand Colors (from CI/logo.svg)
  static const Color primaryBlue = Color(0xFF0068B3);      // Primary brand blue
  static const Color accentCyan = Color(0xFF009DDC);       // Accent cyan
  static const Color highlightGreen = Color(0xFFC1D72E);   // Lime green highlight
  static const Color brandWhite = Color(0xFFFFFFFF);       // White

  // Extended Palette - Blues
  static const Color blue900 = Color(0xFF003D6B);
  static const Color blue800 = Color(0xFF00508F);
  static const Color blue700 = Color(0xFF0068B3);  // Primary
  static const Color blue600 = Color(0xFF0080D6);
  static const Color blue500 = Color(0xFF009DDC);  // Accent
  static const Color blue400 = Color(0xFF33B3E5);
  static const Color blue300 = Color(0xFF66C9ED);
  static const Color blue200 = Color(0xFF99DFF5);
  static const Color blue100 = Color(0xFFCCEFFA);

  // Extended Palette - Greens
  static const Color green900 = Color(0xFF7A8C1C);
  static const Color green800 = Color(0xFF9CAF23);
  static const Color green700 = Color(0xFFC1D72E);  // Highlight
  static const Color green600 = Color(0xFFCADC4A);
  static const Color green500 = Color(0xFFD4E366);
  static const Color green400 = Color(0xFFDDEA85);
  static const Color green300 = Color(0xFFE6F1A3);
  static const Color green200 = Color(0xFFEFF7C1);
  static const Color green100 = Color(0xFFF7FBE0);

  // Dark Background Palette
  static const Color deepSpace = Color(0xFF0A0E1A);
  static const Color darkNavy = Color(0xFF0F1825);
  static const Color charcoal = Color(0xFF1A2332);
  static const Color slate = Color(0xFF2A3847);

  // Neutral Grays
  static const Color gray900 = Color(0xFF0D1117);
  static const Color gray800 = Color(0xFF161B22);
  static const Color gray700 = Color(0xFF21262D);
  static const Color gray600 = Color(0xFF30363D);
  static const Color gray500 = Color(0xFF484F58);
  static const Color gray400 = Color(0xFF6E7681);
  static const Color gray300 = Color(0xFF8B949E);
  static const Color gray200 = Color(0xFFB1BAC4);
  static const Color gray100 = Color(0xFFC9D1D9);

  // Semantic Colors
  static const Color success = Color(0xFFC1D72E);  // Brand green
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF009DDC);     // Brand cyan

  // Glassmorphism & Overlays
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color glassHighlight = Color(0x33FFFFFF);
  static const Color modalOverlay = Color(0xCC000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentCyan, blue300],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient highlightGradient = LinearGradient(
    colors: [highlightGreen, green400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [deepSpace, darkNavy, charcoal],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryBlue, accentCyan, highlightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Network/Polygon effect colors
  static const Color networkNode = Color(0xFF0068B3);    // Primary blue
  static const Color networkLine = Color(0x33009DDC);    // Accent cyan with opacity
  static const Color networkGlow = Color(0x66009DDC);    // Accent cyan glow
  static const Color networkHighlight = Color(0xFFC1D72E); // Green highlight

  // ===== LIGHT MODE COLORS =====

  // Light Background Palette
  static const Color lightBg = Color(0xFFFAFBFC);         // Off-white
  static const Color lightBg2 = Color(0xFFF0F3F6);        // Light gray
  static const Color lightBg3 = Color(0xFFE6EAEF);        // Medium gray
  static const Color lightCard = Color(0xFFFFFFFF);       // Pure white

  // Light Mode Text Colors (high contrast)
  static const Color lightText = Color(0xFF0A0E1A);       // Near black
  static const Color lightText2 = Color(0xFF2A3847);      // Dark gray
  static const Color lightText3 = Color(0xFF484F58);      // Medium gray
  static const Color lightTextMuted = Color(0xFF6E7681);  // Muted gray

  // Light Mode Neutral Grays
  static const Color lightGray900 = Color(0xFF0D1117);
  static const Color lightGray800 = Color(0xFF2A3847);
  static const Color lightGray700 = Color(0xFF484F58);
  static const Color lightGray600 = Color(0xFF6E7681);
  static const Color lightGray500 = Color(0xFF8B949E);
  static const Color lightGray400 = Color(0xFFB1BAC4);
  static const Color lightGray300 = Color(0xFFCCCFD3);
  static const Color lightGray200 = Color(0xFFE6EAEF);
  static const Color lightGray100 = Color(0xFFF0F3F6);
}
