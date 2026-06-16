import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import 'interactive_geometric_shape.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with SingleTickerProviderStateMixin {
  late PageController _tickerController;
  int _currentTickerIndex = 0;
  Timer? _tickerTimer;

  final List<String> _tickerItems = [
    "PRODUCT STRATEGY & UX/UI DESIGN",
    "ENTERPRISE MES & ERP SYSTEM DESIGN",
    "AI WORKFLOW INTEGRATION & FIGMA STANDARD",
    "CROSS-PLATFORM INTERACTION ARCHITECTURE",
    "B2B & B2C PRODUCT ARCHITECTURE",
  ];

  @override
  void initState() {
    super.initState();
    _tickerController = PageController();
    _tickerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentTickerIndex = (_currentTickerIndex + 1) % _tickerItems.length;
      });
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet =
        size.width >= AppConstants.mobileBreakpoint && size.width < 1000;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    // Mobile Layout
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
                const SizedBox(height: 80),
                // 3D Object at top-center
                if (isDark)
                  SizedBox(
                    height: size.height * 0.35,
                    child: Center(
                      child: InteractiveGeometricShape(
                        size: size.width * 0.65,
                        isDark: isDark,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Content below - centered
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo/Name with gradient styling
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColors.accentCyan,
                            AppColors.primaryBlue,
                            Color(0xFFFF007F), // Neon Pink
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'JAEWOONG JUNG',
                          style: GoogleFonts.outfit(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 1000.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 12),

                      // Glassmorphic Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'SENIOR PRODUCT DESIGNER',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 1000.ms, delay: 200.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Animated Ticker
                      SizedBox(
                        height: 35,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.4),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutQuad,
                                )),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            _tickerItems[_currentTickerIndex],
                            key: ValueKey<int>(_currentTickerIndex),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8B95A1),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 1000.ms, delay: 400.ms),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      );
    }

    // Desktop/Tablet Layout
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
              right: isTablet ? 40 : size.width * 0.08,
              top: isTablet ? size.height * 0.1 : size.height * 0.12,
              bottom: size.height * 0.12,
              child: Center(
                child: InteractiveGeometricShape(
                  size: isTablet ? size.width * 0.42 : size.width * 0.42,
                  isDark: isDark,
                ),
              ),
            ),

          // Main Content - Center Left
          Positioned(
            left: size.width * 0.1,
            top: 0,
            bottom: 0,
            right: size.width * 0.45,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glassmorphic Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      ),
                      child: Text(
                        'SENIOR PRODUCT DESIGNER',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.0,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 24),

                    // Premium Bold Typography Name with Neon Gradient
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Colors.white,
                          AppColors.accentCyan,
                          AppColors.primaryBlue,
                          Color(0xFFFF007F), // Neon Pink
                        ],
                        stops: [0.0, 0.4, 0.75, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'JAEWOONG\nJUNG',
                        style: GoogleFonts.outfit(
                          fontSize: isTablet ? 64 : 84,
                          fontWeight: FontWeight.w900,
                          height: 0.95,
                          letterSpacing: -2.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 150.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 28),

                    // Animated Skill/Role Ticker
                    SizedBox(
                      height: 40,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.3, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutQuad,
                              )),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _tickerItems[_currentTickerIndex],
                          key: ValueKey<int>(_currentTickerIndex),
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9EA4B0),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 350.ms),
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
