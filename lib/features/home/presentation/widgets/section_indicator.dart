import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';

class SectionIndicator extends ConsumerWidget {
  final int currentIndex;
  final int totalSections;
  final Function(int) onSelect;

  const SectionIndicator({
    super.key,
    required this.currentIndex,
    required this.totalSections,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Positioned(
      right: 40,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalSections, (index) {
            final isSelected = index == currentIndex;
            return GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 12, // Small dot
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (isDark
                            ? AppColors.highlightGreen
                            : AppColors.primaryBlue)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                              ? AppColors.highlightGreen
                              : AppColors.primaryBlue)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.3)),
                    width: 2,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
