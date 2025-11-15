import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class PortfolioGallerySection extends ConsumerStatefulWidget {
  const PortfolioGallerySection({super.key});

  @override
  ConsumerState<PortfolioGallerySection> createState() => _PortfolioGallerySectionState();
}

class _PortfolioGallerySectionState extends ConsumerState<PortfolioGallerySection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    final projects = [
      {
        'title': 'AIA+ SENIOR MODE',
        'subtitle': '고령자 전용 모드 UX/UI 디자인 시스템',
        'company': 'ING People',
        'year': '2025',
        'category': 'Mobile App • Insurance',
        'description': 'AIA 생명 앱의 고령자 전용 모드 메인 UX 기획 및 디자인 시스템 구축. 보험료 납입, 보험계약대출 상환, 자동부활 신청 등 핵심 GUI 정의.',
        'tags': ['Mobile UX', 'Design System', 'Accessibility', 'Figma'],
        'gradient': [AppColors.accentCyan, AppColors.blue400],
      },
      {
        'title': 'WALLPAD',
        'subtitle': '현대건설 전용 13.3인치 안드로이드 월패드',
        'company': 'Hyundai HT',
        'year': '2021-2023',
        'category': 'IoT Device • Smart Home',
        'description': 'HT 범용 월패드 디자인 시스템 구축. 현대/포스코/금호/한양/한화 등 고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 통합 디자인 시스템 적용.',
        'tags': ['IoT UI/UX', 'Android', 'Design System', 'Figma'],
        'gradient': [AppColors.primaryBlue, AppColors.accentCyan],
      },
      {
        'title': 'HT HOME 2.0',
        'subtitle': '주거전용 스마트홈 통합 앱',
        'company': 'Hyundai HT',
        'year': '2021-2023',
        'category': 'Mobile App • Smart Home',
        'description': 'HT HOME 및 HT Imazu 앱 앱스토어 론칭. 월패드와 통합 연동 최적화 및 사용자 접점 확대.',
        'tags': ['Mobile App', 'iOS', 'Android', 'Smart Home'],
        'gradient': [AppColors.blue400, AppColors.accentCyan],
      },
      {
        'title': 'SOULARK',
        'subtitle': '모바일 게임 UX/UI 디자인',
        'company': 'BluestoneSoft',
        'year': '2016-2017',
        'category': 'Mobile Game',
        'description': 'SOULARK 모바일 게임의 전반적인 UX/UI 개발. Unity3D 기반 GUI 인터랙션 및 애니메이션 설계.',
        'tags': ['Game UI', 'Unity3D', 'Mobile', 'Photoshop'],
        'gradient': [AppColors.highlightGreen, AppColors.accentCyan],
      },
      {
        'title': 'CLOSERS',
        'subtitle': '클로저스 웹사이트 UX/UI 디자인',
        'company': 'NEXON Korea',
        'year': '2014',
        'category': 'Website • Game',
        'description': '클로저스 CBT 반응형 웹사이트 UX/UI 개발. 사내 최초로 PC/태블릿/모바일 대상 반응형 웹 구현 적용.',
        'tags': ['Web Design', 'Responsive', 'Game Promotion', 'HTML/CSS'],
        'gradient': [AppColors.primaryBlue, AppColors.blue400],
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : Colors.white,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    width: 4,
                    height: isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.highlightGreen, AppColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Featured Projects',
                    style: (isMobile ? AppTypography.h3 : AppTypography.h2).copyWith(
                      color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 72),

              // Project Grid/List
              if (isMobile)
                Column(
                  children: projects.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildProjectCard(
                        entry.value,
                        isDark,
                        isMobile,
                        entry.key,
                      ),
                    );
                  }).toList(),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 1 : 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    childAspectRatio: isTablet ? 1.8 : 1.4,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(
                      projects[index],
                      isDark,
                      isMobile,
                      index,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    Map<String, dynamic> project,
    bool isDark,
    bool isMobile,
    int index,
  ) {
    final isSelected = _selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: isSelected
          ? (Matrix4.identity()..setTranslationRaw(0.0, -8.0, 0.0))
          : Matrix4.identity(),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      (project['gradient'] as List<Color>)[0].withValues(alpha: 0.15),
                      (project['gradient'] as List<Color>)[1].withValues(alpha: 0.08),
                    ]
                  : [
                      (project['gradient'] as List<Color>)[0].withValues(alpha: 0.08),
                      (project['gradient'] as List<Color>)[1].withValues(alpha: 0.04),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? (project['gradient'] as List<Color>)[0].withValues(alpha: 0.3)
                  : (project['gradient'] as List<Color>)[0].withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? (project['gradient'] as List<Color>)[0].withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: isSelected ? 30 : 20,
                offset: Offset(0, isSelected ? 12 : 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: project['gradient'] as List<Color>,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  project['category'] as String,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: project['gradient'] as List<Color>,
                ).createShader(bounds),
                child: Text(
                  project['title'] as String,
                  style: AppTypography.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                project['subtitle'] as String,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.gray100 : AppColors.lightText,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // Company & Year
              Text(
                '${project['company']} • ${project['year']}',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.gray100.withValues(alpha: 0.6)
                      : AppColors.lightText2.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                project['description'] as String,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.gray100.withValues(alpha: 0.8)
                      : AppColors.lightText2,
                  height: 1.6,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (project['tags'] as List<String>).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? (project['gradient'] as List<Color>)[0].withValues(alpha: 0.2)
                          : (project['gradient'] as List<Color>)[0].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? (project['gradient'] as List<Color>)[0]
                            : (project['gradient'] as List<Color>)[0].withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: (200 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
