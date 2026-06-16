import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// 실제 프로젝트 문서 페이지 (PDF 출력 가능)
class ProjectDocumentsPage extends StatefulWidget {
  const ProjectDocumentsPage({super.key});

  @override
  State<ProjectDocumentsPage> createState() => _ProjectDocumentsPageState();
}

class _ProjectDocumentsPageState extends State<ProjectDocumentsPage> {
  int _selectedIndex = 0;

  final List<ProjectDocument> _documents = [
    ProjectDocument(
      title: '입사지원 패키지 (Job Application Package)',
      category: '빅테크/대기업 지원용',
      icon: Icons.auto_awesome,
      color: Color(0xFFC1D72E),
      sections: _getJobPackageSections(),
      isSpecial: true,
      type: 'package',
    ),
    ProjectDocument(
      title: '전문 이력서 (Professional Resume)',
      category: '정규직/리더십 포지션',
      icon: Icons.badge,
      color: Color(0xFFE91E63),
      sections: _getProfessionalResumeSections(),
      isSpecial: true,
      type: 'resume',
    ),
    ProjectDocument(
      title: '경력기술서 (Career Description)',
      category: '20년 전문성/성과기반',
      icon: Icons.history_edu,
      color: Color(0xFF673AB7),
      sections: _getCareerDescriptionSections(),
      isSpecial: true,
      type: 'career',
    ),
    ProjectDocument(
      title: '자기소개서 (Self-Introduction)',
      category: '비전/강점/인성 상세',
      icon: Icons.person_search,
      color: Color(0xFF009688),
      sections: _getSelfIntroSections(),
      isSpecial: true,
      type: 'intro',
    ),
    ProjectDocument(
      title: '화면 설계서 (Screen Specifications)',
      category: '기획/디자인',
      icon: Icons.dashboard,
      color: AppColors.primaryBlue,
      sections: _getScreenSpecSections(),
    ),
    ProjectDocument(
      title: 'API 설계서 (API Specifications)',
      category: '개발',
      icon: Icons.api,
      color: AppColors.accentCyan,
      sections: _getApiSpecSections(),
    ),
    ProjectDocument(
      title: '디자인 시스템 문서',
      category: '디자인',
      icon: Icons.palette,
      color: AppColors.highlightGreen,
      sections: _getDesignSystemSections(),
    ),
    ProjectDocument(
      title: '데이터베이스 스키마',
      category: '개발',
      icon: Icons.storage,
      color: Color(0xFFFF9800),
      sections: _getDatabaseSections(),
    ),
    ProjectDocument(
      title: '배포 및 인프라 문서',
      category: '운영',
      icon: Icons.cloud_upload,
      color: Color(0xFF9C27B0),
      sections: _getDeploymentSections(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDoc = _documents[_selectedIndex];

    return Container(
      color: AppColors.deepSpace,
      child: Row(
        children: [
          // 왼쪽 사이드바
          _buildSidebar(),

          // 오른쪽 문서 뷰어
          Expanded(child: _buildDocumentViewer(selectedDoc)),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        border: Border(
          right: BorderSide(color: AppColors.lightGray300.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '프로젝트 문서',
                  style: AppTypography.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '실제 프로젝트 산출물',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.lightGray300,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.lightGray300, height: 1),

          // 문서 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final doc = _documents[index];
                final isSelected = _selectedIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? doc.color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: doc.color, width: 2)
                        : null,
                  ),
                  child: ListTile(
                    leading: Icon(
                      doc.icon,
                      color: isSelected ? doc.color : AppColors.lightGray300,
                    ),
                    title: Text(
                      doc.title,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.lightGray300,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      doc.category,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.lightGray300.withOpacity(0.7),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer(ProjectDocument doc) {
    return Column(
      children: [
        // 헤더 with PDF 다운로드 버튼
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: doc.color.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(color: doc.color.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              Icon(doc.icon, color: doc.color, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: AppTypography.h5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (doc.isSpecial &&
                        doc.type ==
                            'resume') // Apply only for special resume type
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '20년의 실무 경력을 바탕으로 복잡한 비즈니스 요구사항을 명확한 UX/UI 설계로 구현하는 시니어 프로덕트 디자이너입니다. 단 한 번의 일정 지연 없는 책임감과 집요한 성실함으로 제조, 게임, 핀테크 등 다양한 분야에서 가시적인 성과를 만들어왔으며, 새로운 도구를 실무에 즉시 적용하는 능동적인 현업 디자이너로서의 역할을 지향합니다.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.lightGray300,
                            height: 1.8,
                          ),
                        ),
                      ),
                    Text(
                      doc.category,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.lightGray300,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _generatePDF(doc),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('PDF 다운로드'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: doc.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // 문서 내용
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: doc.sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildSection(section, doc.color),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(DocumentSection section, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: accentColor, width: 4)),
          ),
          child: Text(
            section.title,
            style: AppTypography.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 섹션 내용
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.charcoal.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            section.content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.lightGray300,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _generatePDF(ProjectDocument doc) async {
    // HTML 기반 PDF 생성 (한글 폰트 및 이미지 지원)
    final htmlContent = _generateHtmlForPdf(doc);

    // Blob 생성 및 URL 만들기
    final bytes = utf8.encode(htmlContent);
    final blob = html.Blob([bytes], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // 새 창에서 열기
    // ignore: unsafe_html
    html.window.open(url, '_blank');

    // URL 정리 (5초 후)
    Future.delayed(const Duration(seconds: 5), () {
      html.Url.revokeObjectUrl(url);
    });

    // 사용자에게 안내
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('새 창에서 Ctrl+P를 눌러 "PDF로 저장"을 선택하세요'),
          backgroundColor: AppColors.highlightGreen,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  String _generateHtmlForPdf(ProjectDocument doc) {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="ko">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="UTF-8">');
    buffer.writeln(
      '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
    );
    buffer.writeln('  <title>${doc.title}</title>');
    buffer.writeln('  <style>');
    buffer.writeln(
      '    @import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css");',
    );
    buffer.writeln('    ');
    buffer.writeln('    * { margin: 0; padding: 0; box-sizing: border-box; }');
    buffer.writeln('    body {');
    buffer.writeln(
      '      font-family: "Pretendard", -apple-system, BlinkMacSystemFont, system-ui, Roboto, "Helvetica Neue", "Segoe UI", "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;',
    );
    buffer.writeln('      font-size: 11pt;');
    buffer.writeln('      line-height: 1.6;');
    buffer.writeln('      color: #333;');
    buffer.writeln('      padding: 40px;');
    buffer.writeln('      max-width: 210mm;');
    buffer.writeln('      margin: 0 auto;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    h1 {');
    buffer.writeln('      font-size: 24pt;');
    buffer.writeln('      font-weight: 700;');
    buffer.writeln('      color: #0068B3;');
    buffer.writeln('      margin-bottom: 10px;');
    buffer.writeln('      padding-bottom: 15px;');
    buffer.writeln('      border-bottom: 3px solid #0068B3;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .category {');
    buffer.writeln('      font-size: 12pt;');
    buffer.writeln('      color: #666;');
    buffer.writeln('      margin-bottom: 30px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .section {');
    buffer.writeln('      margin-bottom: 30px;');
    buffer.writeln('      page-break-inside: avoid;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .section-title {');
    buffer.writeln('      font-size: 14pt;');
    buffer.writeln('      font-weight: 700;');
    buffer.writeln('      color: #009DDC;');
    buffer.writeln('      margin-bottom: 12px;');
    buffer.writeln('      padding-left: 12px;');
    buffer.writeln('      border-left: 4px solid #009DDC;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .section-content {');
    buffer.writeln('      padding: 15px;');
    buffer.writeln('      background-color: #f8f9fa;');
    buffer.writeln('      border-radius: 6px;');
    buffer.writeln('      white-space: pre-wrap;');
    buffer.writeln('      font-size: 10pt;');
    buffer.writeln('      line-height: 1.8;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .footer {');
    buffer.writeln('      margin-top: 50px;');
    buffer.writeln('      padding-top: 20px;');
    buffer.writeln('      border-top: 1px solid #ddd;');
    buffer.writeln('      text-align: center;');
    buffer.writeln('      font-size: 9pt;');
    buffer.writeln('      color: #999;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    @media print {');
    buffer.writeln('      body { padding: 20px; }');
    buffer.writeln('      .section { page-break-inside: avoid; }');
    buffer.writeln('    }');
    buffer.writeln('  </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    // 특수 문서 타입(이력서 등)에 따른 분기 처리
    if (doc.isSpecial) {
      return _generatePremiumHtmlForPdf(doc);
    }

    buffer.writeln('  <h1>${_escapeHtml(doc.title)}</h1>');
    buffer.writeln(
      '  <div class="category">${_escapeHtml(doc.category)}</div>',
    );

    // 각 섹션
    for (final section in doc.sections) {
      buffer.writeln('  <div class="section">');
      buffer.writeln(
        '    <div class="section-title">${_escapeHtml(section.title)}</div>',
      );
      buffer.writeln(
        '    <div class="section-content">${_escapeHtml(section.content)}</div>',
      );
      buffer.writeln('  </div>');
    }

    // 푸터
    buffer.writeln('  <div class="footer">');
    buffer.writeln('    문서 생성일: ${DateTime.now().toString().substring(0, 10)}');
    buffer.writeln('    <br>');
    buffer.writeln('    Jaewoong Jung - Senior Product Designer Portfolio');
    buffer.writeln('  </div>');

    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  String _generatePremiumHtmlForPdf(ProjectDocument doc) {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="ko">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="UTF-8">');
    buffer.writeln('  <title>${doc.title}</title>');
    buffer.writeln('  <style>');
    buffer.writeln('''
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Thin.woff2') format('woff2');
          font-weight: 100;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-ExtraLight.woff2') format('woff2');
          font-weight: 200;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Light.woff2') format('woff2');
          font-weight: 300;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Regular.woff2') format('woff2');
          font-weight: 400;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Medium.woff2') format('woff2');
          font-weight: 500;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-SemiBold.woff2') format('woff2');
          font-weight: 600;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Bold.woff2') format('woff2');
          font-weight: 700;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-ExtraBold.woff2') format('woff2');
          font-weight: 800;
          font-display: swap;
      }
      @font-face {
          font-family: 'Pretendard';
          src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/pretendard@1.0/Pretendard-Black.woff2') format('woff2');
          font-weight: 900;
          font-display: swap;
      }
    ''');
    buffer.writeln('    ');
    buffer.writeln(
      '    * { margin: 0; padding: 0; box-sizing: border-box; -webkit-print-color-adjust: exact; }',
    );
    buffer.writeln('    body {');
    buffer.writeln('      font-family: "Pretendard", sans-serif;');
    buffer.writeln('      color: #0f172a;');
    buffer.writeln('      line-height: 1.6;');
    buffer.writeln('      background: #f1f5f9;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .page {');
    buffer.writeln('      width: 210mm;');
    buffer.writeln('      min-height: 297mm;');
    buffer.writeln('      margin: 10mm auto;');
    buffer.writeln('      background: white;');
    buffer.writeln('      display: flex;');
    buffer.writeln('      position: relative;');
    buffer.writeln('      page-break-after: always;');
    buffer.writeln('      box-shadow: 0 10px 30px rgba(0,0,0,0.1);');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    /* Sidebar Column (Left) */');
    buffer.writeln('    .sidebar {');
    buffer.writeln('      width: 60mm;');
    buffer.writeln('      background: #1e293b;');
    buffer.writeln('      color: white;');
    buffer.writeln('      padding: 30mm 10mm 20mm 10mm;');
    buffer.writeln('      display: flex;');
    buffer.writeln('      flex-direction: column;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    /* Main Column (Right) */');
    buffer.writeln('    .main-content {');
    buffer.writeln('      flex: 1;');
    buffer.writeln('      padding: 30mm 20mm 20mm 20mm;');
    buffer.writeln('      background: white;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    /* Sidebar Styling */');
    buffer.writeln('    .photo-container {');
    buffer.writeln('      width: 45mm;');
    buffer.writeln('      height: 55mm;');
    buffer.writeln('      margin-bottom: 25px;');
    buffer.writeln('      overflow: hidden;');
    buffer.writeln('      border: 3px solid rgba(255,255,255,0.1);');
    buffer.writeln('      background: #334155;');
    buffer.writeln('    }');
    buffer.writeln(
      '    .photo-container img { width: 100%; height: 100%; object-fit: cover; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    .sidebar-section { margin-bottom: 35px; }');
    buffer.writeln('    .sidebar-title {');
    buffer.writeln('      font-size: 11pt;');
    buffer.writeln('      font-weight: 800;');
    buffer.writeln('      color: #3b82f6;');
    buffer.writeln('      text-transform: uppercase;');
    buffer.writeln('      letter-spacing: 2px;');
    buffer.writeln('      margin-bottom: 15px;');
    buffer.writeln('      display: flex; align-items: center;');
    buffer.writeln('    }');
    buffer.writeln('    .sidebar-title::after {');
    buffer.writeln(
      '      content: ""; flex: 1; height: 1px; background: rgba(255,255,255,0.1); margin-left: 10px;',
    );
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln(
      '    .contact-item { font-size: 9pt; color: #cbd5e1; margin-bottom: 10px; }',
    );
    buffer.writeln(
      '    .contact-item strong { display: block; color: white; margin-bottom: 2px; text-transform: uppercase; font-size: 7.5pt; letter-spacing: 0.5pt; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    /* Skill Bar Styling */');
    buffer.writeln('    .skill-bar-container { margin-bottom: 15px; }');
    buffer.writeln(
      '    .skill-name { font-size: 8.5pt; color: white; margin-bottom: 5px; font-weight: 600; display: flex; justify-content: space-between; }',
    );
    buffer.writeln(
      '    .skill-track { height: 4px; background: rgba(255,255,255,0.1); border-radius: 2px; }',
    );
    buffer.writeln(
      '    .skill-fill { height: 100%; background: #3b82f6; border-radius: 2px; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    /* Main Content Styling */');
    buffer.writeln('    .header-info h1 {');
    buffer.writeln(
      '      font-size: 36pt; font-weight: 800; color: #0f172a; margin-bottom: 5px; letter-spacing: -2px;',
    );
    buffer.writeln('    }');
    buffer.writeln('    .header-info .job-title {');
    buffer.writeln(
      '      font-size: 14pt; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 40px;',
    );
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .main-section { margin-bottom: 35px; }');
    buffer.writeln('    .main-section-title {');
    buffer.writeln(
      '      font-size: 15pt; font-weight: 800; color: #0f172a; border-bottom: 3px solid #f1f5f9; padding-bottom: 10px; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; position: relative;',
    );
    buffer.writeln('    }');
    buffer.writeln('    .main-section-title::after {');
    buffer.writeln(
      '      content: ""; position: absolute; bottom: -3px; left: 0; width: 50px; height: 3px; background: #3b82f6;',
    );
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .content-item { margin-bottom: 25px; }');
    buffer.writeln(
      '    .item-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 5px; }',
    );
    buffer.writeln(
      '    .item-title { font-size: 12pt; font-weight: 800; color: #0f172a; }',
    );
    buffer.writeln(
      '    .item-date { font-size: 9.5pt; font-weight: 600; color: #64748b; }',
    );
    buffer.writeln(
      '    .item-sub { font-size: 10pt; font-weight: 700; color: #3b82f6; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px; }',
    );
    buffer.writeln(
      '    .item-desc { font-size: 10pt; color: #334155; line-height: 1.7; white-space: pre-wrap; }',
    );
    buffer.writeln('    ');
    buffer.writeln(
      '    .bullet { display: flex; align-items: flex-start; margin-bottom: 5px; }',
    );
    buffer.writeln(
      '    .bullet::before { content: "•"; color: #3b82f6; margin-right: 10px; font-weight: 800; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    ');
    buffer.writeln('    /* Full-Width Page Layout */');
    buffer.writeln('    .full-page {');
    buffer.writeln('      width: 210mm;');
    buffer.writeln('      min-height: 297mm;');
    buffer.writeln('      margin: 10mm auto;');
    buffer.writeln('      background: white;');
    buffer.writeln('      padding: 25mm 20mm;');
    buffer.writeln('      position: relative;');
    buffer.writeln('      page-break-after: always;');
    buffer.writeln('      box-shadow: 0 10px 30px rgba(0,0,0,0.1);');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .full-header {');
    buffer.writeln('      border-bottom: 3px solid #f1f5f9;');
    buffer.writeln('      padding-bottom: 15px;');
    buffer.writeln('      margin-bottom: 30px;');
    buffer.writeln('      display: flex;');
    buffer.writeln('      justify-content: space-between;');
    buffer.writeln('      align-items: flex-end;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .full-header h1 {');
    buffer.writeln('      font-size: 24pt;');
    buffer.writeln('      font-weight: 800;');
    buffer.writeln('      color: #0f172a;');
    buffer.writeln('      letter-spacing: -1px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .full-header .doc-type {');
    buffer.writeln('      font-size: 12pt;');
    buffer.writeln('      color: #3b82f6;');
    buffer.writeln('      font-weight: 700;');
    buffer.writeln('      text-transform: uppercase;');
    buffer.writeln('      letter-spacing: 1px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    @media print {');
    buffer.writeln('      body { background: white; }');
    buffer.writeln('      .page, .full-page { margin: 0; box-shadow: none; }');
    buffer.writeln('      -webkit-print-color-adjust: exact;');
    buffer.writeln('    }');
    buffer.writeln('  </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('  <div class="page">');
    buffer.writeln('    <!-- Sidebar -->');
    buffer.writeln('    <div class="sidebar">');
    buffer.writeln('      <div class="photo-container">');
    buffer.writeln(
      '        <img src="http://localhost:8080/images/profile_photo.jpg" alt="Photo">',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      ');
    buffer.writeln('      <div class="sidebar-section">');
    buffer.writeln('        <div class="sidebar-title">Contact</div>');
    buffer.writeln(
      '        <div class="contact-item"><strong>Phone</strong>010-4375-3599</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Email</strong>coyotejw@naver.com</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Address</strong>경기도 고양시 덕양구</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Exp</strong>20 Years (2006~Present)</div>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      ');
    buffer.writeln('      <div class="sidebar-section">');
    buffer.writeln('        <div class="sidebar-title">Core Skills</div>');
    buffer.writeln('        ${_renderSkillBar("UX/UI Strategy", 95)}');
    buffer.writeln('        ${_renderSkillBar("Product Design", 90)}');
    buffer.writeln('        ${_renderSkillBar("Design System", 95)}');
    buffer.writeln('        ${_renderSkillBar("Figma / Adobe XD", 100)}');
    buffer.writeln('        ${_renderSkillBar("Protopie / Flutter", 85)}');
    buffer.writeln('        ${_renderSkillBar("3D Art / Motion", 80)}');
    buffer.writeln('      </div>');
    buffer.writeln('      ');
    buffer.writeln('      <div class="sidebar-section">');
    buffer.writeln('        <div class="sidebar-title">Education</div>');
    buffer.writeln(
      '        <div class="contact-item"><strong>학점은행제</strong>시각디자인학 학사 (4.25/4.5)</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>청강문화산업대</strong>3D애니메이션 전문학사</div>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
    buffer.writeln('    ');
    buffer.writeln('    <!-- Main Content -->');
    buffer.writeln('    <div class="main-content">');
    buffer.writeln('      <div class="header-info">');
    buffer.writeln('        <h1>정재웅</h1>');
    buffer.writeln(
      '        <div class="job-title">Senior Product Designer & UX Expert</div>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      ');

    // 렌더링 로직 (패키지 여부에 따라 분기)
    for (int i = 0; i < doc.sections.length; i++) {
      final section = doc.sections[i];

      // 특정 문서 구분을 위해 페이지 넘김 (패키지인 경우)
      if (doc.type == 'package' &&
          i > 0 &&
          (section.title.contains('1. 아이엔지피플') ||
              section.title.contains('인사말'))) {
        final docTypeLabel = section.title.contains('1. 아이엔지피플')
            ? 'Career Description'
            : 'Self-Introduction';

        // 이전 페이지 닫기
        buffer.writeln('    </div> <!-- End Main -->');
        buffer.writeln('  </div> <!-- End Page -->');

        // 새 Full-Width 페이지 시작
        buffer.writeln('  <div class="full-page">');
        buffer.writeln('    <div class="full-header">');
        buffer.writeln('      <h1>정재웅</h1>');
        buffer.writeln('      <div class="doc-type">$docTypeLabel</div>');
        buffer.writeln('    </div>');
        buffer.writeln(
          '    <div class="full-content" style="padding-top: 10px;">',
        );
      }

      buffer.writeln('      <div class="main-section">');
      buffer.writeln(
        '        <div class="main-section-title">${_escapeHtml(section.title)}</div>',
      );
      buffer.writeln('        <div class="item-desc">');

      final lines = section.content.split('\n');
      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;

        if (trimmed.startsWith('•') || trimmed.startsWith('·')) {
          buffer.writeln(
            '          <div class="bullet">${_escapeHtml(trimmed.substring(1).trim())}</div>',
          );
        } else {
          buffer.writeln(
            '          <div style="margin-bottom: 8px;">${_escapeHtml(trimmed)}</div>',
          );
        }
      }

      buffer.writeln('        </div>');
      buffer.writeln('      </div>');
    }

    buffer.writeln('    </div> <!-- End Main -->');
    buffer.writeln('  </div> <!-- End Page -->');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  String _renderSkillBar(String name, int level) {
    return '''
      <div class="skill-bar-container">
        <div class="skill-name"><span>$name</span><span>$level%</span></div>
        <div class="skill-track"><div class="skill-fill" style="width: $level%;"></div></div>
      </div>
    ''';
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  // === 문서 내용 정의 메서드들 ===

  static List<DocumentSection> _getJobPackageSections() {
    return [
      ..._getProfessionalResumeSections(),
      ..._getCareerDescriptionSections(),
      ..._getSelfIntroSections(),
    ];
  }

  static List<DocumentSection> _getScreenSpecSections() {
    return [
      DocumentSection(
        title: '1. 홈페이지 (Home Page)',
        content: '''화면 ID: HOME-001
URL: /

[화면 구성]
1. Hero Section
   - 대형 타이포그래피: "Jaewoong Jung"
   - 직책: "Senior Product Designer"
   - CTA 버튼: "View Projects", "Contact Me"
   - 배경: 홀로그래픽 애니메이션

2. Portfolio Gallery
   - 그리드 레이아웃 (3열, 반응형)
   - 프로젝트 카드: 썸네일, 제목, 카테고리, 기술스택
   - 호버 효과: 스케일업 + 글로우
   - 필터: All / Web / Mobile / Design System

3. About Section
   - 프로필 사진
   - 자기소개 (200자 내외)
   - 경력 요약 (3-5개 하이라이트)

4. Skills Section
   - 기술 스택 시각화 (바 차트)
   - 카테고리: Design / Frontend / Backend / Tools

5. Experience Timeline
   - 연도별 타임라인 (최근 3개)
   - 회사명, 기간, 주요 성과

6. Contact Section
   - 이메일, GitHub, LinkedIn, Behance 링크
   - 간단한 연락 폼 (이름, 이메일, 메시지)

[인터랙션]
- 스크롤 애니메이션: Fade in + Slide up
- 카드 호버: Transform scale(1.05) + box-shadow glow
- 버튼 호버: Background gradient shift
''',
      ),
      DocumentSection(
        title: '2. 프로젝트 상세 페이지',
        content: '''화면 ID: PROJECT-DETAIL-001
URL: /project/:id

[화면 구성]
1. Hero Header
   - 프로젝트 대표 이미지 (전체 너비)
   - 제목 오버레이
   - 카테고리 태그

2. Project Info Card
   - 기간, 역할, 기술스택
   - 팀 구성, 프로젝트 목표
   - 외부 링크 (GitHub, Live Demo)

3. 프로젝트 설명
   - 배경 및 문제 정의
   - 솔루션 및 접근 방식
   - 주요 기능 상세 설명

4. 이미지 갤러리
   - 라이트박스 기능
   - 캡션 및 설명

5. 성과 및 결과
   - 정량적 지표 (사용자 증가율 등)
   - 정성적 평가 (사용자 피드백)

6. 다음/이전 프로젝트 네비게이션

[인터랙션]
- 이미지 클릭: 라이트박스 확대
- 스크롤 progress bar
- 공유 버튼: 클립보드 복사
''',
      ),
      DocumentSection(
        title: '3. Admin 페이지',
        content: '''화면 ID: ADMIN-001
URL: /admin

[화면 구성]
1. 탭 네비게이션
   - Projects / Profile / Experience / Education / Skills / Resume
   - 스크롤 가능한 수평 탭

2. Projects 탭
   - 프로젝트 목록 (카드 형식)
   - CRUD 버튼: 생성, 수정, 삭제
   - 일괄 선택 및 PDF 출력

3. Profile Editor
   - 기본 정보 입력 폼
   - 프로필 이미지 업로드
   - 실시간 미리보기

4. Content Editors
   - 각 섹션별 WYSIWYG 에디터
   - Drag & drop 이미지 업로드
   - 저장 및 취소 버튼

5. 문서 템플릿
   - 프로젝트 제안서, 기획서, 디자인 시스템
   - 편집 및 다운로드 (Markdown, HTML, TXT, PDF)

[권한]
- Firebase Auth 로그인 필수
- 인증되지 않은 사용자: 리다이렉트 /
''',
      ),
    ];
  }

  static List<DocumentSection> _getApiSpecSections() {
    return [
      DocumentSection(
        title: '1. API 개요',
        content: '''Base URL: http://localhost:8080/api

[인증]
- 타입: Firebase Authentication
- Header: Authorization: Bearer {token}

[응답 형식]
- Content-Type: application/json
- Status Codes:
  - 200: Success
  - 201: Created
  - 400: Bad Request
  - 401: Unauthorized
  - 404: Not Found
  - 500: Internal Server Error
''',
      ),
      DocumentSection(
        title: '2. Projects API',
        content: '''[GET] /api/projects
설명: 모든 프로젝트 목록 조회
응답:
{
  "projects": [
    {
      "id": "proj_001",
      "title": "Project Title",
      "category": "Web",
      "techStack": ["Flutter", "Firebase"],
      "thumbnailUrl": "...",
      "description": "...",
      "createdAt": "2025-01-01T00:00:00Z"
    }
  ]
}

[GET] /api/projects/:id
설명: 특정 프로젝트 상세 조회
Path Parameter: id (string)
응답:
{
  "id": "proj_001",
  "title": "...",
  "category": "...",
  "role": "Frontend Developer",
  "duration": "2024.01 - 2024.03",
  "teamSize": 4,
  "description": "...",
  "features": ["...", "..."],
  "techStack": ["...", "..."],
  "images": ["url1", "url2"],
  "outcome": {
    "metrics": {"users": "+150%"},
    "feedback": "..."
  },
  "links": {
    "github": "...",
    "live": "..."
  }
}

[POST] /api/projects
설명: 새 프로젝트 생성 (Admin only)
Request Body:
{
  "title": "string",
  "category": "string",
  "description": "string",
  ...
}
응답: 201 Created + 생성된 프로젝트 객체

[PUT] /api/projects/:id
설명: 프로젝트 수정 (Admin only)
Request Body: (수정할 필드만)
응답: 200 OK + 수정된 프로젝트 객체

[DELETE] /api/projects/:id
설명: 프로젝트 삭제 (Admin only)
응답: 204 No Content
''',
      ),
      DocumentSection(
        title: '3. Profile API',
        content: '''[GET] /api/profile
설명: 프로필 정보 조회
응답:
{
  "name": "Jaewoong Jung",
  "title": "Senior Product Designer",
  "bio": "...",
  "profileImageUrl": "...",
  "email": "...",
  "social": {
    "github": "...",
    "linkedin": "...",
    "behance": "..."
  }
}

[PUT] /api/profile
설명: 프로필 수정 (Admin only)
Request Body: 수정할 필드
응답: 200 OK + 수정된 프로필
''',
      ),
      DocumentSection(
        title: '4. Skills API',
        content: '''[GET] /api/skills
설명: 기술 스택 목록 조회
응답:
{
  "skills": [
    {
      "id": "skill_001",
      "name": "Flutter",
      "category": "Frontend",
      "level": 90,
      "iconUrl": "..."
    }
  ]
}
''',
      ),
    ];
  }

  static List<DocumentSection> _getDesignSystemSections() {
    return [
      DocumentSection(
        title: '1. Color Palette',
        content: '''[Primary Colors]
Deep Space: #020205 (배경)
Dark Navy: #050810 (카드 배경)
Charcoal: #0A101A (컨테이너)
Slate: #151A25 (호버 상태)

[Brand Colors]
Primary Blue: #0068B3 (CTA, 링크)
Accent Cyan: #009DDC (강조, 액센트)
Highlight Green: #C1D72E (성공, 완료)

[Functional Colors]
Success: #C1D72E
Warning: #FFB800
Error: #FF4757
Info: #009DDC

[Text Colors]
Primary Text: #FFFFFF
Secondary Text: #C9D1D9
Muted Text: #8B949E
''',
      ),
      DocumentSection(
        title: '2. Typography',
        content: '''[Font Family]
Primary: Google Fonts - Inter
Monospace: Fira Code

[Scale]
H1: 48px / Bold / Line Height 1.2
H2: 36px / Bold / Line Height 1.3
H3: 28px / Semi-Bold / Line Height 1.4
H4: 24px / Semi-Bold / Line Height 1.4
H5: 20px / Medium / Line Height 1.5
H6: 18px / Medium / Line Height 1.5
Body Large: 16px / Regular / Line Height 1.6
Body: 14px / Regular / Line Height 1.6
Body Small: 12px / Regular / Line Height 1.5
Caption: 11px / Regular / Line Height 1.4
''',
      ),
      DocumentSection(
        title: '3. Spacing System',
        content: '''[Base Unit] 4px

Scale:
- 4px: XS (여백 최소)
- 8px: S (컴포넌트 내부)
- 12px: M (컴포넌트 간)
- 16px: L (섹션 내부)
- 24px: XL (섹션 간)
- 32px: 2XL (주요 섹션)
- 48px: 3XL (페이지 섹션)
- 64px: 4XL (히어로 섹션)
''',
      ),
      DocumentSection(
        title: '4. Components',
        content: '''[Button]
Primary:
- Background: Primary Blue gradient
- Text: White
- Padding: 12px 24px
- Border Radius: 8px
- Hover: Scale 1.05 + Glow

Secondary:
- Background: Transparent
- Border: 1px Primary Blue
- Text: Primary Blue
- Hover: Fill + Text White

[Card]
- Background: Charcoal
- Border Radius: 12px
- Padding: 20px
- Border: 1px Accent Cyan (opacity 0.3)
- Hover: Transform translateY(-4px) + Shadow

[Input Field]
- Background: Deep Space
- Border: 1px Accent Cyan (opacity 0.3)
- Border Radius: 8px
- Padding: 12px 16px
- Focus: Border Accent Cyan + Glow
''',
      ),
    ];
  }

  static List<DocumentSection> _getDatabaseSections() {
    return [
      DocumentSection(
        title: '1. 데이터 저장 방식',
        content: '''[현재 구조]
- JSON 파일 기반 (server/data/db.json)
- 개발/프로토타입 단계에 적합
- 파일 시스템 저장

[향후 확장]
- Firebase Firestore로 마이그레이션 고려
- 실시간 동기화 및 확장성 확보
''',
      ),
      DocumentSection(
        title: '2. Projects Collection',
        content: '''Collection: projects

Schema:
{
  "id": "string (UUID)",
  "title": "string",
  "category": "string (Web|Mobile|DesignSystem)",
  "role": "string",
  "duration": "string (YYYY.MM - YYYY.MM)",
  "teamSize": "number",
  "description": "string",
  "features": "array<string>",
  "techStack": "array<string>",
  "thumbnailUrl": "string (URL)",
  "images": "array<string>",
  "outcome": {
    "metrics": "object",
    "feedback": "string"
  },
  "links": {
    "github": "string (URL)",
    "live": "string (URL)"
  },
  "createdAt": "string (ISO 8601)",
  "updatedAt": "string (ISO 8601)"
}

Indexes:
- category
- createdAt (desc)
''',
      ),
      DocumentSection(
        title: '3. Profile Collection',
        content: '''Collection: profile

Schema:
{
  "id": "profile_main",
  "name": "string",
  "title": "string",
  "bio": "string",
  "profileImageUrl": "string (URL)",
  "email": "string",
  "phone": "string?",
  "social": {
    "github": "string (URL)",
    "linkedin": "string (URL)",
    "behance": "string (URL)",
    "twitter": "string (URL)?"
  },
  "updatedAt": "string (ISO 8601)"
}
''',
      ),
    ];
  }

  static List<DocumentSection> _getProfessionalResumeSections() {
    return [
      DocumentSection(
        title: 'Professional Summary',
        content:
            '''20년의 실무 내공과 최신 AI 기술에 대한 집요한 연구를 결합하여 디자인의 미래를 제시하는 프로덕트 디자이너 정재웅입니다. 
Gemini, Claude, ChatGPT 등 LLM을 활용한 디자인 고도화와 Midjourney를 통한 효율적인 비주얼 에셋 생성에 능숙하며, 특히 Antigravity(Agentic AI) 기술을 워크플로우에 통합하여 생산성을 극대화하는 성실한 리서치 역량을 보유하고 있습니다.
AI 시대에 최적화된 도구 활용 능력과 20년 동안 단 한 번의 일정 지연도 없이 증명해온 변치 않는 성무를 바탕으로 팀의 비즈니스 가치를 직접 증명합니다.''',
      ),
      DocumentSection(
        title: 'Core Competencies',
        content:
            '''• AI Transformation: Gemini, Claude, ChatGPT, Midjourney를 실무 디자인 공정에 이식하여 생산성 300% 혁신
• Agentic Research: Antigravity(Agentic Workflow) 기술 연구를 통한 UX 설계 및 디자인 프로세스의 지능형 자동화 주도
• Technical Agility: Figma, Protopie, Flutter 등 기술적 도구를 가리지 않는 유연함과 20년의 깊이 있는 실무 노하우의 결합
• Diligent Craftsmanship: 어떤 변수에도 굴하지 않고 끈기 있게 결과물을 완성해내는 집요함과 100% 일정 준수의 신뢰감
• Multi-Domain Insight: 제조, 금융, 게임 등 다양한 산업 현장에서 검증된 문제 해결 능력과 다학제적 실행력''',
      ),
      DocumentSection(
        title: 'Key Experiences',
        content:
            '''아이엔지피플 (Senior Product Designer / UX UI 기획 및 디자인 실무 리딩) | 2025.01 - 2025.06
· AIA생명 고령자 모드 전용 디자인 시스템 및 핵심 GUI 직접 설계 및 고도화
· 한국마사회 및 토지개발 분석 솔루션 UX 기획 및 전체 UI 시안 제작

현대에이치티 (수석연구원 / Product Lead / 스마트홈 시스템 UX 디자인 실무 총괄) | 2018.05 - 2024.02
· 스마트홈 플랫폼 'HT Home' UX/UI 전면 개편 및 디자인 시스템 직접 설계
· 국내 주요 건설사 월패드 UX 커스터마이징 수주 기여 및 전체 디자인 프로세스 수행

넥슨코리아 (과장 / UX UI Designer) | 2010.10 - 2015.12
· 사내 최초 클로저스 CBT 반응형 웹사이트 구현 및 주요 라이브 게임 UX/UI 디자인 실무 총괄''',
      ),
    ];
  }

  static List<DocumentSection> _getCareerDescriptionSections() {
    return [
      DocumentSection(
        title: '1. 아이엔지피플 (2025.01 ~ 2025.06)',
        content: '''Senior Product Designer / UX UI 기획 및 디자인 실무 리딩
· AIA생명 앱 : 고령자 모드 UX/UI 고도화 직접 설계 및 제작
· 한국 마사회 비즈온 앱 UX/UI 시안 전체 실무 제작
· 토지개발 분석 솔루션 반응형 웹 UX/UI 설계 및 구현
· AIA 생명 Phase2 고령자 모드 전용 디자인 시스템 구축 및 폰트/GUI 최적화 수행
· 보험료 납입, 대출 상환 등 100여 개 이상의 화면 GUI 상세 정의''',
      ),
      DocumentSection(
        title: '2. 현대에이치티 (2018.05 ~ 2024.02)',
        content: '''수석연구원 / Product Lead / 스마트홈 시스템 UX 디자인 실무 총괄
· HT 범용 24인치 안드로이드 월패드 UX/UI 전체 설계 및 디자인 주도
· 포스코/현대 등 주요 건설사(30여 개 현장) 월패드 UX 커스터마이징 실무 총괄
· HT HOME 2.0 및 IoT 앱 UX/UI 고도화 리뉴얼 실무 제작
· PSQC 시운전 솔루션 웹사이트 인터랙션 및 GUI 설계
· 현업 중심의 UX 설계 프로세스 도입으로 디자인 품질 및 속도 개선''',
      ),
      DocumentSection(
        title: '3. 블루스톤소프트 (2016.05 ~ 2017.06)',
        content: '''책임연구원 / UX/UI Designer / 모바일 게임 인터페이스 설계
· SOULARK 모바일 게임 UX/UI 개발 총괄
· 디자인 개발 완성률 및 일정 준수율 100% 달성
· 개발 프로세스 효율성 20% 향상 및 마일스톤 목표 달성''',
      ),
      DocumentSection(
        title: '4. 넥슨코리아 (2010.10 ~ 2015.12)',
        content: '''과장 / UX/UI Designer / PC 및 모바일 게임 UX 시각화
· Project B/V/OX 모바일 게임 UX/UI 개발
· 클로저스 CBT 반응형 웹사이트 및 공식 웹사이트 UX/UI 리딩
· 넥슨 아레나 경기장 전용 앱 및 주요 라이브 게임 UX/UI 운영
· 사내 최초 반응형 웹 구현 적용 및 영웅시대30 GUI 리뉴얼 성공적 론칭''',
      ),
      DocumentSection(
        title: '5. YNK (플레이위드) 코리아 (2008.07 ~ 2010.10)',
        content: '''대리 / UX/UI Designer / 게임 브랜드 웹 플랫폼 구축
· 로한 시공의탑 웹게임(Flash AS2.0) UX/UI 개발
· 스팅 마이크로/OBT 신규 웹사이트(Full Flash) UX/UI 개발
· Flash 기반 고수준 UX/UI 디자인으로 웹게임 및 신규 조직 기여''',
      ),
      DocumentSection(
        title: '6. 비엠소프트 (2008.03 ~ 2008.07)',
        content: '''대리 / UX/UI Designer / 게임 리그 플랫폼 디자인
· WAPL 아마추어 게임 리그 웹사이트 UX/UI 기획 및 개발
· WAPL 비즈니스 디자인 운영 및 기획 지원''',
      ),
      DocumentSection(
        title: '7. 씨앤디 (2005.11 ~ 2006.12)',
        content: '''팀원 / 3D Artist & UX/UI Designer
· 인테리어/스포츠 사업부 웹사이트 UX/UI 개발
· 인테리어 설계 3D 공간 디자인 개발 및 가상 투어 시뮬레이션''',
      ),
    ];
  }

  static List<DocumentSection> _getSelfIntroSections() {
    return [
      DocumentSection(
        title: '인사말: AI 시대의 파도를 직접 타고 나아가는 실무 전문가',
        content: '''20년의 경험은 제게 자만이 아닌, 새로운 기술을 누구보다 먼저 파헤칠 수 있는 끈기를 주었습니다.
저는 Gemini, Claude, ChatGPT를 거쳐 Antigravity라는 Agentic AI 영역까지 깊숙이 연구하며, 디자이너가 AI와 공존하며 성과를 극대화하는 방법을 실무적으로 증명해왔습니다.
화려한 수식어보다 Midjourney로 생성한 정교한 에셋과 AI 에이전트로 최적화된 워크플로우 등, 실제 결과물로 저의 'AI 역량'과 '성실함'을 보여드리겠습니다.''',
      ),
      DocumentSection(
        title: '성장 배경: 디자인과 기획의 유기적 결합',
        content:
            '''3D 애니메이션 전공에서 시작된 조형적 감각과 디테일에 대한 집착은, 실무를 통해 사용자 흐름을 설계하는 전략적 UX 기획으로 확장되었습니다.
단순히 화면을 시각적으로 만드는 것에서 나아가, 사용자의 니즈를 정의하고 흐름을 구조화하는 프로덕트 디자이너로서 제품 전반을 이해하고 조율하는 역량을 키워왔습니다.''',
      ),
      DocumentSection(
        title: '성격: 진솔한 소통과 강한 책임감',
        content:
            '''저는 사람들과 진솔하게 관계를 맺고 소통하는 데 강점이 있습니다. 새로운 사람에게도 서스럼없이 다가가며, 상대를 존중하는 태도로 건강한 협업 문화를 만드는 것을 중요하게 생각합니다.
또한 맡은 일에 대한 책임감이 매우 강하며, 지금까지 참여한 모든 프로젝트를 중도 이탈 없이 성공적으로 완수해 왔습니다.''',
      ),
      DocumentSection(
        title: '취미 및 특기: 건강한 습관과 감각의 확장',
        content:
            '''운동을 통한 컨디션 관리(러닝, 풀업)와 자전거 산책을 즐기며, 일상의 소소한 디테일을 놓치지 않는 관찰력을 유지합니다.
전문 서적 탐독과 애니메이션/영화 감상을 통해 시각적 표현과 연출에 대한 영감을 얻으며 디자인 관점을 꾸준히 확장해 나가고 있습니다.''',
      ),
      DocumentSection(
        title: '입사 후 포부: 팀의 생산성을 혁신하는 AI 디자인 자산',
        content:
            '''저는 리더가 되기보다, 팀원들이 AI의 힘을 빌려 더 창의적인 일에 몰두할 수 있게 돕는 "AI 기반 실무 마스터"가 되겠습니다.
Gemini, Antigravity 등 제가 연구해온 모든 AI 노하우를 팀에 녹여내어, 단순 반복적인 업무를 줄이고 비즈니스 성과를 가속화하는 핵심적인 역할을 수행하겠습니다.
20년 동안 지켜온 성실함과 AI 시대가 요구하는 기술력을 결합하여, 어제보다 압도적으로 나은 퍼포먼스를 내는 결과물로 보답하겠습니다.''',
      ),
    ];
  }

  static List<DocumentSection> _getDeploymentSections() {
    return [
      DocumentSection(
        title: '1. Frontend 배포 (Firebase Hosting)',
        content: '''[사전 준비]
1. Firebase CLI 설치: npm install -g firebase-tools
2. Firebase 프로젝트 생성
3. firebase login

[배포 프로세스]
1. 빌드: flutter build web --release
2. 초기화: firebase init hosting
3. 배포: firebase deploy --only hosting

[설정]
- Public directory: build/web
- Single-page app: Yes
- 404.html, index.html 자동 생성

[커스텀 도메인]
1. Firebase Console → Hosting → Add custom domain
2. DNS 설정 (A record, CNAME)
3. SSL 인증서 자동 발급

[성능 최적화]
- CDN 자동 배포
- Gzip 압축
- 이미지 최적화: WebP 변환
''',
      ),
      DocumentSection(
        title: '2. Backend 배포 (Railway)',
        content: '''[배포 방법]
1. GitHub 저장소 연결
2. Railway 프로젝트 생성
3. server/ 디렉토리 선택
4. 환경 변수 설정
5. 자동 배포 활성화

[환경 변수]
- PORT: 8080 (Railway 자동 할당)
- NODE_ENV: production
- ALLOWED_ORIGINS: 프론트엔드 URL

[Health Check]
- Endpoint: /health
- 응답: {"status": "ok"}

[자동 재배포]
- main 브랜치 push 시 자동 배포
- 롤백 기능 지원
''',
      ),
      DocumentSection(
        title: '3. CI/CD Pipeline',
        content: '''[GitHub Actions]
.github/workflows/deploy.yml

trigger: push to main branch

jobs:
  frontend:
    - Checkout code
    - Setup Flutter
    - Run tests
    - Build web
    - Deploy to Firebase Hosting

  backend:
    - Checkout code
    - Setup Dart
    - Run tests
    - Deploy to Railway (automatic)

[배포 체크리스트]
✓ 테스트 통과
✓ 린트 검사 통과
✓ 빌드 성공
✓ 환경 변수 설정
✓ 도메인 연결 확인
✓ SSL 인증서 확인
✓ 성능 테스트 (Lighthouse 90+ 점수)
''',
      ),
    ];
  }
}

// === 데이터 모델 ===

class ProjectDocument {
  final String title;
  final String category;
  final IconData icon;
  final Color color;
  final List<DocumentSection> sections;
  final bool isSpecial;
  final String? type;

  ProjectDocument({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.sections,
    this.isSpecial = false,
    this.type,
  });
}

class DocumentSection {
  final String title;
  final String content;

  DocumentSection({required this.title, required this.content});
}
