import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../documents/domain/models/document_model.dart';
import '../../../documents/presentation/providers/documents_provider.dart';

class DocumentEditorDialog extends ConsumerStatefulWidget {
  final DocumentModel? document; // null for create, non-null for edit

  const DocumentEditorDialog({super.key, this.document});

  @override
  ConsumerState<DocumentEditorDialog> createState() =>
      _DocumentEditorDialogState();
}

class _DocumentEditorDialogState extends ConsumerState<DocumentEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  late TextEditingController _pdfUrlController;
  late DocumentType _selectedType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.document?.type ?? DocumentType.resume;
    _titleController = TextEditingController(
      text: widget.document?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.document?.content['text'] as String? ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.document?.tags.join(', ') ?? '',
    );
    _pdfUrlController = TextEditingController(
      text: widget.document?.pdfUrl ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _pdfUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final content = <String, dynamic>{'text': _contentController.text};

      if (widget.document == null) {
        // Create new document
        await ref
            .read(documentsNotifierProvider.notifier)
            .createDocument(
              type: _selectedType,
              title: _titleController.text,
              content: content,
              pdfUrl: _pdfUrlController.text.isEmpty
                  ? null
                  : _pdfUrlController.text,
              tags: tags,
            );
      } else {
        // Update existing document
        final updatedDocument = DocumentModel(
          id: widget.document!.id,
          type: _selectedType,
          title: _titleController.text,
          version: widget.document!.version,
          createdAt: widget.document!.createdAt,
          updatedAt: DateTime.now(),
          pdfUrl: _pdfUrlController.text.isEmpty
              ? null
              : _pdfUrlController.text,
          content: content,
          tags: tags,
        );
        await ref
            .read(documentsNotifierProvider.notifier)
            .updateDocument(updatedDocument);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.document == null ? '문서가 추가되었습니다' : '문서가 수정되었습니다',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Dialog(
      backgroundColor: isDark ? AppColors.charcoal : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isMobile ? size.width * 0.9 : 600,
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryBlue.withValues(alpha: 0.1)
                    : AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: isDark
                        ? AppColors.accentCyan
                        : AppColors.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.document == null ? '새 문서 추가' : '문서 수정',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Document Type
                      Text(
                        '문서 유형',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<DocumentType>(
                        // ignore: deprecated_member_use
                        value: _selectedType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark
                              ? AppColors.charcoal.withValues(alpha: 0.3)
                              : AppColors.gray100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        dropdownColor: isDark
                            ? AppColors.charcoal
                            : Colors.white,
                        items: DocumentType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              '${type.displayName} - ${type.description}',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.gray100
                                    : AppColors.lightGray900,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        '제목',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: '문서 제목을 입력하세요',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.lightGray400,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.charcoal.withValues(alpha: 0.3)
                              : AppColors.gray100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '제목을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Content
                      Text(
                        '내용',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: '문서 내용을 입력하세요',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.lightGray400,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.charcoal.withValues(alpha: 0.3)
                              : AppColors.gray100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '내용을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // PDF URL (Optional)
                      Text(
                        'PDF URL (선택사항)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _pdfUrlController,
                        decoration: InputDecoration(
                          hintText: 'PDF 파일 URL을 입력하세요',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.lightGray400,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.charcoal.withValues(alpha: 0.3)
                              : AppColors.gray100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tags
                      Text(
                        '태그 (쉼표로 구분)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tagsController,
                        decoration: InputDecoration(
                          hintText: '태그1, 태그2, 태그3',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.lightGray400,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.charcoal.withValues(alpha: 0.3)
                              : AppColors.gray100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Buttons
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.lightGray600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.accentCyan
                          : AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.document == null ? '추가' : '저장',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
