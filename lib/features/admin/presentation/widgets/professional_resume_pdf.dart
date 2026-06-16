import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../home/data/models/resume_model.dart';

/// Professional PDF generator for resume documents
/// Creates corporate-grade, simple and elegant PDF layouts
class ProfessionalResumePDF {
  // Corporate colors - Simple and professional
  static final PdfColor primaryColor = PdfColor.fromHex('#1a1a1a'); // Dark gray
  static final PdfColor accentColor = PdfColor.fromHex('#2563eb'); // Professional blue
  static final PdfColor lightGray = PdfColor.fromHex('#f3f4f6');
  static final PdfColor textGray = PdfColor.fromHex('#4b5563');

  // Cached fonts
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// Load Korean fonts (Pretendard from CDN)
  static Future<void> _loadFonts() async {
    if (_regularFont != null && _boldFont != null) return;

    try {
      // Download Pretendard fonts from CDN
      final regularResponse = await http.get(
        Uri.parse('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Regular.ttf'),
      );
      final boldResponse = await http.get(
        Uri.parse('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/public/static/Pretendard-Bold.ttf'),
      );

      if (regularResponse.statusCode == 200 && boldResponse.statusCode == 200) {
        _regularFont = pw.Font.ttf(regularResponse.bodyBytes.buffer.asByteData());
        _boldFont = pw.Font.ttf(boldResponse.bodyBytes.buffer.asByteData());
        debugPrint('Pretendard fonts loaded successfully');
      } else {
        debugPrint('Failed to download Pretendard fonts: ${regularResponse.statusCode}, ${boldResponse.statusCode}');
        // Fallback to system fonts
        await _loadFallbackFonts();
      }
    } catch (e) {
      debugPrint('Error loading Pretendard fonts: $e');
      await _loadFallbackFonts();
    }
  }

  /// Load fallback Korean fonts (Noto Sans KR as backup)
  static Future<void> _loadFallbackFonts() async {
    try {
      final regularResponse = await http.get(
        Uri.parse('https://cdn.jsdelivr.net/npm/noto-sans-kr@0.1.1/fonts/NotoSansKR-Regular.otf'),
      );
      final boldResponse = await http.get(
        Uri.parse('https://cdn.jsdelivr.net/npm/noto-sans-kr@0.1.1/fonts/NotoSansKR-Bold.otf'),
      );

      if (regularResponse.statusCode == 200 && boldResponse.statusCode == 200) {
        _regularFont = pw.Font.ttf(regularResponse.bodyBytes.buffer.asByteData());
        _boldFont = pw.Font.ttf(boldResponse.bodyBytes.buffer.asByteData());
        debugPrint('Fallback Noto Sans KR fonts loaded');
      } else {
        debugPrint('Fallback fonts also failed to load');
      }
    } catch (e) {
      debugPrint('Fallback font loading error: $e');
    }
  }

