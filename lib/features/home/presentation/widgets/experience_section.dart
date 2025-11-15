import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blue900 : const Color(0xFFF5F8FA),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
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
                    'Experience',
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

              // Experience Timeline
              _buildTimeline(isDark, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(bool isDark, bool isMobile) {
    final experiences = [
      {
        'year': '2025.01 - 2025.06',
        'company': 'ING People (아이엔지피플)',
        'role': 'UX Manager',
        'description': 'AIA+ 시니어 모드 프로젝트 기획 및 UX 설계, 50+ 앱 분석 및 인사이트 도출',
        'tags': ['Senior UX', 'Research', 'Mobile App'],
      },
      {
        'year': '2018 - 2024',
        'company': 'Hyundai HT (현대에이치티)',
        'role': 'Senior Researcher',
        'description': 'HT 안드로이드 월패드 라인업 UX 설계 프로세스 체계화 및 디자인 시스템 구축',
        'tags': ['IoT', 'Design System', 'Android'],
      },
      {
        'year': '2016 - 2017',
        'company': 'BluestoneSoft (블루스톤소프트)',
        'role': 'Lead Researcher',
        'description': 'SOULARK 모바일 RPG 프로젝트 UI/UX 설계 및 디자인 시스템 구축',
        'tags': ['Mobile Game', 'RPG', 'UI System'],
      },
      {
        'year': '2010 - 2015',
        'company': 'NEXON Korea (넥슨코리아)',
        'role': 'Manager',
        'description': '영웅시대30, 클로저스, 피파온라인3 등 게임 UX/UI 디자인 및 웹사이트 운영',
        'tags': ['Game UI/UX', 'Web Design', 'Unity3D'],
      },
      {
        'year': '2008 - 2010',
        'company': 'YNK Korea (YNK코리아)',
        'role': 'Assistant Manager',
        'description': '로한, 크레파스 등 게임 웹사이트 UX/UI 디자인 및 Flash 웹게임 개발',
        'tags': ['Web Design', 'Flash AS2.0', 'Promotion'],
      },
    ];

    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final exp = entry.value;
        return _buildExperienceCard(
          exp['year'] as String,
          exp['company'] as String,
          exp['role'] as String,
          exp['description'] as String,
          exp['tags'] as List<String>,
          isDark,
          isMobile,
          index,
        );
      }).toList(),
    );
  }

  Widget _buildExperienceCard(
    String year,
    String company,
    String role,
    String description,
    List<String> tags,
    bool isDark,
    bool isMobile,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.accentCyan],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              if (index < 2)
                Container(
                  width: 2,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryBlue.withValues(alpha: 0.3),
                        AppColors.accentCyan.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 24),

          // Content Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoal.withValues(alpha: 0.5) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.primaryBlue.withValues(alpha: 0.2)
                      : AppColors.lightGray300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.highlightGreen.withValues(alpha: 0.2),
                          AppColors.accentCyan.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.highlightGreen.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      year,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.highlightGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Company & Role
                  Text(
                    company,
                    style: AppTypography.h5.copyWith(
                      color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    role,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.gray100.withValues(alpha: 0.8)
                          : AppColors.lightText2,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryBlue.withValues(alpha: 0.12)
                              : AppColors.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.gray100 : AppColors.lightText,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (200 + index * 150).ms)
        .slideX(begin: 0.1, end: 0);
  }
}
