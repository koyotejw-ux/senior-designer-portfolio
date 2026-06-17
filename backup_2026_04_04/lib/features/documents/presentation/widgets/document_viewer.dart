import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/document_model.dart';

class DocumentViewer extends ConsumerWidget {
  final DocumentModel document;
  final VoidCallback onClose;

  const DocumentViewer({
    super.key,
    required this.document,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.blue900.withValues(alpha: 0.3)
              : AppColors.lightGray300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(document.type, isDark)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        document.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTypeColor(document.type, isDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      document.title,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version ${document.version} • ${_formatDate(document.updatedAt)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.gray500
                            : AppColors.lightGray500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  color: isDark
                      ? AppColors.gray400
                      : AppColors.lightGray600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Content Summary
          if (document.content['summary'] != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.blue900.withValues(alpha: 0.2)
                    : AppColors.lightGray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                document.content['summary'] as String,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark
                      ? AppColors.gray300
                      : AppColors.lightGray700,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Highlights
          if (document.content['highlights'] != null) ...[
            Text(
              '주요 내용',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.gray100
                    : AppColors.lightGray900,
              ),
            ),
            const SizedBox(height: 16),
            ...(document.content['highlights'] as List<dynamic>).map(
              (highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        highlight as String,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Projects
          if (document.content['projects'] != null) ...[
            const SizedBox(height: 24),
            Text(
              '프로젝트 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.gray100
                    : AppColors.lightGray900,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: (document.content['projects'] as List<dynamic>)
                  .map(
                    (project) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blue900.withValues(alpha: 0.3)
                            : AppColors.lightGray200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? AppColors.accentCyan.withValues(alpha: 0.3)
                              : AppColors.primaryBlue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        project as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 32),

          // Tags
          if (document.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: document.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blue900.withValues(alpha: 0.3)
                            : AppColors.lightGray200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.gray400
                              : AppColors.lightGray600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: PDF 다운로드 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.accentCyan
                        : AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'PDF 다운로드',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (!isMobile)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 인쇄 기능 구현
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.accentCyan
                          : AppColors.primaryBlue,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.print),
                    label: const Text(
                      '인쇄',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(DocumentType type, bool isDark) {
    switch (type) {
      case DocumentType.resume:
        return isDark ? AppColors.accentCyan : AppColors.primaryBlue;
      case DocumentType.coverLetter:
        return isDark ? AppColors.highlightGreen : const Color(0xFF4CAF50);
      case DocumentType.careerDescription:
        return isDark
            ? const Color(0xFFFF9800)
            : const Color(0xFFF57C00);
      case DocumentType.portfolio:
        return isDark
            ? const Color(0xFFE91E63)
            : const Color(0xFFC2185B);
      case DocumentType.requirements:
      case DocumentType.userFlow:
      case DocumentType.informationArchitecture:
      case DocumentType.wireframe:
        return isDark ? const Color(0xFF9C27B0) : const Color(0xFF7B1FA2);
      case DocumentType.projectCharter:
      case DocumentType.screenDesign:
      case DocumentType.stakeholderMatrix:
      case DocumentType.riskRegister:
      case DocumentType.changeLog:
      case DocumentType.lessonsLearned:
        return isDark ? const Color(0xFF3F51B5) : const Color(0xFF303F9F);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
