import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

/// Professional App Header with scroll-based logo reveal
class AppHeader extends ConsumerStatefulWidget {
  final bool showLogo;

  const AppHeader({
    super.key,
    required this.showLogo,
  });

  @override
  ConsumerState<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends ConsumerState<AppHeader> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      height: isMobile ? 64 : 80,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.deepSpace.withValues(alpha: widget.showLogo ? 0.95 : 0.0)
            : AppColors.lightBg.withValues(alpha: widget.showLogo ? 0.98 : 0.0),
        border: widget.showLogo
            ? Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.primaryBlue.withValues(alpha: 0.2)
                      : AppColors.lightGray300.withValues(alpha: 0.5),
                  width: 1,
                ),
              )
            : null,
        boxShadow: widget.showLogo
            ? [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo (animated reveal on scroll)
            AnimatedOpacity(
              opacity: widget.showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedSlide(
                offset: widget.showLogo ? Offset.zero : const Offset(-0.3, 0),
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
                  _buildNavLink(context, 'Home', '/', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Resume', '/resume', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Documents', '/documents', isDark),
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

  Widget _buildNavLink(BuildContext context, String label, String path, bool isDark) {
    return TextButton(
      onPressed: () => context.go(path),
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
