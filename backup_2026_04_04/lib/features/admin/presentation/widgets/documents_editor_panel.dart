import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../documents/presentation/providers/documents_provider.dart';
import '../../../documents/domain/models/document_model.dart';
import 'document_editor_dialog.dart';

class DocumentsEditorPanel extends ConsumerWidget {
  const DocumentsEditorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final documentsAsync = ref.watch(documentsProvider);

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
                        Icons.folder,
                        color: isDark ? AppColors.highlightGreen : AppColors.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Documents 관리',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => const DocumentEditorDialog(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(isMobile ? '추가' : '새 문서'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '이력서, 자기소개서, 경력증명서를 추가/수정/삭제할 수 있습니다.',
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

          // Documents List
          documentsAsync.when(
            data: (documents) {
              if (documents.isEmpty) {
                return _buildEmptyState(isDark, isMobile);
              }
              return Column(
                children: documents.map((doc) => _buildDocumentCard(context, ref, isDark, isMobile, doc)).toList(),
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
                Icons.folder_open,
                size: 64,
                color: isDark ? AppColors.gray600 : AppColors.lightGray400,
              ),
              const SizedBox(height: 16),
              Text(
                '문서가 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '새 문서를 추가하여 시작하세요.',
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

  Widget _buildDocumentCard(BuildContext context, WidgetRef ref, bool isDark, bool isMobile, DocumentModel doc) {
    return Card(
      color: isDark ? AppColors.charcoal : Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          Icons.description,
          color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
        ),
        title: Text(
          doc.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.gray100 : AppColors.lightGray900,
          ),
        ),
        subtitle: Text(
          '${doc.type.displayName} • v${doc.version}',
          style: TextStyle(
            color: isDark ? AppColors.gray400 : AppColors.lightGray600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => DocumentEditorDialog(document: doc),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(documentsNotifierProvider.notifier).deleteDocument(doc.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
