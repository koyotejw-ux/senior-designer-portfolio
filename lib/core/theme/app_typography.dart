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
  static const TextStyle display1 = TextStyle(
    fontFamily: pretendard,
    fontSize: 96,
    fontWeight: FontWeight.w800,  // Extra Bold for visibility
    height: 1.0,
    letterSpacing: -2.0,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: pretendard,
    fontSize: 72,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.5,
  );

  static const TextStyle display3 = TextStyle(
    fontFamily: pretendard,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.0,
  );

  // Headline Styles - 명확한 계층
  static const TextStyle h1 = TextStyle(
    fontFamily: pretendard,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: pretendard,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: pretendard,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: pretendard,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: pretendard,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: pretendard,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Styles - 가독성 향상 (크기 증가, 명확한 굵기)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: pretendard,
    fontSize: 20,  // 18 → 20
    fontWeight: FontWeight.w500,  // w400 → w500
    height: 1.7,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: pretendard,
    fontSize: 18,  // 16 → 18
    fontWeight: FontWeight.w500,  // w400 → w500
    height: 1.7,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: pretendard,
    fontSize: 16,  // 14 → 16
    fontWeight: FontWeight.w500,  // w400 → w500
    height: 1.6,
  );

  // Label Styles - 더 명확하게
  static const TextStyle labelLarge = TextStyle(
    fontFamily: pretendard,
    fontSize: 16,  // 14 → 16
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: pretendard,
    fontSize: 14,  // 12 → 14
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: pretendard,
    fontSize: 12,  // 11 → 12
    fontWeight: FontWeight.w600,  // w500 → w600
    height: 1.4,
    letterSpacing: 0.5,
  );

  // Special Styles
  static const TextStyle caption = TextStyle(
    fontFamily: pretendard,
    fontSize: 14,  // 12 → 14
    fontWeight: FontWeight.w500,  // w400 → w500
    height: 1.4,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: pretendard,
    fontSize: 12,  // 10 → 12
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.4,
    letterSpacing: 1.5,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Button Styles - 더 굵고 명확하게
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: pretendard,
    fontSize: 18,  // 16 → 18
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: pretendard,
    fontSize: 16,  // 14 → 16
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: pretendard,
    fontSize: 14,  // 12 → 14
    fontWeight: FontWeight.w700,  // w600 → w700
    height: 1.2,
    letterSpacing: 0.5,
  );
}
