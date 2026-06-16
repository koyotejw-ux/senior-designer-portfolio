import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/resume_model.dart';

class ResumePrintDialog extends StatefulWidget {
  final ResumeModel? resume;
  final CoverLetterModel? coverLetter;

  const ResumePrintDialog({super.key, this.resume, this.coverLetter});

  @override
  State<ResumePrintDialog> createState() => _ResumePrintDialogState();
}

class _ResumePrintDialogState extends State<ResumePrintDialog> {
  bool _includeResume = true;
  bool _includeCareerHistory = true;
  bool _includeCoverLetter = true;
  bool _isProcessing = false;
  String _statusMessage = '';
  Uint8List? _finalBytes;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    _includeResume = widget.resume != null;
    _includeCoverLetter = widget.coverLetter != null;
  }

  @override
  void dispose() {
    if (_blobUrl != null) {
      try {
        html.Url.revokeObjectUrl(_blobUrl!);
      } catch (_) {}
    }
    super.dispose();
  }

  Future<void> _generatePdf() async {
    if (!_includeResume && !_includeCareerHistory && !_includeCoverLetter) {
      setState(() {
        _statusMessage = '최소 하나의 문서를 선택해주세요.';
      });
      return;
    }

    if (widget.resume == null) {
      setState(() {
        _statusMessage = '이력서 데이터가 필요합니다.';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'PDF 생성 중...';
      _finalBytes = null;
    });

    try {
      // HTML 기반 PDF 생성으로 변경 (한글 및 이미지 완벽 지원)
      final htmlContent = _generateHtmlForPdf();

      // UTF-8 바이트로 변환 후 Blob 생성
      final bytes = utf8.encode(htmlContent);
      final blob = html.Blob([bytes], 'text/html;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // 브라우저의 인쇄 기능을 사용하도록 변경
      html.window.open(url, '_blank');

      // URL 정리 (10초 후)
      Future.delayed(const Duration(seconds: 10), () {
        html.Url.revokeObjectUrl(url);
      });

      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = '새 창에서 Ctrl+P를 눌러 PDF로 저장하세요';
          _finalBytes = Uint8List(0); // 더미 데이터
          _blobUrl = url;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'Error: $e';
        });
      }
    }
  }

  String _generateHtmlForPdf() {
    final buffer = StringBuffer();
    final resume = widget.resume!;
    final coverLetter = widget.coverLetter!;

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="ko">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="UTF-8">');
    buffer.writeln('  <title>이력서_${resume.personalInfo.name}</title>');
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
    buffer.writeln('      color: #1e293b;');
    buffer.writeln('      line-height: 1.5;');
    buffer.writeln('      padding: 0;');
    buffer.writeln('      background: #f1f5f9;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .page {');
    buffer.writeln('      width: 210mm;');
    buffer.writeln('      min-height: 297mm;');
    buffer.writeln('      padding: 20mm;');
    buffer.writeln('      margin: 10mm auto;');
    buffer.writeln('      background: white;');
    buffer.writeln('      box-shadow: 0 0 20px rgba(0,0,0,0.05);');
    buffer.writeln('      page-break-after: always;');
    buffer.writeln('      position: relative;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .header-accent {');
    buffer.writeln('      position: absolute;');
    buffer.writeln('      top: 0; left: 0; width: 100%; height: 8px;');
    buffer.writeln(
      '      background: linear-gradient(90deg, #0f172a 0%, #3b82f6 100%);',
    );
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .header {');
    buffer.writeln('      display: flex;');
    buffer.writeln('      justify-content: space-between;');
    buffer.writeln('      margin-bottom: 35px;');
    buffer.writeln('      padding-bottom: 25px;');
    buffer.writeln('      border-bottom: 1px solid #e2e8f0;');
    buffer.writeln('      margin-top: 10px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .profile-info h1 {');
    buffer.writeln('      font-size: 34pt;');
    buffer.writeln('      font-weight: 800;');
    buffer.writeln('      color: #0f172a;');
    buffer.writeln('      letter-spacing: -1.5px;');
    buffer.writeln('      margin-bottom: 4px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .profile-info .subtitle {');
    buffer.writeln('      font-size: 13pt;');
    buffer.writeln('      color: #3b82f6;');
    buffer.writeln('      font-weight: 600;');
    buffer.writeln('      margin-bottom: 15px;');
    buffer.writeln('      text-transform: uppercase;');
    buffer.writeln('      letter-spacing: 1px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .contact-info {');
    buffer.writeln('      font-size: 9.5pt;');
    buffer.writeln('      color: #64748b;');
    buffer.writeln('      display: grid;');
    buffer.writeln('      grid-template-columns: auto auto;');
    buffer.writeln('      column-gap: 25px;');
    buffer.writeln('      row-gap: 4px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln(
      '    .contact-item strong { color: #334155; margin-right: 5px; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    .photo-box {');
    buffer.writeln('      width: 38mm; height: 48mm;');
    buffer.writeln('      border-radius: 6px;');
    buffer.writeln('      border: 1px solid #e2e8f0;');
    buffer.writeln('      padding: 3px; background: white;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .photo-inner {');
    buffer.writeln('      width: 100%; height: 100%;');
    buffer.writeln('      background: #f8fafc;');
    buffer.writeln('      overflow: hidden; border-radius: 4px;');
    buffer.writeln('    }');
    buffer.writeln(
      '    .photo-inner img { width: 100%; height: 100%; object-fit: cover; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    section { margin-bottom: 30px; }');
    buffer.writeln('    ');
    buffer.writeln('    h2 {');
    buffer.writeln('      font-size: 15pt;');
    buffer.writeln('      font-weight: 800;');
    buffer.writeln('      color: #0f172a;');
    buffer.writeln('      margin-bottom: 15px;');
    buffer.writeln('      display: flex;');
    buffer.writeln('      align-items: center;');
    buffer.writeln('      text-transform: uppercase;');
    buffer.writeln('      letter-spacing: 0.5px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    h2::after {');
    buffer.writeln('      content: "";');
    buffer.writeln('      flex: 1;');
    buffer.writeln('      height: 1px;');
    buffer.writeln('      background: #e2e8f0;');
    buffer.writeln('      margin-left: 15px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .summary-box {');
    buffer.writeln('      background: #f8fafc;');
    buffer.writeln('      border-left: 4px solid #0f172a;');
    buffer.writeln('      padding: 18px 22px;');
    buffer.writeln('      font-size: 10.5pt;');
    buffer.writeln('      color: #334155;');
    buffer.writeln('      margin-bottom: 25px;');
    buffer.writeln('      font-weight: 500;');
    buffer.writeln('    }');
    buffer.writeln('    ');
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
      '    .contact-item strong { display: block; color: white; margin-bottom: 2px; text-transform: uppercase; font-size: 7.5pt; letter-spacing: 0.5px; }',
    );
    buffer.writeln('    ');
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
    buffer.writeln(
      '    .table { width: 100%; border-collapse: collapse; margin-bottom: 25px; }',
    );
    buffer.writeln(
      '    .table th { text-align: left; font-size: 9pt; color: #64748b; padding-bottom: 8px; border-bottom: 1px solid #f1f5f9; }',
    );
    buffer.writeln(
      '    .table td { padding: 8px 0; font-size: 10pt; color: #334155; }',
    );
    buffer.writeln('    ');
    buffer.writeln(
      '    .competency-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }',
    );
    buffer.writeln(
      '    .competency-item { background: #f8fafc; padding: 12px 15px; border-radius: 6px; font-size: 9.5pt; border-left: 3px solid #3b82f6; }',
    );
    buffer.writeln('    ');
    buffer.writeln(
      '    .career-item { margin-bottom: 25px; page-break-inside: avoid; }',
    );
    buffer.writeln('    ');
    buffer.writeln('    .career-header {');
    buffer.writeln('      display: flex;');
    buffer.writeln('      justify-content: space-between;');
    buffer.writeln('      align-items: baseline;');
    buffer.writeln('      margin-bottom: 6px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .career-company {');
    buffer.writeln('      font-size: 13pt;');
    buffer.writeln('      font-weight: 700;');
    buffer.writeln('      color: #0f172a;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .career-period {');
    buffer.writeln('      font-size: 10pt;');
    buffer.writeln('      font-weight: 600;');
    buffer.writeln('      color: #64748b;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .career-role {');
    buffer.writeln('      font-size: 10.5pt;');
    buffer.writeln('      font-weight: 600;');
    buffer.writeln('      color: #3b82f6;');
    buffer.writeln('      margin-bottom: 10px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .career-details { margin-left: 2px; }');
    buffer.writeln('    ');
    buffer.writeln('    .sub-section-title {');
    buffer.writeln('      font-size: 9pt;');
    buffer.writeln('      font-weight: 800;');
    buffer.writeln('      color: #94a3b8;');
    buffer.writeln('      text-transform: uppercase;');
    buffer.writeln('      margin: 12px 0 6px 0;');
    buffer.writeln('      letter-spacing: 0.5px;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .bullet-list { list-style: none; }');
    buffer.writeln('    ');
    buffer.writeln('    .bullet-item {');
    buffer.writeln('      position: relative;');
    buffer.writeln('      padding-left: 18px;');
    buffer.writeln('      margin-bottom: 4px;');
    buffer.writeln('      font-size: 9.5pt;');
    buffer.writeln('      color: #475569;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .bullet-item::before {');
    buffer.writeln('      content: "→";');
    buffer.writeln('      position: absolute;');
    buffer.writeln('      left: 0; top: 0;');
    buffer.writeln('      color: #3b82f6;');
    buffer.writeln('      font-weight: 700;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .cover-letter-text {');
    buffer.writeln('      font-size: 11pt;');
    buffer.writeln('      line-height: 1.8;');
    buffer.writeln('      color: #334155;');
    buffer.writeln('      white-space: pre-wrap;');
    buffer.writeln('    }');
    buffer.writeln('    ');
    buffer.writeln('    .cover-letter-section { margin-bottom: 25px; }');
    buffer.writeln('    ');
    buffer.writeln(
      '    .cover-letter-title { font-size: 12pt; font-weight: 700; color: #0f172a; margin-bottom: 8px; border-bottom: 1px solid #f1f5f9; padding-bottom: 4px; }',
    );
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
    buffer.writeln('    <div class="sidebar">');
    buffer.writeln('      <div class="photo-container">');
    buffer.writeln(
      '        <img src="${resume.photoUrl ?? 'http://localhost:8080/images/profile_photo.jpg'}" alt="Photo">',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="sidebar-section">');
    buffer.writeln('        <div class="sidebar-title">Contact</div>');
    buffer.writeln(
      '        <div class="contact-item"><strong>Phone</strong>${resume.personalInfo.phone}</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Email</strong>${resume.personalInfo.email}</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Address</strong>${resume.personalInfo.address}</div>',
    );
    buffer.writeln(
      '        <div class="contact-item"><strong>Military</strong>${resume.personalInfo.militaryService}</div>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      <div class="sidebar-section">');
    buffer.writeln('        <div class="sidebar-title">Education</div>');
    for (var edu in resume.education) {
      buffer.writeln(
        '        <div class="contact-item"><strong>${edu.institution}</strong>${edu.major} (${edu.gpa})</div>',
      );
    }
    buffer.writeln('      </div>');
    buffer.writeln('    </div>');
    buffer.writeln('    ');
    buffer.writeln('    <div class="main-content">');
    buffer.writeln('      <div class="header-info">');
    buffer.writeln('        <h1>${resume.personalInfo.name}</h1>');
    buffer.writeln(
      '        <div class="job-title">Senior Product Designer & UX Expert</div>',
    );
    buffer.writeln('      </div>');
    buffer.writeln('      ');
    if (_includeResume) {
      buffer.writeln('      <div class="main-section">');
      buffer.writeln(
        '        <div class="main-section-title">Professional Summary</div>',
      );
      buffer.writeln(
        '        <div style="font-size: 10.5pt; line-height: 1.8; color: #334155;">',
      );
      buffer.writeln(
        '          17년 경력의 시니어 UX 전문가로서 대형 제조사(현대HT), 게임 엔터테인먼트(넥슨), 핀테크 등 다양한 산업군에서 UX 전략 수립 및 디자인 리딩을 담당하였습니다. 비즈니스 가치와 사용자 중심 설계를 조화시키는 역량으로 성공적인 프로젝트 완결을 주도합니다.',
      );
      buffer.writeln('        </div>');
      buffer.writeln('      </div>');
      buffer.writeln('      <div class="main-section">');
      buffer.writeln(
        '        <div class="main-section-title">Core Competencies</div>',
      );
      buffer.writeln('        <div class="competency-grid">');
      for (var comp in resume.coreCompetencies) {
        buffer.writeln('          <div class="competency-item">$comp</div>');
      }
      buffer.writeln('        </div>');
      buffer.writeln('      </div>');
      buffer.writeln('      <div class="main-section">');
      buffer.writeln(
        '        <div class="main-section-title">Certifications</div>',
      );
      buffer.writeln('        <table class="table">');
      buffer.writeln(
        '          <thead><tr><th>취득일</th><th>자격증명</th><th>발급기관</th></tr></thead>',
      );
      buffer.writeln('          <tbody>');
      for (var cert in resume.certifications) {
        buffer.writeln(
          '            <tr><td>${cert.date}</td><td><strong>${cert.name}</strong></td><td>${cert.issuer}</td></tr>',
        );
      }
      buffer.writeln('          </tbody>');
      buffer.writeln('        </table>');
      buffer.writeln('      </div>');
    }
    buffer.writeln('    </div>');
    buffer.writeln('  </div>');
    // End Page 1

    if (_includeCareerHistory) {
      final careers = resume.careers;
      for (var i = 0; i < careers.length; i += 3) {
        final end = (i + 3 < careers.length) ? i + 3 : careers.length;
        final subList = careers.sublist(i, end);

        buffer.writeln('  <div class="full-page">');
        buffer.writeln('    <div class="full-header">');
        buffer.writeln('      <h1>${resume.personalInfo.name}</h1>');
        buffer.writeln(
          '      <div class="doc-type">Career Description ${i == 0 ? '' : '(계속)'}</div>',
        );
        buffer.writeln('    </div>');
        buffer.writeln('    <div class="full-content">');
        buffer.writeln('      <div class="main-section">');
        buffer.writeln(
          '        <div class="main-section-title">Career Description ${i == 0 ? '' : '(계속)'}</div>',
        );

        for (var career in subList) {
          buffer.writeln(
            '        <div class="career-item" style="border-bottom: 1px solid #f1f5f9; padding-bottom: 20px; margin-bottom: 20px;">',
          );
          buffer.writeln('          <div class="item-header">');
          buffer.writeln(
            '            <div class="item-title">${career.company}</div>',
          );
          buffer.writeln(
            '            <div class="item-date">${career.period}</div>',
          );
          buffer.writeln('          </div>');
          buffer.writeln(
            '          <div class="item-sub">${career.position} | ${career.department}</div>',
          );
          buffer.writeln('          <div class="item-desc">');

          if (career.projects.isNotEmpty) {
            buffer.writeln(
              '            <div style="font-weight: 700; color: #0f172a; margin: 10px 0 5px 0; font-size: 9.5pt;">Major Projects</div>',
            );
            for (var p in career.projects) {
              buffer.writeln('            <div class="bullet">$p</div>');
            }
          }

          if (career.achievements.isNotEmpty) {
            buffer.writeln(
              '            <div style="font-weight: 700; color: #0f172a; margin: 10px 0 5px 0; font-size: 9.5pt;">Key Achievements</div>',
            );
            for (var a in career.achievements) {
              buffer.writeln('            <div class="bullet">$a</div>');
            }
          }

          if (career.tools.isNotEmpty) {
            buffer.writeln(
              '            <div style="font-weight: 700; color: #0f172a; margin: 10px 0 5px 0; font-size: 9.5pt;">Tools & Environment</div>',
            );
            buffer.writeln(
              '            <div style="font-size: 9pt; color: #64748b; padding-left: 17px;">${career.tools.join(", ")}</div>',
            );
          }

          buffer.writeln('          </div>');
          buffer.writeln('        </div>');
        }
        buffer.writeln('      </div>');
        buffer.writeln('  </div>');
      }
    }

    if (_includeCoverLetter) {
      buffer.writeln('  <div class="full-page">');
      buffer.writeln('    <div class="full-header">');
      buffer.writeln('      <h1>${resume.personalInfo.name}</h1>');
      buffer.writeln('      <div class="doc-type">Self-Introduction</div>');
      buffer.writeln('    </div>');
      buffer.writeln('    <div class="full-content">');
      buffer.writeln('      <div class="main-section">');
      buffer.writeln(
        '        <div class="main-section-title">Self-Introduction</div>',
      );
      buffer.writeln('        <div class="item-desc">');

      final sections = [
        {'title': '인사말 (Greeting)', 'content': coverLetter.greeting},
        {'title': '성장배경 (Background)', 'content': coverLetter.background},
        {'title': '성격 (Personality)', 'content': coverLetter.personality},
        {'title': '취미 및 특기 (Hobbies)', 'content': coverLetter.hobbies},
        {'title': '입사 후 포부 (Aspiration)', 'content': coverLetter.aspiration},
      ];

      for (var s in sections) {
        buffer.writeln('          <div style="margin-bottom: 25px;">');
        buffer.writeln(
          '            <div style="font-weight: 800; font-size: 11pt; color: #3b82f6; margin-bottom: 8px; text-transform: uppercase;">${s['title']}</div>',
        );
        buffer.writeln(
          '            <div style="font-size: 10.5pt; line-height: 1.8; color: #334155; text-align: justify;">${s['content']}</div>',
        );
        buffer.writeln('          </div>');
      }

      buffer.writeln('    </div>');
      buffer.writeln('  </div>');
    }

    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  void _download() {
    // HTML 기반 PDF 생성이므로 새 창에서 다시 열기
    if (_blobUrl != null) {
      html.window.open(_blobUrl!, '_blank');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('새 창에서 Ctrl+P를 눌러 "PDF로 저장"을 선택하세요'),
            backgroundColor: Color(0xFFC1D72E),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepSpace,
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Resume Export',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            if (!_isProcessing && _finalBytes == null) ...[
              const Text(
                '포함할 문서 선택',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('이력서', style: TextStyle(color: Colors.white)),
                value: _includeResume,
                onChanged: widget.resume != null
                    ? (value) => setState(() => _includeResume = value ?? false)
                    : null,
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  '경력기술서',
                  style: TextStyle(color: Colors.white),
                ),
                value: _includeCareerHistory,
                onChanged: widget.resume != null
                    ? (value) =>
                          setState(() => _includeCareerHistory = value ?? false)
                    : null,
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
              CheckboxListTile(
                title: const Text(
                  '자기소개서',
                  style: TextStyle(color: Colors.white),
                ),
                value: _includeCoverLetter,
                onChanged: widget.coverLetter != null
                    ? (value) =>
                          setState(() => _includeCoverLetter = value ?? false)
                    : null,
                activeColor: AppColors.primaryBlue,
                checkColor: Colors.white,
              ),
            ],

            Expanded(
              child: _isProcessing
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  : _finalBytes != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.highlightGreen,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'PDF Ready!',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text('Download Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.highlightGreen,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(200, 60),
                            ),
                            onPressed: _download,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),

            if (!_isProcessing && _finalBytes == null) ...[
              const SizedBox(height: 20),
              if (_statusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _generatePdf,
                    child: const Text('Generate PDF'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
