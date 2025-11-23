import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PixelatedSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PixelatedSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: isDark ? Colors.white : AppColors.deepSpace,
            fontFamily:
                'Orbitron', // Assuming this font is available or fallback
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: isDark ? AppColors.highlightGreen : AppColors.accentCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
