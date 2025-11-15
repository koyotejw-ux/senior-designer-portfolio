import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

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
                        colors: [AppColors.primaryBlue, AppColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'About',
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

              // Main Content Grid
              isMobile
                  ? Column(
                      children: [
                        _buildStoryCard(isDark),
                        const SizedBox(height: 32),
                        _buildStatsGrid(isDark, isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildStoryCard(isDark),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 2,
                          child: _buildStatsGrid(isDark, isMobile),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
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
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Leader',
            style: AppTypography.h4.copyWith(
              color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '기획부터 디자인, 협업까지 사용자 중심의 해결을 먼저 생각하는 디자이너입니다.',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.gray100 : AppColors.lightText,
              height: 1.8,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'NEXON, 현대HT, 블루스톤소프트 등 게임 엔터테인먼트부터 제조 디바이스까지 다양한 사업군에서 UX/UI 디자인을 수행해왔습니다. Web, Android, iOS, Linux 등 여러 플랫폼 환경에 맞춰 UX 기획부터 UI 설계, Hi-Fi 프로토타이핑, 디자인 시스템 구축까지 전반적인 과정을 수행합니다.',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark
                  ? AppColors.gray100.withValues(alpha: 0.8)
                  : AppColors.lightText2,
              height: 1.8,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '최근에는 Flutter, ChatGPT AI Studio, Stable Diffusion 등의 도구를 디자인 업무에 적극 활용하며, 개발자와의 원활한 협업을 위해 UI를 직접 구현하는 시도도 병행하고 있습니다.',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark
                  ? AppColors.gray100.withValues(alpha: 0.8)
                  : AppColors.lightText2,
              height: 1.8,
              fontSize: 16,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: 200.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatsGrid(bool isDark, bool isMobile) {
    final stats = [
      {'number': '19', 'label': 'Years\nExperience'},
      {'number': '100+', 'label': 'Projects\nCompleted'},
      {'number': '350만+', 'label': 'Active\nUsers'},
      {'number': '100%', 'label': 'Project\nCompletion'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.primaryBlue.withValues(alpha: 0.15),
                      AppColors.accentCyan.withValues(alpha: 0.1),
                    ]
                  : [
                      AppColors.primaryBlue.withValues(alpha: 0.08),
                      AppColors.accentCyan.withValues(alpha: 0.05),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? AppColors.primaryBlue.withValues(alpha: 0.25)
                  : AppColors.primaryBlue.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.accentCyan],
                ).createShader(bounds),
                child: Text(
                  stat['number']!,
                  style: AppTypography.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 32 : 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat['label']!,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.gray100 : AppColors.lightText,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: (300 + index * 100).ms)
            .slideY(begin: 0.1, end: 0);
      },
    );
  }
}
