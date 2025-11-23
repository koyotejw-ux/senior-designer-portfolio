import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import 'interactive_geometric_shape.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet =
        size.width >= AppConstants.mobileBreakpoint && size.width < 1000;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Interactive 3D Shape - Responsive Positioning
          if (isDark)
            Positioned(
              // On Mobile/Tablet: Top Right, smaller
              // On Desktop: Right Center, larger
              right: isMobile
                  ? -size.width * 0.1
                  : (isTablet ? 0 : size.width * 0.05),
              top: isMobile
                  ? size.height * 0.1
                  : (isTablet ? size.height * 0.1 : size.height * 0.15),
              bottom: isMobile ? null : size.height * 0.15,
              child: Center(
                child: InteractiveGeometricShape(
                  size: isMobile
                      ? size.width *
                            0.6 // Mobile: 60% width
                      : (isTablet
                            ? size.width * 0.5
                            : size.width * 0.45), // Desktop: 45%
                  isDark: isDark,
                ),
              ),
            ),

          // Main Content - Center Left
          Positioned(
            left: isMobile ? 24 : size.width * 0.1,
            top: 0,
            bottom: 0,
            right: isMobile ? 24 : size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CJW Logo
                SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: isMobile ? 200 : 420,
                    )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 12),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child:
                      Text(
                            'UX/UI Designer',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: isMobile ? 24 : 36,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF8B95A1),
                              letterSpacing: -0.5,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 1000.ms, delay: 300.ms)
                          .slideX(begin: -0.2, end: 0),
                ),
              ],
            ),
          ),

          // Contact Info - Bottom Left
          Positioned(
            left: isMobile ? 24 : size.width * 0.1,
            bottom: 80,
            child:
                Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Email
                        Text(
                          'coyotejw@naver.com',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8B95A1),
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF8B95A1),
                          ),
                        ),

                        const SizedBox(width: 60),

                        // Phone
                        Text(
                          '+82 10 4375 3599',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8B95A1),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 1000.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }
}
