import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/particle_background.dart';
import 'polygon_network_background.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.deepSpace,
                  AppColors.blue900,
                  AppColors.deepSpace,
                ]
              : [
                  const Color(0xFFE8EFF5), // Darker blue-gray
                  const Color(0xFFD0DCE8), // More depth
                  const Color(0xFFE8EFF5),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Particle Background with Polygon Network
          Positioned.fill(
            child: ParticleBackground(
              particleCount: isDark ? 60 : 40,
              particleColor: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
              maxParticleSize: isDark ? 3.0 : 2.5,
              child: Stack(
                children: [
                  // Animated Polygon Network Background (only in dark mode)
                  if (isDark)
                    PolygonNetworkBackground(controller: _controller),

                  // Subtle gradient overlays
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.2,
                        colors: isDark
                            ? [
                                AppColors.accentCyan.withValues(alpha: 0.12),
                                Colors.transparent,
                              ]
                            : [
                                AppColors.primaryBlue.withValues(alpha: 0.08),
                                Colors.transparent,
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content - Premium Layout
          Positioned.fill(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? size.width * 0.9 : 1200,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : isTablet ? 60 : 100,
                    vertical: isMobile ? 60 : 100,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Title - CJW Logo (No box, minimal design)
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: isMobile ? 240 : isTablet ? 360 : 480,
                          height: isMobile ? 80 : isTablet ? 120 : 160,
                          colorFilter: isDark
                              ? null
                              : const ColorFilter.mode(
                                  Color(0xFF0068B3),
                                  BlendMode.srcIn,
                                ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 1000.ms, delay: 200.ms)
                          .scale(begin: const Offset(0.95, 0.95)),

                      SizedBox(height: isMobile ? 48 : 72),

                      // Main Content Group - Tighter grouping
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subtitle - Strong hierarchy
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? [AppColors.accentCyan, AppColors.blue300]
                                  : [AppColors.primaryBlue, AppColors.accentCyan],
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                              'Senior Product Designer',
                              style: (isMobile ? AppTypography.h3 : AppTypography.h1).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 600.ms)
                              .slideY(begin: 0.2, end: 0),

                          SizedBox(height: isMobile ? 20 : 28),

                          // Description - Grouped tightly
                          Container(
                            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 800),
                            child: Text(
                              'AI-Driven Design Systems • Data Analytics • Enterprise UX Strategy',
                              style: AppTypography.bodyLarge.copyWith(
                                color: isDark
                                    ? AppColors.gray100.withValues(alpha: 0.9)
                                    : AppColors.lightGray900,
                                height: 1.7,
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 800.ms)
                              .slideY(begin: 0.2, end: 0),

                          SizedBox(height: isMobile ? 40 : 56),

                          // Premium Capability Chips - Better grouping
                          Wrap(
                            spacing: isMobile ? 12 : 16,
                            runSpacing: isMobile ? 12 : 16,
                            children: [
                              _buildPremiumChip('Design Systems', AppColors.primaryBlue, isDark),
                              _buildPremiumChip('AI/ML Integration', AppColors.highlightGreen, isDark),
                              _buildPremiumChip('Data Analytics', AppColors.accentCyan, isDark),
                              _buildPremiumChip('Enterprise UX', AppColors.blue400, isDark),
                            ]
                                .animate(interval: 100.ms)
                                .fadeIn(duration: 600.ms, delay: 1000.ms)
                                .slideY(begin: 0.2, end: 0),
                          ),
                        ],
                      ),

                      SizedBox(height: isMobile ? 56 : 80),

                      // Premium CTA Buttons - Stronger visual weight
                      Row(
                        children: [
                          _buildPrimaryButton(
                            'View Portfolio',
                            Icons.arrow_forward,
                            isDark,
                            isMobile,
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 1200.ms)
                              .slideX(begin: -0.2, end: 0),
                          SizedBox(width: isMobile ? 12 : 20),
                          _buildSecondaryButton(
                            'Download Resume',
                            Icons.download_rounded,
                            isDark,
                            isMobile,
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 1300.ms)
                              .slideX(begin: -0.2, end: 0),
                        ],
                      ),

                      SizedBox(height: isMobile ? 48 : 72),

                      // Contact Info - Subtle and refined
                      Wrap(
                        spacing: isMobile ? 20 : 40,
                        runSpacing: 20,
                        children: [
                          _buildContactInfo(
                            Icons.email_outlined,
                            AppConstants.email,
                            AppColors.accentCyan,
                            isDark,
                          ),
                          _buildContactInfo(
                            Icons.phone_outlined,
                            AppConstants.phone,
                            AppColors.highlightGreen,
                            isDark,
                          ),
                        ]
                            .animate(interval: 100.ms)
                            .fadeIn(duration: 600.ms, delay: 1400.ms)
                            .slideY(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Scroll Indicator - Minimalist
          Positioned(
            bottom: isMobile ? 32 : 48,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'SCROLL',
                    style: AppTypography.overline.copyWith(
                      color: isDark
                          ? AppColors.blue300.withValues(alpha: 0.5)
                          : AppColors.primaryBlue.withValues(alpha: 0.4),
                      letterSpacing: 3.0,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isDark
                        ? AppColors.blue300.withValues(alpha: 0.5)
                        : AppColors.primaryBlue.withValues(alpha: 0.4),
                    size: 24,
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .moveY(
                        begin: 0,
                        end: 8,
                        duration: 1500.ms,
                        curve: Curves.easeInOut,
                      ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 1600.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.25 : 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: isDark ? color : color.withValues(alpha: 0.9),
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, IconData icon, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 32,
        vertical: isMobile ? 14 : 18,
      ),
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
            label,
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 15 : 16,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white, size: isMobile ? 18 : 20),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 32,
        vertical: isMobile ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? AppColors.primaryBlue.withValues(alpha: 0.3)
              : AppColors.primaryBlue.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 15 : 16,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
            size: isMobile ? 18 : 20,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, Color accentColor, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.gray100 : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
