import 'package:flutter/material.dart';

/// Typography System - Pretendard Font
/// Pretendard: Modern Korean-English sans-serif with excellent readability
/// 가독성 향상을 위해 폰트 크기와 굵기 최적화
class AppTypography {
  AppTypography._();

  // Pretendard font family (loaded from web CDN in index.html)
  static const String pretendard = 'Pretendard';

  static String get displayFont => pretendard;
  static String get bodyFont => pretendard;
  static String get monoFont => 'monospace';

  // Display Styles (Hero sections, headlines) - 더 굵고 크게
  static TextStyle display1 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 96,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: -2.0,
  );

  static TextStyle display2 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 72,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.5,
  );

  static TextStyle display3 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.0,
  );

  // Headline Styles - 명확한 계층
  static TextStyle h1 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static TextStyle h3 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle h4 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle h5 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle h6 = const TextStyle(
    fontFamily: pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Styles - 가독성 향상 (크기 증가, 명확한 굵기)
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.7,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.7,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );

  // Label Styles - 더 명확하게
  static TextStyle labelLarge = const TextStyle(
    fontFamily: pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // Special Styles
  static TextStyle caption = const TextStyle(
    fontFamily: pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: pretendard,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1.5,
  );

  static TextStyle mono = const TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Button Styles - 더 굵고 명확하게
  static TextStyle buttonLarge = const TextStyle(
    fontFamily: pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = const TextStyle(
    fontFamily: pretendard,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall = const TextStyle(
    fontFamily: pretendard,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
