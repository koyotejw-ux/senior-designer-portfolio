import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

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
        color: isDark ? AppColors.deepSpace : Colors.white,
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
                        colors: [AppColors.accentCyan, AppColors.highlightGreen],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Expertise',
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

              // Skills Grid
              _buildSkillsGrid(isDark, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(bool isDark, bool isMobile, bool isTablet) {
    final skillCategories = [
      {
        'title': 'Design Systems',
        'icon': Icons.design_services_outlined,
        'color': AppColors.primaryBlue,
        'skills': ['Figma', 'Adobe XD', 'Sketch', 'Design Tokens', 'Component Libraries']
      },
      {
        'title': 'AI/ML Integration',
        'icon': Icons.psychology_outlined,
        'color': AppColors.highlightGreen,
        'skills': ['TensorFlow', 'AutoML', 'Generative AI', 'Neural Networks', 'Model Training']
      },
      {
        'title': 'Data Analytics',
        'icon': Icons.analytics_outlined,
        'color': AppColors.accentCyan,
        'skills': ['Google Analytics', 'Mixpanel', 'Amplitude', 'Data Visualization', 'A/B Testing']
      },
      {
        'title': 'Development',
        'icon': Icons.code_outlined,
        'color': AppColors.blue400,
        'skills': ['React', 'Flutter', 'TypeScript', 'HTML/CSS', 'Git']
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : isTablet ? 2 : 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isMobile ? 1.3 : 1.5,
      ),
      itemCount: skillCategories.length,
      itemBuilder: (context, index) {
        final category = skillCategories[index];
        return _buildSkillCard(
          category['title'] as String,
          category['icon'] as IconData,
          category['color'] as Color,
          category['skills'] as List<String>,
          isDark,
          index,
        );
      },
    );
  }

  Widget _buildSkillCard(
    String title,
    IconData icon,
    Color accentColor,
    List<String> skills,
    bool isDark,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.5)
            : const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? accentColor.withValues(alpha: 0.2)
              : accentColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.2),
                      accentColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h5.copyWith(
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Skills List
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? accentColor.withValues(alpha: 0.12)
                        : accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: accentColor.withValues(alpha: isDark ? 0.25 : 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.gray100 : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (200 + index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }
}
