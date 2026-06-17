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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D Object at top-center
                if (isDark)
                  SizedBox(
                    height: size.height * 0.3,
                    child: Center(
                      child: InteractiveGeometricShape(
                        size: size.width * 0.6,
                        isDark: isDark,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

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

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Desktop/Tablet: Original horizontal layout
    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Interactive 3D Shape - Right side
          if (isDark)
            Positioned(
              right: isTablet ? 80 : size.width * 0.08,
              top: isTablet ? size.height * 0.1 : size.height * 0.15,
              bottom: size.height * 0.15,
              child: Center(
                child: InteractiveGeometricShape(
                  size: isTablet ? size.width * 0.35 : size.width * 0.38,
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
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
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
            ),
          ),

        ],
      ),
    );
  }
}
