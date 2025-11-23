import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';

class ResumeEditorPanel extends ConsumerStatefulWidget {
  const ResumeEditorPanel({super.key});

  @override
  ConsumerState<ResumeEditorPanel> createState() => _ResumeEditorPanelState();
}

class _ResumeEditorPanelState extends ConsumerState<ResumeEditorPanel> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            color: isDark ? AppColors.charcoal : Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Resume 편집',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Resume 섹션의 내용을 편집할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Placeholder Content
          Card(
            color: isDark ? AppColors.charcoal : Colors.white,
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction,
                      size: 64,
                      color: isDark ? AppColors.gray600 : AppColors.lightGray400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '준비 중입니다',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resume 편집 기능이 곧 제공됩니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.gray500 : AppColors.lightGray500,
                      ),
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
