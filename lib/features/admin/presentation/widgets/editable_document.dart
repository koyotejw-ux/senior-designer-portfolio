import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// 편집 가능한 문서 위젯
/// 현업에서 사용하는 실제 문서를 작성하고 편집할 수 있습니다
class EditableDocument extends StatefulWidget {
  final String title;
  final Map<String, dynamic> fields;
  final Color accentColor;

  const EditableDocument({
    super.key,
    required this.title,
    required this.fields,
    this.accentColor = AppColors.primaryBlue,
  });

  @override
  State<EditableDocument> createState() => _EditableDocumentState();
}

class _EditableDocumentState extends State<EditableDocument> {
  late Map<String, TextEditingController> _controllers;
  bool _isEditing = true;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    widget.fields.forEach((key, value) {
      if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  String _generateDocument({String format = 'txt'}) {
    final buffer = StringBuffer();

    if (format == 'md') {
      // Markdown 형식
      buffer.writeln('# ${widget.title}');
      buffer.writeln();

      _controllers.forEach((key, controller) {
        buffer.writeln('## $key');
        buffer.writeln();
        buffer.writeln(controller.text);
        buffer.writeln();
      });

      buffer.writeln('---');
      buffer.writeln('*문서 작성일: ${DateTime.now().toString().substring(0, 10)}*');
    } else if (format == 'html') {
      // HTML 형식
      buffer.writeln('<!DOCTYPE html>');
      buffer.writeln('<html>');
      buffer.writeln('<head>');
      buffer.writeln('  <meta charset="UTF-8">');
      buffer.writeln('  <title>${widget.title}</title>');
      buffer.writeln('  <style>');
      buffer.writeln('    @import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css");');
      buffer.writeln('    body { font-family: "Pretendard", -apple-system, BlinkMacSystemFont, system-ui, Roboto, "Segoe UI", sans-serif; max-width: 800px; margin: 40px auto; padding: 20px; }');
      buffer.writeln('    h1 { color: #0068B3; border-bottom: 3px solid #0068B3; padding-bottom: 10px; }');
      buffer.writeln('    h2 { color: #009DDC; margin-top: 30px; }');
      buffer.writeln('    p { line-height: 1.6; white-space: pre-wrap; }');
      buffer.writeln('    .footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; }');
      buffer.writeln('  </style>');
      buffer.writeln('</head>');
      buffer.writeln('<body>');
      buffer.writeln('  <h1>${widget.title}</h1>');

      _controllers.forEach((key, controller) {
        buffer.writeln('  <h2>$key</h2>');
        buffer.writeln('  <p>${controller.text}</p>');
      });

      buffer.writeln('  <div class="footer">문서 작성일: ${DateTime.now().toString().substring(0, 10)}</div>');
      buffer.writeln('</body>');
      buffer.writeln('</html>');
    } else {
      // 텍스트 형식 (기본)
      buffer.writeln('=' * 80);
      buffer.writeln(widget.title.toUpperCase());
      buffer.writeln('=' * 80);
      buffer.writeln();

      _controllers.forEach((key, controller) {
        buffer.writeln('[$key]');
        buffer.writeln(controller.text);
        buffer.writeln();
      });

      buffer.writeln('=' * 80);
      buffer.writeln('문서 작성일: ${DateTime.now().toString().substring(0, 10)}');
      buffer.writeln('=' * 80);
    }

    return buffer.toString();
  }

  void _copyToClipboard() {
    final document = _generateDocument();
    Clipboard.setData(ClipboardData(text: document));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('문서가 클립보드에 복사되었습니다!'),
        backgroundColor: AppColors.highlightGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        title: Text(
          '다운로드 형식 선택',
          style: AppTypography.h6.copyWith(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormatOption(
              icon: Icons.language,
              title: 'Markdown (.md)',
              description: 'Word, Notion, VS Code 등에서 편집 가능',
              format: 'md',
              color: AppColors.highlightGreen,
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              icon: Icons.code,
              title: 'HTML (.html)',
              description: '브라우저에서 바로 열람, Word로 변환 가능',
              format: 'html',
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 12),
            _buildFormatOption(
              icon: Icons.text_snippet,
              title: '텍스트 (.txt)',
              description: '모든 에디터에서 편집 가능',
              format: 'txt',
              color: AppColors.accentCyan,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(color: AppColors.lightGray300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption({
    required IconData icon,
    required String title,
    required String description,
    required String format,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _downloadDocument(format);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.deepSpace.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.lightGray300,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download, color: color),
          ],
        ),
      ),
    );
  }

  void _downloadDocument(String format) {
    try {
      final document = _generateDocument(format: format);
      final bytes = utf8.encode(document);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // 파일 확장자 설정
      String extension;
      switch (format) {
        case 'md':
          extension = 'md';
          break;
        case 'html':
          extension = 'html';
          break;
        default:
          extension = 'txt';
      }

      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '${widget.title}_${DateTime.now().toString().substring(0, 10)}.$extension';
      html.document.body?.children.add(anchor);

      anchor.click();

      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('문서가 다운로드되었습니다! (.$extension 형식)'),
          backgroundColor: AppColors.highlightGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('다운로드 실패: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.article, color: widget.accentColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTypography.h5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 편집/미리보기 토글
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.visibility : Icons.edit,
                    color: widget.accentColor,
                  ),
                  label: Text(
                    _isEditing ? '미리보기' : '편집',
                    style: TextStyle(color: widget.accentColor),
                  ),
                ),
                const SizedBox(width: 8),
                // 복사 버튼
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.highlightGreen),
                  tooltip: '클립보드에 복사',
                  onPressed: _copyToClipboard,
                ),
                // 다운로드 버튼
                IconButton(
                  icon: const Icon(Icons.download, color: AppColors.primaryBlue),
                  tooltip: '문서 다운로드',
                  onPressed: _showDownloadDialog,
                ),
              ],
            ),
          ),

          // 문서 내용
          Padding(
            padding: const EdgeInsets.all(20),
            child: _isEditing ? _buildEditMode() : _buildPreviewMode(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _controllers.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: AppTypography.h6.copyWith(
                  color: widget.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: entry.value,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.deepSpace.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.accentColor.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.accentColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.accentColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreviewMode() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepSpace.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.accentColor.withOpacity(0.2),
        ),
      ),
      child: SelectableText(
        _generateDocument(),
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          fontSize: 13,
          height: 1.8,
        ),
      ),
    );
  }
}
