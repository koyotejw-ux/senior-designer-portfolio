import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';
import '../../domain/models/document_model.dart';
import '../widgets/document_card.dart';
import '../widgets/document_viewer.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage>
    with SingleTickerProviderStateMixin {
  DocumentType? selectedType;
  String? selectedDocumentId;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  // Real data from actual PDFs - 정재웅 (19년 경력)
  final List<DocumentModel> _documents = [
    DocumentModel(
      id: '1',
      type: DocumentType.resume,
      title: '이력서 정재웅',
      version: 'v07',
      createdAt: DateTime(2025, 7, 22),
      updatedAt: DateTime(2025, 7, 22),
      pdfUrl: 'D:\\01.이력서\\250722\\이력서_정재웅_07.pdf',
      content: {
        'summary': '19년 경력의 시니어 UX/UI 디자이너 및 프로덕트 디자이너',
        'highlights': [
          '아이엔지피플, 현대HT, NEXON 등 대기업 경력',
          'AI/ML 기반 디자인 시스템 전문가',
          'Flutter 개발 및 데이터 분석 역량',
          '350만+ 누적 사용자 경험',
        ],
      },
      tags: ['경력 19년', '대기업', 'AI/ML', 'UX 전문'],
    ),
    DocumentModel(
      id: '2',
      type: DocumentType.portfolio,
      title: '포트폴리오 정재웅',
      version: 'v07',
      createdAt: DateTime(2025, 7, 22),
      updatedAt: DateTime(2025, 7, 22),
      pdfUrl: 'D:\\01.이력서\\250722\\포트폴리오_정재웅_07.pdf',
      content: {
        'summary': '실제 프로젝트 케이스 스터디 및 성과 중심 포트폴리오',
        'projects': [
          'AIA+ SENIOR MODE',
          'HYUNDAI HT WALLPAD',
          'HT HOME 2.0',
          'SOULARK',
          'CLOSERS',
        ],
      },
      tags: ['케이스 스터디', 'UX 전략', '성과 중심', '100+ 프로젝트'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(
                    animationValue: _floatingController.value,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),

          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 100,
              left: isMobile ? 20 : (isTablet ? 40 : 80),
              right: isMobile ? 20 : (isTablet ? 40 : 80),
              bottom: 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title with gradient and animation
                ScrollRevealWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: isMobile ? 48 : (isTablet ? 64 : 80),
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                          height: 1.1,
                          letterSpacing: -2,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms)
                          .shimmer(
                            duration: 2000.ms,
                            delay: 800.ms,
                            color: isDark
                                ? AppColors.accentCyan.withValues(alpha: 0.3)
                                : AppColors.primaryBlue.withValues(alpha: 0.2),
                          ),
                      const SizedBox(height: 16),
                      Text(
                        '이력서, 경력기술서, 자기소개서, 포트폴리오를 확인하세요',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                          height: 1.6,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Document Type Filter
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 100),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildFilterChip(
                        label: '전체',
                        isSelected: selectedType == null,
                        onTap: () => setState(() => selectedType = null),
                        isDark: isDark,
                      ),
                      ...DocumentType.values.map(
                        (type) => _buildFilterChip(
                          label: type.displayName,
                          isSelected: selectedType == type,
                          onTap: () => setState(() => selectedType = type),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Document Grid
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 200),
                  child: _buildDocumentGrid(isMobile, isTablet, isDark),
                ),

                // Document Viewer (if selected)
                if (selectedDocumentId != null) ...[
                  const SizedBox(height: 60),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 300),
                    child: DocumentViewer(
                      document: _documents.firstWhere(
                        (doc) => doc.id == selectedDocumentId,
                      ),
                      onClose: () => setState(() => selectedDocumentId = null),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(showLogo: true),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
              : (isDark
                  ? AppColors.blue900.withValues(alpha: 0.3)
                  : AppColors.lightGray200),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.gray300 : AppColors.lightGray700),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentGrid(bool isMobile, bool isTablet, bool isDark) {
    final filteredDocs = selectedType == null
        ? _documents
        : _documents.where((doc) => doc.type == selectedType).toList();

    if (filteredDocs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Text(
            '문서가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.gray500 : AppColors.lightGray500,
            ),
          ),
        ),
      );
    }

    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isMobile ? 1.2 : 0.85,
      ),
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final doc = filteredDocs[index];
        return DocumentCard(
          document: doc,
          onTap: () {
            // Navigate to the appropriate page based on document type
            switch (doc.type) {
              case DocumentType.resume:
                context.go('/resume');
                break;
              case DocumentType.careerDescription:
                context.go('/career-description');
                break;
              case DocumentType.coverLetter:
                context.go('/cover-letter');
                break;
              case DocumentType.portfolio:
                context.go('/portfolio');
                break;
            }
          },
        );
      },
    );
  }
}

// Animated Background Painter for premium floating effect
class BackgroundPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  BackgroundPainter({
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    // Draw 3 floating circles with different colors and movements
    for (int i = 0; i < 3; i++) {
      final offset = math.sin((animationValue * 2 * math.pi) + (i * 0.5)) * 30;
      final opacity = 0.03 + (math.sin(animationValue * math.pi) * 0.02);

      Color circleColor;
      if (i == 0) {
        circleColor = isDark
            ? AppColors.primaryBlue.withValues(alpha: opacity)
            : AppColors.primaryBlue.withValues(alpha: opacity * 0.5);
      } else if (i == 1) {
        circleColor = isDark
            ? AppColors.accentCyan.withValues(alpha: opacity)
            : AppColors.accentCyan.withValues(alpha: opacity * 0.5);
      } else {
        circleColor = isDark
            ? AppColors.highlightGreen.withValues(alpha: opacity * 0.8)
            : AppColors.highlightGreen.withValues(alpha: opacity * 0.4);
      }

      paint.color = circleColor;

      final centerX = size.width * (0.2 + (i * 0.3));
      final centerY = (size.height * (0.3 + (i * 0.2))) + offset;
      final radius = 150.0 + (i * 50);

      canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    }

    // Draw subtle connecting lines between circles
    if (isDark) {
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.accentCyan.withValues(alpha: 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      for (int i = 0; i < 2; i++) {
        final offset1 = math.sin((animationValue * 2 * math.pi) + (i * 0.5)) * 30;
        final offset2 =
            math.sin((animationValue * 2 * math.pi) + ((i + 1) * 0.5)) * 30;

        final x1 = size.width * (0.2 + (i * 0.3));
        final y1 = (size.height * (0.3 + (i * 0.2))) + offset1;

        final x2 = size.width * (0.2 + ((i + 1) * 0.3));
        final y2 = (size.height * (0.3 + ((i + 1) * 0.2))) + offset2;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDark != isDark;
  }
}
