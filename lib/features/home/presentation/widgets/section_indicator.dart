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

  static const List<String> sectionNames = [
    "01.HERO_SYS",
    "02.RESUME_DB",
    "03.CAREER_EXP",
    "04.ABOUT_ME",
    "05.FEAT_PORT",
    "06.SYS_CONN",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final accentColor = isDark ? AppColors.highlightGreen : AppColors.primaryBlue;

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        // Connecting circuit line
        Positioned(
          right: 3.5,
          child: Container(
            width: 1.0,
            height: (totalSections * 36.0) - 24,
            color: accentColor.withValues(alpha: 0.15),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(totalSections, (index) {
            final isSelected = index == currentIndex;
            return GestureDetector(
              onTap: () => onSelect(index),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Active Text Label
                      AnimatedOpacity(
                        opacity: isSelected ? 0.9 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: isSelected
                            ? Text(
                                sectionNames[index],
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 8.5,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected ? accentColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
