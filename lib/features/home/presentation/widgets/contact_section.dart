import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 100 : 140,
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.deepSpace, AppColors.blue900]
              : [Colors.white, const Color(0xFFF5F8FA)],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Section Header
              Text(
                "Let's Work Together",
                style: (isMobile ? AppTypography.h3 : AppTypography.h1).copyWith(
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 16 : 24),

              // Subtitle
              Text(
                '대기업 프로젝트 경험과 AI/데이터 전문성을 갖춘 시니어 디자이너와 함께하세요',
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.gray100.withValues(alpha: 0.8)
                      : AppColors.lightText2,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 64),

              // Contact Cards Grid
              isMobile
                  ? Column(
                      children: [
                        _buildContactCard(
                          Icons.email_outlined,
                          'Email',
                          AppConstants.email,
                          AppColors.accentCyan,
                          isDark,
                          0,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          Icons.phone_outlined,
                          'Phone',
                          AppConstants.phone,
                          AppColors.highlightGreen,
                          isDark,
                          1,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          Icons.location_on_outlined,
                          'Location',
                          'Seoul, South Korea',
                          AppColors.primaryBlue,
                          isDark,
                          2,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildContactCard(
                            Icons.email_outlined,
                            'Email',
                            AppConstants.email,
                            AppColors.accentCyan,
                            isDark,
                            0,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildContactCard(
                            Icons.phone_outlined,
                            'Phone',
                            AppConstants.phone,
                            AppColors.highlightGreen,
                            isDark,
                            1,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildContactCard(
                            Icons.location_on_outlined,
                            'Location',
                            'Seoul, South Korea',
                            AppColors.primaryBlue,
                            isDark,
                            2,
                          ),
                        ),
                      ],
                    ),

              SizedBox(height: isMobile ? 48 : 64),

              // CTA Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.accentCyan],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Schedule a Call',
                      style: AppTypography.h6.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: isMobile ? 64 : 80),

              // Footer
              Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.primaryBlue.withValues(alpha: 0.2)
                          : AppColors.lightGray300,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '© 2025 Jaewoong Jung. All rights reserved.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.gray100.withValues(alpha: 0.5)
                        : AppColors.lightText2.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    Color accentColor,
    bool isDark,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.5) : Colors.white,
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
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.2),
                  accentColor.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: isDark
                  ? AppColors.gray100.withValues(alpha: 0.7)
                  : AppColors.lightText2,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (400 + index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }
}
