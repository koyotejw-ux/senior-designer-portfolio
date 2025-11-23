import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

class AppHeader extends ConsumerWidget {
  final bool showLogo;
  final Function(String)? onMenuClick;

  const AppHeader({super.key, required this.showLogo, this.onMenuClick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isMobile ? 60 : 80,
      color: showLogo
          ? (isDark
                ? AppColors.deepSpace.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9))
          : Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo (animated reveal on scroll)
            AnimatedOpacity(
              opacity: showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedSlide(
                offset: showLogo ? Offset.zero : const Offset(-0.3, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: isMobile ? 100 : 140,
                  height: isMobile ? 33 : 47,
                ),
              ),
            ),

            // Navigation + Theme Toggle
            Row(
              children: [
                // Navigation Menu (desktop only)
                if (!isMobile) ...[
                  _buildNavLink(context, 'Resume', '/resume', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Experience', '/experience', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'About', '/about', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Portfolio', '/portfolio', isDark),
                  const SizedBox(width: 40),
                ],

                // Theme Toggle Icon Button
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.charcoal.withValues(alpha: 0.5)
                        : AppColors.lightCard,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.primaryBlue.withValues(alpha: 0.3)
                          : AppColors.primaryBlue.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.primaryBlue.withValues(alpha: 0.2)
                            : AppColors.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          ref.read(themeModeProvider.notifier).toggleTheme(),
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 10 : 12),
                        child: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          size: isMobile ? 20 : 24,
                          color: isDark
                              ? AppColors.highlightGreen
                              : AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(
    BuildContext context,
    String label,
    String path,
    bool isDark,
  ) {
    return TextButton(
      onPressed: () {
        if (onMenuClick != null) {
          // All these items are now sections on the home page
          onMenuClick!(label);
        } else {
          context.go(path);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: isDark ? AppColors.gray100 : AppColors.lightText,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.gray100 : AppColors.lightText,
        ),
      ),
    );
  }
}