  /// Get text style with Korean font support
  static pw.TextStyle _textStyle({
    double fontSize = 10,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor? color,
    double? height,
  }) {
    return pw.TextStyle(
      font: fontWeight == pw.FontWeight.bold ? _boldFont : _regularFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Generate Resume PDF (이력서)
  static Future<Uint8List> generateResumePDF(ResumeModel resume) async {
    // Load Korean fonts first
    await _loadFonts();

    final pdf = pw.Document();

    // Download profile photo if available
    pw.MemoryImage? profileImage;
    if (resume.photoUrl != null) {
      try {
        final response = await http.get(Uri.parse(resume.photoUrl!));
        if (response.statusCode == 200) {
          profileImage = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        debugPrint('Failed to load profile photo: $e');
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: _regularFont,
          bold: _boldFont,
        ),
        build: (context) => [
          // Header with photo
          _buildResumeHeader(resume, profileImage),
          pw.SizedBox(height: 24),

          // Personal Information
          _buildSection('인적사항', [
            _buildInfoTable([
              ['성명', resume.personalInfo.name, '생년월일', resume.personalInfo.birthDate],
              ['주소', resume.personalInfo.address, '', ''],
              ['휴대전화', resume.personalInfo.phone, '이메일', resume.personalInfo.email],
              ['병역사항', resume.personalInfo.militaryService, '', ''],
            ]),
          ]),

          pw.SizedBox(height: 20),

          // Education
          _buildSection('학력사항', [
            _buildTable(
              headers: ['기간', '학교명', '전공', '학점'],
              rows: resume.education.map((edu) => [
                edu.period,
                edu.institution,
                edu.major,
                edu.gpa,
              ]).toList(),
            ),
          ]),

          pw.SizedBox(height: 20),

          // Career Summary
          _buildSection('경력사항', [
            _buildTable(
              headers: ['근무기간', '회사명', '부서', '직위'],
              rows: resume.careers.map((career) => [
                career.period,
                career.company,
                career.department,
                career.position,
              ]).toList(),
            ),
          ]),

          pw.SizedBox(height: 20),

          // Core Competencies
          _buildSection('핵심역량', [
            ...resume.coreCompetencies.map((comp) =>
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 6),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ', style: pw.TextStyle(fontSize: 10, color: accentColor)),
                    pw.Expanded(
                      child: pw.Text(comp, style: const pw.TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ]),

          pw.SizedBox(height: 20),

          // Certifications
          _buildSection('자격사항', [
            _buildTable(
              headers: ['자격증명', '발급기관', '취득일'],
              rows: resume.certifications.map((cert) => [
                cert.name,
                cert.issuer,
                cert.date,
              ]).toList(),
            ),
          ]),

          pw.Spacer(),

          // Footer
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                  style: pw.TextStyle(fontSize: 9, color: textGray),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  '작성자: ${resume.personalInfo.name}   (인)',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate Career History PDF (경력증명서)
  static Future<Uint8List> generateCareerPDF(ResumeModel resume) async {
    // Load Korean fonts first
    await _loadFonts();

    final pdf = pw.Document();

    // Download profile photo if available
    pw.MemoryImage? profileImage;
    if (resume.photoUrl != null) {
      try {
        final response = await http.get(Uri.parse(resume.photoUrl!));
        if (response.statusCode == 200) {
          profileImage = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        debugPrint('Failed to load profile photo: $e');
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: _regularFont,
          bold: _boldFont,
        ),
        build: (context) => [
          // Header with photo
          _buildCareerHeader(resume, profileImage),
          pw.SizedBox(height: 30),

          // Career Details
          ...resume.careers.asMap().entries.map((entry) {
            final index = entry.key;
            final career = entry.value;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (index > 0) pw.SizedBox(height: 24),

                // Company Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: lightGray,
                    border: pw.Border.all(color: accentColor, width: 1),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          '${career.company} / ${career.department}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      pw.Text(
                        career.period,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 8),

                // Position & Role
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: pw.Text(
                    '직위: ${career.position} / 역할: ${career.role}',
                    style: pw.TextStyle(fontSize: 10, color: textGray),
                  ),
                ),

                // Projects
                if (career.projects.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  _buildCareerSubSection('주요 프로젝트', career.projects),
                ],

                // Achievements
                if (career.achievements.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  _buildCareerSubSection('주요 성과', career.achievements),
                ],

                // Tools & Environment
                pw.SizedBox(height: 8),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 80,
                        child: pw.Text(
                          '사용 기술:',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: textGray,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          career.tools.join(', '),
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                ),

                if (career.environment != null && career.environment!.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 80,
                          child: pw.Text(
                            '개발 환경:',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: textGray,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            career.environment!,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (career.resignationReason != null && career.resignationReason!.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 80,
                          child: pw.Text(
                            '퇴사 사유:',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: textGray,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            career.resignationReason!,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),

          pw.Spacer(),

          // Footer
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                  style: pw.TextStyle(fontSize: 9, color: textGray),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  '작성자: ${resume.personalInfo.name}   (인)',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate Cover Letter PDF (자기소개서)
  static Future<Uint8List> generateCoverLetterPDF(
    ResumeModel resume,
    CoverLetterModel coverLetter,
  ) async {
    // Load Korean fonts first
    await _loadFonts();

    final pdf = pw.Document();

    // Download profile photo if available
    pw.MemoryImage? profileImage;
    if (resume.photoUrl != null) {
      try {
        final response = await http.get(Uri.parse(resume.photoUrl!));
        if (response.statusCode == 200) {
          profileImage = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        debugPrint('Failed to load profile photo: $e');
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: _regularFont,
          bold: _boldFont,
        ),
        build: (context) => [
          // Header with photo
          _buildCoverLetterHeader(resume, profileImage),
          pw.SizedBox(height: 30),

          // Greeting
          _buildCoverLetterSection('인사말', coverLetter.greeting),
          pw.SizedBox(height: 16),

          // Background
          _buildCoverLetterSection('성장배경', coverLetter.background),
          pw.SizedBox(height: 16),

          // Personality
          _buildCoverLetterSection('성격의 장단점', coverLetter.personality),
          pw.SizedBox(height: 16),

          // Hobbies
          _buildCoverLetterSection('생활신조 및 취미', coverLetter.hobbies),
          pw.SizedBox(height: 16),

          // Aspiration
          _buildCoverLetterSection('입사 후 포부', coverLetter.aspiration),

          pw.Spacer(),

          // Footer
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                  style: pw.TextStyle(fontSize: 9, color: textGray),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  '작성자: ${resume.personalInfo.name}   (인)',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate Combined PDF (전체 문서)
  static Future<Uint8List> generateCombinedPDF(
    ResumeModel resume,
    CoverLetterModel coverLetter,
    {
      required bool includeResume,
      required bool includeCareer,
      required bool includeCoverLetter,
    }
  ) async {
    // Load Korean fonts first
    await _loadFonts();

    final pdf = pw.Document();

    // Download profile photo if available
    pw.MemoryImage? profileImage;
    if (resume.photoUrl != null) {
      try {
        final response = await http.get(Uri.parse(resume.photoUrl!));
        if (response.statusCode == 200) {
          profileImage = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        debugPrint('Failed to load profile photo: $e');
      }
    }

    // Add Resume Pages
    if (includeResume) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: _regularFont,
            bold: _boldFont,
          ),
          build: (context) => _buildResumeContent(resume, profileImage),
        ),
      );
    }

    // Add Career Pages
    if (includeCareer) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: _regularFont,
            bold: _boldFont,
          ),
          build: (context) => _buildCareerContent(resume, profileImage),
        ),
      );
    }

    // Add Cover Letter Pages
    if (includeCoverLetter) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: _regularFont,
            bold: _boldFont,
          ),
          build: (context) => _buildCoverLetterContent(resume, coverLetter, profileImage),
        ),
      );
    }

    return pdf.save();
  }

  // Helper methods for building PDF sections

  static pw.Widget _buildResumeHeader(ResumeModel resume, pw.MemoryImage? profileImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '이력서',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: 60,
                height: 3,
                color: accentColor,
              ),
            ],
          ),
        ),
        if (profileImage != null)
          pw.Container(
            width: 90,
            height: 120,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: textGray, width: 1),
            ),
            child: pw.Image(profileImage, fit: pw.BoxFit.cover),
          ),
      ],
    );
  }

