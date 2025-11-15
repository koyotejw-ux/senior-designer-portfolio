# 브랜드 컬러 강화 업데이트 가이드

## 🎨 완료된 작업

1. ✅ CI 로고 복사: `assets/images/logo.svg`
2. ✅ flutter_svg 패키지 설치
3. ✅ 브랜드 컬러 시스템 구축
4. ✅ Noto Sans KR 폰트 적용
5. ✅ 개인정보 업데이트 (정재웅)

## 🔧 적용할 컬러 강화

### 1. Hero Section에 로고 추가

`lib/features/home/presentation/widgets/hero_section.dart` 상단에 추가:

```dart
import 'package:flutter_svg/flutter_svg.dart';
```

Stack의 children에 로고 추가 (Positioned.fill 다음):

```dart
Positioned(
  top: 100,
  right: isMobile ? 20 : 80,
  child: SvgPicture.asset(
    'assets/images/logo.svg',
    width: isMobile ? 120 : 200,
    height: isMobile ? 40 : 60,
  ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideX(begin: 0.3, end: 0),
),
```

### 2. 그라데이션 배경 강화

기존 배경을 다음으로 교체:

```dart
decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.deepSpace,
      AppColors.blue900,  // 더 진한 파랑 추가
      AppColors.deepSpace,
    ],
  ),
),
```

### 3. 컬러풀한 Capability Chips

`_buildCapabilityChip` 메서드 업데이트:

```dart
Widget _buildCapabilityChip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppConstants.spacingL,
      vertical: AppConstants.spacingM,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.1),
        ],
      ),
      border: Border.all(color: color, width: 2),
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Text(
      label,
      style: AppTypography.labelLarge.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
```

Chips 호출 시 각각 다른 컬러 사용:

```dart
_buildCapabilityChip('Design Systems', AppColors.primaryBlue),
_buildCapabilityChip('Data-Driven Decisions', AppColors.accentCyan),
_buildCapabilityChip('AI/ML Integration', AppColors.highlightGreen),
_buildCapabilityChip('User Research', AppColors.blue400),
```

### 4. 그라데이션 버튼

View Portfolio 버튼을 Container로 감싸기:

```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryBlue.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: ElevatedButton.icon(
    onPressed: () {},
    icon: const Icon(Icons.work_outline, color: Colors.white),
    label: const Text('View Portfolio', style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    ),
  ),
),
```

Download Resume 버튼:

```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.highlightGreen, width: 2),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.highlightGreen.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(Icons.download, color: AppColors.highlightGreen),
    label: Text('Download Resume', style: TextStyle(color: AppColors.highlightGreen)),
    style: OutlinedButton.styleFrom(
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    ),
  ),
),
```

### 5. Contact Info 컬러

`_buildContactInfo` 메서드에 color 파라미터 추가:

```dart
Widget _buildContactInfo(IconData icon, String text, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: AppConstants.spacingS),
      Text(text, style: AppTypography.bodyMedium.copyWith(color: AppColors.gray200)),
    ],
  );
}
```

호출 시:

```dart
_buildContactInfo(Icons.email, AppConstants.email, AppColors.accentCyan),
_buildContactInfo(Icons.phone, AppConstants.phone, AppColors.highlightGreen),
```

### 6. 스크롤 인디케이터 컬러

```dart
Text(
  'SCROLL TO EXPLORE',
  style: AppTypography.overline.copyWith(color: AppColors.blue300),
),
const SizedBox(height: AppConstants.spacingS),
Icon(Icons.keyboard_arrow_down, color: AppColors.accentCyan, size: 32)
```

## 🚀 적용 후 실행

```bash
cd senior_designer_portfolio
flutter run -d chrome --web-port 8082
```

## 📊 브랜드 컬러 참조

```dart
AppColors.primaryBlue      // #0068B3
AppColors.accentCyan       // #009DDC
AppColors.highlightGreen   // #C1D72E
AppColors.blue900          // #003D6B (어두운 파랑)
AppColors.blue400          // #33B3E5 (밝은 파랑)
AppColors.blue300          // #66C9ED (매우 밝은 파랑)
AppColors.blue200          // #99DFF5 (하늘색)
```

## ✨ 결과

- 🎨 CI 로고가 우측 상단에 표시
- 💙 그라데이션 배경으로 깊이감 추가
- 🌈 각 요소별로 브랜드 컬러 적용
- ✨ 네온 글로우 효과로 미래지향적 느낌
- 🎯 모노톤에서 벗어난 생동감 있는 UI
