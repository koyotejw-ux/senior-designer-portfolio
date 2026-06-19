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

  void _showMobileMenu(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepSpace : Colors.white,
          borderRadius: BorderRadius.zero, // Rectilinear sharp corners
          border: Border.all(
            color: isDark
                ? AppColors.primaryBlue.withValues(alpha: 0.3)
                : AppColors.lightGray300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.gray100.withValues(alpha: 0.3)
                    : AppColors.lightGray500,
                borderRadius: BorderRadius.zero, // Rectilinear pull handle
              ),
            ),
            _buildBottomSheetItem(context, 'About', isDark),
            _buildBottomSheetItem(context, 'Portfolio', isDark),
            _buildBottomSheetItem(context, 'Experience', isDark),
            _buildBottomSheetItem(context, 'Resume', isDark),
            _buildBottomSheetItem(context, 'Contact', isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(
    BuildContext context,
    String label,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (onMenuClick != null) {
          onMenuClick!(label);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.gray100 : AppColors.lightText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isMobile ? 60 : 80,
      decoration: BoxDecoration(
        color: showLogo
            ? (isDark
                  ? AppColors.deepSpace.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.9))
            : Colors.transparent,
        border: showLogo
            ? Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedOpacity(
              opacity: showLogo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedSlide(
                offset: showLogo ? Offset.zero : const Offset(-0.3, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: GestureDetector(
                  onTap: () {
                    if (onMenuClick != null) {
                      onMenuClick!('Home');
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: isMobile ? 70 : 85,
                    height: isMobile ? 23 : 28,
                  ),
                ),
              ),
            ),

            if (isMobile)
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? AppColors.gray100 : AppColors.lightText,
                  size: 28,
                ),
                onPressed: () => _showMobileMenu(context, isDark),
              )
            else
              Row(
                children: [
                  _buildNavLink(context, 'About', '/about', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Portfolio', '/portfolio', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Experience', '/experience', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Resume', '/resume', isDark),
                  const SizedBox(width: 32),
                  _buildNavLink(context, 'Contact', '/contact', isDark),
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