  static pw.Widget _buildCareerHeader(ResumeModel resume, pw.MemoryImage? profileImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '경력증명서',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: 80,
                height: 3,
                color: accentColor,
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                '성명: ${resume.personalInfo.name}',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        if (profileImage != null)
          pw.Container(
            width: 90,
            height: 120,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: textGray, width: 1),
            ),
            child: pw.Image(profileImage, fit: pw.BoxFit.cover),
          ),
      ],
    );
  }

  static pw.Widget _buildCoverLetterHeader(ResumeModel resume, pw.MemoryImage? profileImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '자기소개서',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: 80,
                height: 3,
                color: accentColor,
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                '성명: ${resume.personalInfo.name}',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        if (profileImage != null)
          pw.Container(
            width: 90,
            height: 120,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: textGray, width: 1),
            ),
            child: pw.Image(profileImage, fit: pw.BoxFit.cover),
          ),
      ],
    );
  }

  static pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: lightGray,
            border: pw.Border(
              left: pw.BorderSide(color: accentColor, width: 3),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        ...children,
      ],
    );
  }

  static pw.Widget _buildInfoTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      children: rows.map((row) {
        return pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              color: lightGray,
              child: pw.Text(
                row[0],
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: textGray,
                ),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(row[1], style: const pw.TextStyle(fontSize: 9)),
            ),
            if (row.length > 2)
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                color: lightGray,
                child: pw.Text(
                  row[2],
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: textGray,
                  ),
                ),
              ),
            if (row.length > 3)
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(row[3], style: const pw.TextStyle(fontSize: 9)),
              ),
          ],
        );
      }).toList(),
    );
  }

  static pw.Widget _buildTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: lightGray),
          children: headers.map((header) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                header,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: pw.TextAlign.center,
              ),
            );
          }).toList(),
        ),
        // Data rows
        ...rows.map((row) {
          return pw.TableRow(
            children: row.map((cell) {
              return pw.Container(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  cell,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  static pw.Widget _buildCareerSubSection(String title, List<String> items) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: textGray,
            ),
          ),
          pw.SizedBox(height: 4),
          ...items.map((item) =>
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 3),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('• ', style: pw.TextStyle(fontSize: 9, color: accentColor)),
                  pw.Expanded(
                    child: pw.Text(item, style: const pw.TextStyle(fontSize: 9)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCoverLetterSection(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: pw.BoxDecoration(
            color: lightGray,
            border: pw.Border(
              left: pw.BorderSide(color: accentColor, width: 3),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10),
          child: pw.Text(
            content,
            style: pw.TextStyle(fontSize: 10, height: 1.6, color: primaryColor),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }

  // Content builders for combined PDF
  static List<pw.Widget> _buildResumeContent(ResumeModel resume, pw.MemoryImage? profileImage) {
    return [
      _buildResumeHeader(resume, profileImage),
      pw.SizedBox(height: 24),
      _buildSection('인적사항', [
        _buildInfoTable([
          ['성명', resume.personalInfo.name, '생년월일', resume.personalInfo.birthDate],
          ['주소', resume.personalInfo.address, '', ''],
          ['휴대전화', resume.personalInfo.phone, '이메일', resume.personalInfo.email],
          ['병역사항', resume.personalInfo.militaryService, '', ''],
        ]),
      ]),
      pw.SizedBox(height: 20),
      _buildSection('학력사항', [
        _buildTable(
          headers: ['기간', '학교명', '전공', '학점'],
          rows: resume.education.map((edu) => [
            edu.period,
            edu.institution,
            edu.major,
            edu.gpa,
          ]).toList(),
        ),
      ]),
      pw.SizedBox(height: 20),
      _buildSection('경력사항', [
        _buildTable(
          headers: ['근무기간', '회사명', '부서', '직위'],
          rows: resume.careers.map((career) => [
            career.period,
            career.company,
            career.department,
            career.position,
          ]).toList(),
        ),
      ]),
      pw.SizedBox(height: 20),
      _buildSection('핵심역량', [
        ...resume.coreCompetencies.map((comp) =>
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 16, bottom: 6),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(fontSize: 10, color: accentColor)),
                pw.Expanded(
                  child: pw.Text(comp, style: const pw.TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ]),
      pw.SizedBox(height: 20),
      _buildSection('자격사항', [
        _buildTable(
          headers: ['자격증명', '발급기관', '취득일'],
          rows: resume.certifications.map((cert) => [
            cert.name,
            cert.issuer,
            cert.date,
          ]).toList(),
        ),
      ]),
      pw.Spacer(),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
              style: pw.TextStyle(fontSize: 9, color: textGray),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '작성자: ${resume.personalInfo.name}   (인)',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    ];
  }

  static List<pw.Widget> _buildCareerContent(ResumeModel resume, pw.MemoryImage? profileImage) {
    return [
      _buildCareerHeader(resume, profileImage),
      pw.SizedBox(height: 30),
      ...resume.careers.asMap().entries.map((entry) {
        final index = entry.key;
        final career = entry.value;

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (index > 0) pw.SizedBox(height: 24),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: lightGray,
                border: pw.Border.all(color: accentColor, width: 1),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      '${career.company} / ${career.department}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  pw.Text(
                    career.period,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: pw.Text(
                '직위: ${career.position} / 역할: ${career.role}',
                style: pw.TextStyle(fontSize: 10, color: textGray),
              ),
            ),
            if (career.projects.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              _buildCareerSubSection('주요 프로젝트', career.projects),
            ],
            if (career.achievements.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              _buildCareerSubSection('주요 성과', career.achievements),
            ],
            pw.SizedBox(height: 8),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 80,
                    child: pw.Text(
                      '사용 기술:',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: textGray,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      career.tools.join(', '),
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      pw.Spacer(),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
              style: pw.TextStyle(fontSize: 9, color: textGray),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '작성자: ${resume.personalInfo.name}   (인)',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    ];
  }

  static List<pw.Widget> _buildCoverLetterContent(
    ResumeModel resume,
    CoverLetterModel coverLetter,
    pw.MemoryImage? profileImage,
  ) {
    return [
      _buildCoverLetterHeader(resume, profileImage),
      pw.SizedBox(height: 30),
      _buildCoverLetterSection('인사말', coverLetter.greeting),
      pw.SizedBox(height: 16),
      _buildCoverLetterSection('성장배경', coverLetter.background),
      pw.SizedBox(height: 16),
      _buildCoverLetterSection('성격의 장단점', coverLetter.personality),
      pw.SizedBox(height: 16),
      _buildCoverLetterSection('생활신조 및 취미', coverLetter.hobbies),
      pw.SizedBox(height: 16),
      _buildCoverLetterSection('입사 후 포부', coverLetter.aspiration),
      pw.Spacer(),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              '작성일: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
              style: pw.TextStyle(fontSize: 9, color: textGray),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              '작성자: ${resume.personalInfo.name}   (인)',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    ];
  }

  /// Download PDF with given bytes and filename
  static void downloadPDF(Uint8List bytes, String filename) {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$filename.pdf')
      ..style.display = 'none';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
