import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

class ScrollProgressIndicator extends ConsumerWidget {
  final ScrollController scrollController;

  const ScrollProgressIndicator({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final maxScroll = scrollController.hasClients
            ? scrollController.position.maxScrollExtent
            : 0.0;
        final progress = scrollController.hasClients && maxScroll > 0
            ? (scrollController.offset / maxScroll).clamp(0.0, 1.0)
            : 0.0;

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryBlue,
                  AppColors.accentCyan,
                  AppColors.highlightGreen,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentCyan.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.accentCyan,
                      AppColors.highlightGreen,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircularScrollIndicator extends ConsumerWidget {
  final ScrollController scrollController;

  const CircularScrollIndicator({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final maxScroll = scrollController.hasClients
            ? scrollController.position.maxScrollExtent
            : 0.0;
        final progress = scrollController.hasClients && maxScroll > 0
            ? (scrollController.offset / maxScroll).clamp(0.0, 1.0)
            : 0.0;

        return Positioned(
          bottom: 32,
          right: 32,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.charcoal.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background circle
                Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 3,
                      backgroundColor: isDark
                          ? AppColors.blue900.withValues(alpha: 0.3)
                          : AppColors.lightGray300,
                    ),
                  ),
                ),
                // Progress circle
                Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                // Percentage text
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
