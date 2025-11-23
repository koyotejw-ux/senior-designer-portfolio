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

    // Mobile: Vertical layout with 3D object on top
    if (isMobile) {
      return Container(
        height: size.height,
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3D Object at top-center
            if (isDark)
              SizedBox(
                height: size.height * 0.35,
                child: Center(
                  child: InteractiveGeometricShape(
                    size: size.width * 0.7,
                    isDark: isDark,
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // Content below - centered
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  SvgPicture.asset('assets/images/logo.svg', width: 240)
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                        'UX/UI Designer',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF8B95A1),
                          letterSpacing: -0.5,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 300.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 40),

                  // Contact Info
                  Column(
                        children: [
                          Text(
                            'coyotejw@naver.com',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8B95A1),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF8B95A1),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '+82 10 4375 3599',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8B95A1),
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Desktop/Tablet: Original horizontal layout
    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Interactive 3D Shape - Right side
          if (isDark)
            Positioned(
              right: isTablet ? 0 : size.width * 0.05,
              top: isTablet ? size.height * 0.1 : size.height * 0.15,
              bottom: size.height * 0.15,
              child: Center(
                child: InteractiveGeometricShape(
                  size: isTablet ? size.width * 0.5 : size.width * 0.45,
                  isDark: isDark,
                ),
              ),
            ),

          // Main Content - Center Left
          Positioned(
            left: size.width * 0.1,
            top: 0,
            bottom: 0,
            right: size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SvgPicture.asset('assets/images/logo.svg', width: 420)
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
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF8B95A1),
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
            left: size.width * 0.1,
            bottom: 80,
            child:
                Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'coyotejw@naver.com',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8B95A1),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF8B95A1),
                          ),
                        ),
                        const SizedBox(width: 60),
                        Text(
                          '+82 10 4375 3599',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8B95A1),
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
