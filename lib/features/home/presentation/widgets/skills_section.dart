import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/providers/content_provider.dart';
import 'holographic_card.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final skillsAsync = ref.watch(skillsProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
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
                        colors: [
                          AppColors.accentCyan,
                          AppColors.highlightGreen,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Expertise',
                    style: (isMobile ? AppTypography.h3 : AppTypography.h2)
                        .copyWith(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 72),

              // Skills Grid
              skillsAsync.when(
                data: (skills) =>
                    _buildSkillsGrid(skills, isDark, isMobile, isTablet),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error loading skills: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(
    List<dynamic> skillsData,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile
            ? 1
            : isTablet
            ? 2
            : 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isMobile ? 1.2 : 1.4,
      ),
      itemCount: skillsData.length,
      itemBuilder: (context, index) {
        final skill = skillsData[index];
        IconData icon = Icons.star;
        if (skill.title.contains('Design')) {
          icon = Icons.design_services_outlined;
        } else if (skill.title.contains('AI') ||
            skill.title.contains('Intelligence')) {
          icon = Icons.psychology_outlined;
        } else if (skill.title.contains('Data')) {
          icon = Icons.analytics_outlined;
        } else if (skill.title.contains('Development') ||
            skill.title.contains('Flutter')) {
          icon = Icons.code_outlined;
        }

        // Color rotation
        final colors = [
          AppColors.primaryBlue,
          AppColors.highlightGreen,
          AppColors.accentCyan,
          AppColors.blue400,
        ];
        final color = colors[index % colors.length];

        return _buildSkillCard(
          skill.title,
          icon,
          color,
          skill.skills,
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
    return HolographicCard(
      title: title,
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'SYSTEM CAPABILITY',
                style: TextStyle(
                  color: accentColor.withValues(alpha: 0.6),
                  fontFamily: 'Courier',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Skills List
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
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
