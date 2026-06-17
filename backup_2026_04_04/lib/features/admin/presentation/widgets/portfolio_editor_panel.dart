import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../portfolio/presentation/providers/portfolio_provider.dart';
import '../../../portfolio/domain/models/portfolio_model.dart';
import '../../../portfolio/data/services/portfolio_migration_service.dart';
import 'portfolio_editor_dialog.dart';

class PortfolioEditorPanel extends ConsumerWidget {
  const PortfolioEditorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final portfoliosAsync = ref.watch(portfoliosProvider);

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
                        Icons.work,
                        color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Portfolio 관리',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                          ),
                        ),
                      ),
                      if (!isMobile) ...[
                        ElevatedButton.icon(
                          onPressed: () async {
                            final migrationService = PortfolioMigrationService();
                            final result = await migrationService.migratePortfolioData();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('마이그레이션 완료: 성공 ${result['success']}개, 실패 ${result['failed']}개'),
                                  backgroundColor: result['failed'] == 0 ? Colors.green : Colors.orange,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.highlightGreen : AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.upload, size: 20),
                          label: const Text('초기 데이터 업로드'),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => const PortfolioEditorDialog(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(isMobile ? '추가' : '새 프로젝트'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Portfolio 프로젝트를 추가/수정/삭제할 수 있습니다.',
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

          // Portfolios List
          portfoliosAsync.when(
            data: (portfolios) {
              if (portfolios.isEmpty) {
                return _buildEmptyState(isDark, isMobile);
              }
              return Column(
                children: portfolios.map((portfolio) => _buildPortfolioCard(context, ref, isDark, isMobile, portfolio)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('오류: $error'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isMobile) {
    return Card(
      color: isDark ? AppColors.charcoal : Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.work_off,
                size: 64,
                color: isDark ? AppColors.gray600 : AppColors.lightGray400,
              ),
              const SizedBox(height: 16),
              Text(
                '프로젝트가 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '새 프로젝트를 추가하여 시작하세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.gray500 : AppColors.lightGray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, WidgetRef ref, bool isDark, bool isMobile, PortfolioModel portfolio) {
    return Card(
      color: isDark ? AppColors.charcoal : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: portfolio.gradientColors.length >= 2
                      ? [
                          _parseColor(portfolio.gradientColors[0]),
                          _parseColor(portfolio.gradientColors[1]),
                        ]
                      : [AppColors.primaryBlue, AppColors.accentCyan],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.folder_special,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Project Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portfolio.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    portfolio.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(isDark, Icons.business, portfolio.company),
                      _buildInfoChip(isDark, Icons.calendar_today, portfolio.year),
                      _buildInfoChip(isDark, Icons.category, portfolio.category),
                    ],
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => PortfolioEditorDialog(portfolio: portfolio),
                    );
                  },
                  color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    _showDeleteConfirmation(context, ref, portfolio);
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(bool isDark, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? AppColors.gray400 : AppColors.lightGray600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.gray400 : AppColors.lightGray600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, PortfolioModel portfolio) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.charcoal : Colors.white,
        title: Text(
          '프로젝트 삭제',
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
          ),
        ),
        content: Text(
          '${portfolio.title}을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(
            color: isDark ? AppColors.gray300 : AppColors.lightGray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(
                color: isDark ? AppColors.gray400 : AppColors.lightGray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(portfoliosNotifierProvider.notifier).deletePortfolio(portfolio.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('프로젝트가 삭제되었습니다'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return AppColors.primaryBlue;
    } catch (e) {
      return AppColors.primaryBlue;
    }
  }
}
