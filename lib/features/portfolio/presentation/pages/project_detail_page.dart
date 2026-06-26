import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';
import '../../../home/data/models/project_model.dart';
import '../../../home/data/providers/content_provider.dart';
import '../../../home/presentation/widgets/web_optimized_image.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Keep hardcoded data for demo purposes
  final Map<String, Map<String, dynamic>> _projectData = {
    'aia-senior-mode': {
      'title': 'AIA+ SENIOR MODE',
      'subtitle': '고령자 전용 모드 UX/UI 디자인 시스템',
      'company': '아이엔지피플',
      'year': '2025.01-2025.06',
      'category': 'Mobile App',
      'gradient': const [Color(0xFFD31145), Color(0xFFFF4B4B)],
      'role': 'Senior Product Designer',
      'duration': '6개월 (2025.01-2025.06)',
      'teamSize': '8명 (디자이너 2명, 개발자 4명, PM 2명)',
      'overview':
          'AIA 생명 앱의 고령자 전용 모드를 설계하여 시니어 사용자의 디지털 접근성을 획기적으로 개선한 프로젝트입니다. 보험료 납입, 보험계약대출 상환, 자동부활 신청 등 핵심 보험 업무를 고령자가 쉽게 처리할 수 있도록 UX/UI를 전면 재설계했습니다.',
      'challenges': [
        '고령자의 스마트폰 사용 패턴 연구 및 페르소나 정의',
        '시력 저하, 터치 정확도 감소 등 신체적 제약 극복',
        '복잡한 보험 업무를 3단계 이내로 단순화',
        '기존 일반 모드와의 일관성 유지 및 전환 최적화',
      ],
      'solutions': [
        '접근성 가이드라인 수립: 터치 영역 44px 이상, 폰트 크기 18px 이상 적용',
        '3단계 이내 목표 도달 UX 설계: 복잡한 업무 플로우 단순화',
        'Figma 기반 디자인 시스템 구축: 일관된 UI 컴포넌트 제공',
        '실사용자 테스트 5회 반복: 시니어 20명 대상 사용성 검증',
      ],
      'achievements': [
        '고령자 전용 접근성 가이드라인 수립 (회사 최초)',
        '터치 영역 44px 이상, 폰트 크기 18px 이상 적용',
        '핵심 기능 3단계 이내 도달 UX 설계',
        'Figma 기반 디자인 시스템 구축 (컴포넌트 50+)',
        '시니어 사용성 테스트 만족도 92% 달성',
      ],
      'technologies': [
        'Figma',
        'Mobile UX',
        'Accessibility',
        'Design System',
        'User Testing',
      ],
      'process': [
        {
          'phase': 'Research',
          'title': '사용자 리서치',
          'description':
              '고령자 20명 대상 인터뷰 및 관찰을 통해 스마트폰 사용 패턴 분석. 시력 저하, 터치 정확도 감소 등 신체적 제약 파악.',
        },
        {
          'phase': 'Analysis',
          'title': '페르소나 정의',
          'description': '65세 이상 고령자 페르소나 3종 정의. 각 페르소나별 니즈와 사용 시나리오 매핑.',
        },
        {
          'phase': 'Design',
          'title': 'UX/UI 디자인',
          'description': '접근성 가이드라인 기반 UI 컴포넌트 설계. 대형 터치 영역, 고대비 색상, 큰 폰트 적용.',
        },
        {
          'phase': 'Validation',
          'title': '사용성 테스트',
          'description': '시니어 20명 대상 5회 반복 테스트. 피드백 반영하여 UI 개선. 최종 만족도 92% 달성.',
        },
      ],
    },
    // ... (other hardcoded projects can remain if needed, but for brevity I'll rely on the provider for new ones)
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    // Try to find in provider first
    final projects = ref.watch(projectsProvider).valueOrNull ?? [];
    final projectModel = projects.firstWhere(
      (p) => p.id == widget.projectId,
      orElse: () => ProjectModel(
        id: '',
        title: '',
        subtitle: '',
        company: '',
        year: '',
        category: '',
        description: '',
        tags: [],
        gradientColors: [],
      ), // Dummy empty
    );

    // If not in provider (empty id), check hardcoded
    Map<String, dynamic>? projectData;
    if (projectModel.id.isEmpty) {
      projectData = _projectData[widget.projectId];
    } else {
      final lookupKey = widget.projectId == 'p1' ? 'aia-senior-mode' : widget.projectId;
      final hardcodedData = _projectData[lookupKey] ?? {};

      // Convert ProjectModel to Map for consistent rendering logic
      projectData = {
        'title': projectModel.title,
        'subtitle': projectModel.subtitle,
        'company': projectModel.company,
        'year': projectModel.year,
        'category': projectModel.category,
        'gradient': () {
            // gradientColors can be List<String> (hex) or List<Color>
            final gc = projectModel.gradientColors;
            if (gc.isEmpty) return [AppColors.primaryBlue, AppColors.accentCyan];
            try {
              return gc.map((c) {
                if (c is Color) return c;
                // Parse hex string like '#0056B3' or '0056B3'
                final hex = c.toString().replaceAll('#', '').trim();
                final fullHex = hex.length == 6 ? 'FF$hex' : hex;
                return Color(int.parse(fullHex, radix: 16));
              }).toList();
            } catch (_) {
              return [AppColors.primaryBlue, AppColors.accentCyan];
            }
          }(),
        'role': projectModel.role ?? hardcodedData['role'] ?? 'Designer',
        'duration': projectModel.duration ?? hardcodedData['duration'] ?? projectModel.year,
        'teamSize': projectModel.teamSize ?? hardcodedData['teamSize'] ?? '-',
        'overview': projectModel.description,
        'challenges': hardcodedData['challenges'] ?? <String>[],
        'solutions': hardcodedData['solutions'] ?? <String>[],
        'achievements': hardcodedData['achievements'] ?? <String>[],
        'technologies': projectModel.tags,
        'process': hardcodedData['process'] ?? <Map<String, String>>[],
        'imageUrl': projectModel.imageUrl,
        'mainScreenImages': projectModel.mainScreenImages,
        'designSystem': projectModel.designSystem,
      };
    }

    print('PROJECT DETAIL PAGE - ID: ${widget.projectId}, TITLE: ${projectData?["title"]}, IMAGES: ${projectData?["mainScreenImages"]}');

    if (projectData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Project not found',
                style: AppTypography.h4.copyWith(
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                ),
              ),
              const SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/portfolio'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Back to Portfolio',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isAia = widget.projectId == 'p1';
    final isSamMes = widget.projectId == 'p8';
    final hideDetails = isAia || isSamMes;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _animationController,
                isDark: isDark,
                gradient: projectData['gradient'] as List<Color>,
              ),
              size: Size.infinite,
            ),
          ),

          // Main Content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
              children: [
                // Back Button
                _buildBackButton(isMobile, isDark),

                // Hero Section
                _buildHeroSection(projectData, isMobile, isTablet, isDark),

                // Project Image(s)
                _buildProjectImages(
                  projectData,
                  isMobile,
                  isTablet,
                ),

                // Project Info
                if (!hideDetails) _buildProjectInfo(projectData, isMobile, isTablet, isDark),

                // Overview
                if (!hideDetails) _buildOverview(projectData, isMobile, isTablet, isDark),

                // Challenges & Solutions (Only if available)
                if (!hideDetails && (projectData['challenges'] as List).isNotEmpty)
                  _buildChallengesSolutions(
                    projectData,
                    isMobile,
                    isTablet,
                    isDark,
                  ),

                // Main Screens Gallery (New)
                if (!hideDetails &&
                    !((projectData['company']?.toString().toLowerCase().contains('hyundai ht') == true ||
                       projectData['company']?.toString().contains('현대에이치티') == true) &&
                    (projectData['title']?.toString().toLowerCase().contains('wallpad') == true ||
                     projectData['title']?.toString().toLowerCase().contains('월패드') == true ||
                     projectData['title']?.toString().toLowerCase().contains('home') == true ||
                     projectData['title']?.toString().toLowerCase().contains('홈') == true)) &&
                    !(projectData['title']?.toString().toLowerCase().contains('soulark') == true ||
                     projectData['title']?.toString().toLowerCase().contains('소울아크') == true ||
                     projectData['title']?.toString().toLowerCase().contains('promotion') == true ||
                     projectData['title']?.toString().toLowerCase().contains('프로모션') == true ||
                     projectData['title']?.toString().toLowerCase().contains('farm') == true ||
                     projectData['title']?.toString().toLowerCase().contains('농가') == true ||
                     projectData['title']?.toString().toLowerCase().contains('농업') == true))
                  _buildGallery(
                    List<String>.from(projectData['mainScreenImages'] ?? []),
                    isMobile,
                    isTablet,
                    isDark,
                  ),

                // Design System Analysis (New)
                if (!hideDetails)
                   if (widget.projectId == 'p8' || widget.projectId == 'MES Solution Website Structure 2512291')
                     _buildDesignSystemSection(isDark: isDark)
                   else
                     _buildDesignSystem(projectData, isMobile, isTablet, isDark),

                // Process (Only if available)
                if (!hideDetails && (projectData['process'] as List).isNotEmpty)
                  _buildProcess(projectData, isMobile, isTablet, isDark),

                // Achievements (Only if available)
                if (!hideDetails && (projectData['achievements'] as List).isNotEmpty)
                  _buildAchievements(projectData, isMobile, isTablet, isDark),

                // Technologies
                if (!hideDetails && (projectData['technologies'] as List).isNotEmpty)
                  _buildTechnologies(projectData, isMobile, isTablet, isDark),

                // Navigation
                _buildNavigation(isMobile, isTablet, isDark),
              ],
            ),
           ),
          ),

          // AI Analysis Overlay (Optional, could be a FAB or a floating button)
        ],
      ),
    );
  }

  bool _isAnalyzing = false;

  void _analyzeDesignSystem(Map<String, dynamic> projectData) async {
    setState(() => _isAnalyzing = true);

    // Simulate AI Analysis
    await Future.delayed(const Duration(seconds: 3));

    // In a real app, this would call an API with projectData['mainScreenImages']
    // For now, we simulate by adding mock design system data

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        projectData['designSystem'] = DesignSystemModel(
          foundation: FoundationModel(
            colors: [
              '#0068B3 (Primary Blue)',
              '#009DDC (Accent Cyan)',
              '#F1F5F9 (Background)',
              '#1E293B (Dark Text)',
            ],
            typography: [
              'Pretendard 36pt (Display)',
              'Pretendard 18pt (Body)',
              'Pretendard 14pt (Label)',
            ],
            spacing: ['4px (XS)', '16px (MD)', '32px (XL)'],
          ),
          atomic: AtomicModel(
            atoms: ['System Icons', 'Rounded Buttons', 'Text Inputs'],
            molecules: ['Search Bar', 'Profile Card', 'Nav Item'],
            organisms: [
              'Main Header',
              'Project Filter Grid',
              'Bottom Navigation',
            ],
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI 디자인 시스템 분석이 완료되었습니다!'),
          backgroundColor: AppColors.highlightGreen,
        ),
      );
    }
  }

  Widget _buildGallery(
    List<String> images,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    if (images.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      title: 'Main Screens',
      content: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.lightGray300.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: images[index].startsWith('http')
                      ? Image.network(images[index], fit: BoxFit.cover)
                      : Image.asset(images[index], fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ),
      isMobile: isMobile,
      isTablet: isTablet,
      isDark: isDark,
      delay: const Duration(milliseconds: 1000),
    );
  }

    Widget _buildSpecSection({
    required String title,
    required Widget mobilePreview,
    required List<String> mobileDos,
    required List<String> mobileDonts,
    required Widget desktopPreview,
    required List<String> desktopDos,
    required List<String> desktopDonts,
    required bool isDark,
    required bool isMobileLayout,
  }) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    Widget buildColumnContent({
      required String deviceLabel,
      required Widget preview,
      required List<String> dos,
      required List<String> donts,
    }) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  deviceLabel.contains('모바일') ? Icons.phone_android : Icons.desktop_windows,
                  size: 16,
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),
                Text(
                  deviceLabel,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textMain),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(child: preview),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                const SizedBox(width: 6),
                Text('DO (권장 사항)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669))),
              ],
            ),
            const SizedBox(height: 6),
            ...dos.map((d) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)),
            )),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 14),
                const SizedBox(width: 6),
                Text("DON'T (금지 사항)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))),
              ],
            ),
            const SizedBox(height: 6),
            ...donts.map((d) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)),
            )),
          ],
        ),
      );
    }

    if (isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumnContent(
            deviceLabel: '모바일 (Mobile) 규격 명세',
            preview: mobilePreview,
            dos: mobileDos,
            donts: mobileDonts,
          ),
          const SizedBox(height: 20),
          buildColumnContent(
            deviceLabel: '태블릿 & 데스크톱 (Tablet & Desktop) 규격 명세',
            preview: desktopPreview,
            dos: desktopDos,
            donts: desktopDonts,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: buildColumnContent(
            deviceLabel: '모바일 (Mobile) 규격 명세',
            preview: mobilePreview,
            dos: mobileDos,
            donts: mobileDonts,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: buildColumnContent(
            deviceLabel: '태블릿 & 데스크톱 (Tablet & Desktop) 규격 명세',
            preview: desktopPreview,
            dos: desktopDos,
            donts: desktopDonts,
          ),
        ),
      ],
    );
  }

  Widget _buildDesignSystemSection({required bool isDark}) {
    const mesPrimaryBlue = Color(0xFF3B82F6);
    const mesSuccessGreen = Color(0xFF10B981);
    const mesWarningAmber = Color(0xFFF59E0B);
    const mesErrorRed = Color(0xFFEF4444);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final mesBgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      color: mesBgColor,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 24 : 60,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: mesPrimaryBlue.withOpacity(0.1),
                  border: Border.all(color: mesPrimaryBlue.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DESIGN SYSTEM SPEC',
                  style: TextStyle(
                    color: mesPrimaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '디자인시스템_최종',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: textMain,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SAM MES+ERP의 파운데이션, 이토믹 디자인 시스템, 대시보드 위젯을 모두 확인할 수 있습니다. 디자인 토큰 명명 규칙(Naming Rule)과 네이밍 명세(Spec)를 적용하여 대기업용 엔터프라이즈 환경에서 일관성 있고 확장 가능한 설계 프로세스를 수립했습니다.',
                style: TextStyle(
                  color: textSub,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('01. Foundation (기초 및 토큰 네이밍 룰)', '디자인 시스템의 기초 규격 및 디자인 토큰 체계'),
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: mesPrimaryBlue, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Design Token Naming Rule & Spec (디자인 토큰 명명 규칙 및 명세)',
                      style: TextStyle(color: textMain, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: textSub, fontSize: 13, height: 1.6, fontFamily: AppTypography.pretendard),
                        children: const [
                          TextSpan(
                            text: '명명 규칙 표준: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '--{category}-{type/use}-{scale/variant}\n',
                            style: TextStyle(fontFamily: 'monospace', color: mesPrimaryBlue, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Prefix', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': CSS 커스텀 속성 표준(--) 규격을 준수하여 웹 표준과 개발 호환성을 높임.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Category', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': color(색상), font(서체), space(여백), breakpoint(중단점)로 분류.\n'),
                          TextSpan(text: '• '),
                          TextSpan(text: 'Type/Use', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ': primary, semantic, functional, size, device 등의 세부 용도 기술.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Design Token Specification (토큰 명세)', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2.5),
                        2: FlexColumnWidth(1.8),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: borderColor, width: 0.5),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('카테고리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('토큰 패턴 (Token Pattern)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('사용 예시 (Example)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Color', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--color-{group}-{use}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('--color-primary-main', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: mesPrimaryBlue))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Typography', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--font-size-{size}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--font-size-h1 (24px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Spacing', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--spacing-{scale}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--spacing-lg (16px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Breakpoint', style: TextStyle(fontSize: 11, color: textMain))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--breakpoint-{device}', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('--breakpoint-tablet (768px)', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              Text('Color Tokens (라이트 / 다크모드 색상 명세)', style: TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(1.8),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: borderColor, width: 0.5),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('색상 분류', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('디자인 토큰명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Light Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: Colors.transparent),
                    _buildColorTokenTableRow('Primary', '--color-primary-main', const Color(0xFF3B82F6), '#3B82F6', const Color(0xFF1E5EFF), '#1E5EFF', isDark),
                    _buildColorTokenTableRow('Primary FG', '--color-primary-fg', Colors.white, '#FFFFFF', Colors.white, '#FFFFFF', isDark),
                    _buildColorTokenTableRow('Success', '--color-success-main', const Color(0xFF10B981), '#10B981', const Color(0xFF059669), '#059669', isDark),
                    _buildColorTokenTableRow('Warning', '--color-warning-main', const Color(0xFFF59E0B), '#F59E0B', const Color(0xFFD97706), '#D97706', isDark),
                    _buildColorTokenTableRow('Error', '--color-error-main', const Color(0xFFEF4444), '#EF4444', const Color(0xFFDC2626), '#DC2626', isDark),
                    _buildColorTokenTableRow('Bg Primary', '--color-bg-primary', Colors.white, '#FFFFFF', const Color(0xFF0F172A), '#0F172A', isDark),
                    _buildColorTokenTableRow('Bg Secondary', '--color-bg-secondary', const Color(0xFFF8FAFC), '#F8FAFC', const Color(0xFF1E293B), '#1E293B', isDark),
                    _buildColorTokenTableRow('Text Primary', '--color-text-primary', const Color(0xFF1F2937), '#1F2937', const Color(0xFFF9FAFB), '#F9FAFB', isDark),
                    _buildColorTokenTableRow('Border Light', '--color-border-light', const Color(0xFFE2E8F0), '#E2E8F0', const Color(0xFF334155), '#334155', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;
                  final itemWidth = isWideScreen ? (constraints.maxWidth - 40) / 2 : double.infinity;

                  return Wrap(
                    spacing: 40,
                    runSpacing: 30,
                    children: [
                      Container(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Typography (Pretendard 명세)', style: TextStyle(color: textSub, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _buildTypographyRow('Heading 1', '--font-size-h1', '24px Bold'),
                            _buildTypographyRow('Heading 2', '--font-size-h2', '20px Bold'),
                            _buildTypographyRow('Heading 3', '--font-size-h3', '18px Bold'),
                            _buildTypographyRow('Paragraph', '--font-size-body', '14px Regular'),
                            _buildTypographyRow('Small Text', '--font-size-small', '12px Regular'),
                          ],
                        ),
                      ),
                      Container(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Spacing Scale (여백 토큰)', style: TextStyle(color: textSub, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.0),
                                1: FlexColumnWidth(2.0),
                                2: FlexColumnWidth(1.5),
                              },
                              border: TableBorder(
                                horizontalInside: BorderSide(color: borderColor, width: 0.5),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('크기', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('토큰 패턴 (Token Pattern)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('실물 크기 (Visual)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textSub))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('xs (4px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-xs', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(4, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('sm (8px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-sm', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(8, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('md (12px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-md', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(12, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('lg (16px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-lg', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(16, '', isDark: isDark))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('xl (20px)', style: TextStyle(fontSize: 11, color: textMain))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('--spacing-xl', style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textSub))),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Align(alignment: Alignment.centerLeft, child: _buildSpacingBox(20, '', isDark: isDark))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('02. Atoms (원자 컴포넌트)', '가장 기본적인 UI 빌딩 블록 (버튼, 뱃지, 입력 필드)'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Atoms',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mesPrimaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('모바일 버튼 (Full Width)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesPrimaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('기본', style: TextStyle(color: mesPrimaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('성공', style: TextStyle(color: mesSuccessGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: mesErrorRed.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('삭제', style: TextStyle(color: mesErrorRed, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
                mobileDos: const [
                  '모바일 버튼은 터치 정확도를 확보하기 위해 높이 48px 및 가로 채우기(Full Width) 배치를 사용하십시오.',
                  '가장 중요한 액션 1개만 강조 색상 버튼으로 제공하십시오.'
                ],
                mobileDonts: const [
                  '가로로 3개 이상의 버튼을 일렬 배치하지 마십시오 (줄 바꿈 또는 세로 정렬 권장).',
                  '작은 화면에서 폰트 크기를 12px 미만으로 낮추지 마십시오.'
                ],
                desktopPreview: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text('신규 등록', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mesPrimaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textMain,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('취소', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                desktopDos: const [
                  '정밀 마우스 포인팅이 가능하므로 가로 간격(8px~12px)을 둔 인라인 배치를 적용하십시오.',
                  '기본 액션과 보조 액션(Cancel, Outline)을 명확히 구분하십시오.'
                ],
                desktopDonts: const [
                  '필요 이상으로 가로 길이를 넓혀 광활한 빈 공간을 만들지 마십시오.',
                  '단순 액션에 불필요하게 48px 이상의 대형 버튼을 남발하지 마십시오.'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('03. Molecules (분자 컴포넌트)', '기본 컴포넌트들을 조합한 단순 유닛 (드롭다운, 아코디언)'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Molecules',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('수주처 선택 (Bottom Sheet)', style: TextStyle(color: textMain, fontSize: 12)),
                      Icon(Icons.arrow_drop_down, size: 16, color: textSub),
                    ],
                  ),
                ),
                mobileDos: const [
                  '드롭다운 선택창 클릭 시 가독성 및 조작 용이성을 위해 하단 시트(Bottom Sheet) 모달 인터페이스를 제공하십시오.',
                  '옵션 텍스트는 1줄 이내로 표시하고 생략 기호(...)를 처리하십시오.'
                ],
                mobileDonts: const [
                  '모바일 뷰포트에서 마우스 호버 전용 드롭다운 메뉴를 설계하지 마십시오 (터치 호환 불가).',
                  '과도하게 긴 리스트를 모바일 인라인 팝오버로 띄우지 마십시오.'
                ],
                desktopPreview: Container(
                  width: 240,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('선택된 항목 표시', style: TextStyle(color: textMain, fontSize: 12)),
                      Icon(Icons.unfold_more, size: 16, color: textSub),
                    ],
                  ),
                ),
                desktopDos: const [
                  '마우스 스크롤이 가능한 인라인 팝오버 목록(Max Height: 250px)을 트리거 아래에 즉시 표시하십시오.',
                  '포커스 및 키보드 네비게이션(Arrow Keys) 접근성을 지원하십시오.'
                ],
                desktopDonts: const [
                  '드롭다운 선택 상자가 브라우저 경계선 바깥으로 잘려 나가지 않도록 오프셋 가이드라인을 준수하십시오.'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('04. Organisms (유기체 컴포넌트)', '원자/분자의 조합으로 구성된 완성도 높은 섹션 단위 및 업무용 카드'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Organisms',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Q-2024-001', style: TextStyle(color: textMain, fontSize: 11, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('승인', style: TextStyle(color: mesSuccessGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('서울 오피스텔 건설 프로젝트 수주 건', style: TextStyle(color: textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('삼성건설 | 25,600,000 원', style: TextStyle(color: textSub, fontSize: 10)),
                    ],
                  ),
                ),
                mobileDos: const [
                  '모바일 카드 컴포넌트는 모든 주요 정보를 수직 스택(Vertical Stack) 구조로 정렬하십시오.',
                  '상태 표시(Status Badge)는 카드 우측 상단에 정렬하여 빠르게 인지되도록 배포하십시오.'
                ],
                mobileDonts: const [
                  '가로 방향으로 다중 컬러칩이나 긴 문자열을 배치해 수평 스크롤이 발생하도록 만들지 마십시오.'
                ],
                desktopPreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Q-2024-001', style: TextStyle(color: textMain, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: mesSuccessGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: const Text('승인', style: TextStyle(color: mesSuccessGreen, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('서울 오피스텔 건설 프로젝트 수주 건', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('25,600,000 원', style: TextStyle(color: textMain, fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('삼성건설 (수주처)', style: TextStyle(color: textSub, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                desktopDos: const [
                  '가로 공간이 풍부하므로 정보 그룹(타이틀 정보 vs 메타 데이터 및 액션)을 양 끝단 배치(Space-Between)로 설계하여 스캔 가독성을 향상시키십시오.'
                ],
                desktopDonts: const [
                  '가로 폭이 넓어진다고 해서 모든 정보를 가로 한 줄에 빽빽하게 우겨넣지 마십시오 (필요한 컬럼만 명시적으로 구성).'
                ],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 30),

              _buildDSHeader('05. Templates (템플릿 표준)', '기본 컴포넌트와 유기체가 결합된 업무 화면 레이아웃 정의'),
              const SizedBox(height: 24),
              _buildSpecSection(
                title: 'Templates',
                isDark: isDark,
                isMobileLayout: isMobile,
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: mesPrimaryBlue.withOpacity(0.1),
                        child: const Center(child: Text('상단: 리스트 목록 (탭 전환/접기)', style: TextStyle(fontSize: 10, color: mesPrimaryBlue, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: mesSuccessGreen.withOpacity(0.1),
                        child: const Center(child: Text('하단: 상세 / 등록 양식 (단일화면 스택)', style: TextStyle(fontSize: 10, color: mesSuccessGreen, fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
                mobileDos: const [
                  '화면 높이 제한이 가로 제한보다 훨씬 크므로 목록형 보기와 상세 폼 보기를 탭(Tab) 또는 화면 단계 전환(Step Transition) 방식으로 단일 뷰 스택 배치를 구현하십시오.'
                ],
                mobileDonts: const [
                  '좌우 화면 분할Pane(Split layout)을 억지로 모바일에 삽입하여 양쪽 모두 오버플로우가 나게 하지 마십시오.'
                ],
                desktopPreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: mesPrimaryBlue.withOpacity(0.1),
                          child: const Center(child: Text('수주 목록 (좌측 Pane)', style: TextStyle(fontSize: 10, color: mesPrimaryBlue, fontWeight: FontWeight.bold))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: mesSuccessGreen.withOpacity(0.1),
                          child: const Center(child: Text('상세 내역 등록 및 정보 편집 (우측 Pane)', style: TextStyle(fontSize: 10, color: mesSuccessGreen, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                ),
                desktopDos: const [
                  '가로 화면을 100% 활용하기 위해 좌측 수주 목록-우측 상세(Split View, 4:6 비율) 표준을 적용하십시오.',
                  '가로 해상도가 축소될 때에도 유연한 반응형 Flex 비율을 유지하십시오.'
                ],
                desktopDonts: const [
                  '두 개 이상의 화면을 분할할 때 고정 너비(Width in px)를 지나치게 많이 지정해 가로 오버플로우가 나지 않도록 유의하십시오.'
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorTokenTableRow(String category, String token, Color lightColor, String lightHex, Color darkColor, String darkHex, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.8),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            children: [
              Text(category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: textMain)),
              Text(token, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF64748B))),
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: lightColor,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(lightHex, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF475569))),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: darkColor,
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(darkHex, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAdminManagementSection({required bool isDark}) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final slateDark = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF1F2937);
    final slateLight = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final bgDark = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      width: double.infinity,
      color: bgDark,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ADMIN MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '시스템 관리자 - 디자인시스템 관리',
                style: TextStyle(
                  fontFamily: AppTypography.pretendard,
                  color: slateDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '실제 운영 중인 SAM MES+ERP 시스템의 관리자 권한 전용 디자인시스템 관리자 화면입니다. 기초 토큰부터 컴포넌트, 디바이스별 반응형 중단점(Breakpoints)까지 실시간으로 커스텀하고 제어할 수 있는 어드민 콘솔 레이아웃을 확인하실 수 있습니다.',
                style: TextStyle(
                  color: textSub,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Mockup Window Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B0F19) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    // App Header
                    _buildAdminHeader(isDark),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 800;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isWide) _buildAdminSidebar(isDark),
                            Expanded(
                              child: _buildAdminWorkspace(isDark, isWide: isWide),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminHeader(bool isDark) {
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final logoColor = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgHeader = isDark ? const Color(0xFF111827) : Colors.white;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgHeader,
        border: Border(bottom: BorderSide(color: borderColor)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SAM',
                    style: TextStyle(
                      color: textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Smart Automation Management',
                    style: TextStyle(
                      color: textSub,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 200,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 14, color: textSub),
                const SizedBox(width: 6),
                Text(
                  '통합 검색...',
                  style: TextStyle(color: textSub, fontSize: 10),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 16, color: textSub),
              const SizedBox(width: 14),
              Stack(
                children: [
                  Icon(Icons.notifications_none_outlined, size: 18, color: textSub),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '최시스템',
                      style: TextStyle(color: textMain, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: logoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: logoColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '시스템관리자',
                  style: TextStyle(color: logoColor, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminSidebar(bool isDark) {
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryBlue = const Color(0xFF1E5EFF);
    final bgSidebar = isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB);

    return Container(
      width: 220,
      height: 480,
      decoration: BoxDecoration(
        color: bgSidebar,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildSidebarItem(Icons.dashboard_outlined, '시스템 대시보드', false, isDark),
          _buildSidebarItem(Icons.people_outline, '사용자 관리', false, isDark),
          _buildSidebarItem(Icons.tune_outlined, '메뉴 커스터마이징', false, isDark),
          _buildSidebarItem(Icons.info_outline, '기준정보 관리', false, isDark, hasChevron: true),
          _buildSidebarItem(Icons.color_lens_outlined, '디자인시스템관리', true, isDark, hasChevron: true),
          _buildSidebarSubItem('디자인시스템_최종', false, isDark),
          _buildSidebarSubItem('통합 디자인 시스템', false, isDark),
          _buildSidebarSubItem('디자인시스템 뷰어', false, isDark),
          _buildSidebarSubItem('컴포넌트 추출 도구', false, isDark),
          _buildSidebarSubItem('중앙 저장소', false, isDark),
          _buildSidebarSubItem('스타일 테스트', false, isDark),
          _buildSidebarSubItem('템플릿 비교', false, isDark),
          _buildSidebarSubItem('디자인시스템 관리', true, isDark),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive, bool isDark, {bool hasChevron = false}) {
    final activeBg = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isActive ? Colors.white : textSub),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : textMain,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (hasChevron)
            Icon(
              label == '디자인시스템관리' ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? Colors.white : textSub,
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarSubItem(String label, bool isActive, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryBlue = const Color(0xFF1E5EFF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      padding: const EdgeInsets.only(left: 32, right: 12, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: isActive ? primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? primaryBlue : textSub.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? primaryBlue : textMain.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildAdminWorkspace(bool isDark, {required bool isWide}) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgWorkspace = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      height: 480,
      color: bgWorkspace,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '디자인시스템 관리',
                    style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    'Foundation, Components, Tokens, Responsive 관리',
                    style: TextStyle(color: textSub, fontSize: 9),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.restore_outlined, size: 10, color: textMain),
                    const SizedBox(width: 4),
                    Text(
                      '견적관리 컴포넌트 복구',
                      style: TextStyle(color: textMain, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 12, color: textSub),
                const SizedBox(width: 8),
                Text(
                  'Foundation, Components, Tokens, Responsive 통합 검색...',
                  style: TextStyle(color: textSub, fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildAdminTabItem('Foundation', Icons.layers_outlined, true, isDark),
                      _buildAdminTabItem('Components', Icons.widgets_outlined, false, isDark),
                      _buildAdminTabItem('Modules', Icons.view_module_outlined, false, isDark),
                      _buildAdminTabItem('Tokens', Icons.code_outlined, false, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildAdminTabItem(String label, IconData icon, bool isActive, bool isDark) {
    final primaryBlue = const Color(0xFF1E5EFF);
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? const Color(0xFF1E293B) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? Border.all(color: primaryBlue, width: 1.2) : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isActive ? primaryBlue : textSub),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryBlue : textMain,
              fontSize: 9,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointCard(String device, String widthDesc, String deviceDesc, IconData icon, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF1E5EFF)),
              const SizedBox(width: 6),
              Text(
                device,
                style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widthDesc,
            style: TextStyle(color: textSub, fontSize: 8, height: 1.3),
          ),
          const SizedBox(height: 2),
          Text(
            deviceDesc,
            style: TextStyle(color: textSub.withValues(alpha: 0.7), fontSize: 8),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildBreakpointCardAction(Icons.edit_outlined, '수정', isDark),
              const SizedBox(width: 4),
              _buildBreakpointCardAction(Icons.delete_outline, '삭제', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointCardAction(IconData icon, String label, bool isDark) {
    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 8, color: textMain),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(color: textMain, fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildColorTokenCard(Color color, String name, String token, String hex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      width: isMobile ? double.infinity : 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  token,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontFamily: 'monospace',
                    fontSize: 8,
                  ),
                ),
                Text(
                  hex,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDSHeader(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyRow(String label, String token, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            token,
            style: const TextStyle(color: Color(0xFF64748B), fontFamily: 'monospace', fontSize: 10),
          ),
          Text(
            detail,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineCard(
    String code,
    String status,
    String title,
    String client,
    String price,
    String sub,
    Color codeColor,
    Color statusColor,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      width: isMobile ? double.infinity : 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: codeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                child: Text(code, style: TextStyle(color: codeColor, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 11, fontWeight: FontWeight.bold)),
          Text(client, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: TextStyle(color: codeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              Text(sub, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingBox(double size, String label, {required bool isDark}) {
    return Column(
      children: [
        Container(
          width: size * 1.5,
          height: 12,
          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF0F172A), fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildSmallTab(String label, bool isSelected, {required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E5EFF) : (isDark ? const Color(0xFF1E293B) : Colors.white),
        border: Border.all(color: isSelected ? const Color(0xFF1E5EFF) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
          fontSize: 8,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color bgColor, Color textColor, {required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 10),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDesignSystem(
    Map<String, dynamic> projectData,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    final category = (projectData['category'] as String? ?? '').toLowerCase();
    final List<Color> gradient = (projectData['gradient'] as List<dynamic>?)?.cast<Color>() ?? [AppColors.primaryBlue, AppColors.accentCyan];
    final primaryColor = gradient.isNotEmpty ? gradient[0] : AppColors.primaryBlue;
    final secondaryColor = gradient.length > 1 ? gradient[1] : AppColors.accentCyan;

    final textMain = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSub = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    Widget buildTokenRow(String name, String token, Color light, String lightHex, Color dark, String darkHex) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(width: 100, child: Text(name, style: TextStyle(fontSize: 11, color: textSub))),
            Expanded(flex: 2, child: Text(token, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: primaryColor))),
            Row(children: [
              Container(width: 14, height: 14, decoration: BoxDecoration(color: light, border: Border.all(color: borderColor, width: 0.5), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Text(lightHex, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: textSub)),
            ]),
            const SizedBox(width: 12),
            Row(children: [
              Container(width: 14, height: 14, decoration: BoxDecoration(color: dark, border: Border.all(color: borderColor, width: 0.5), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Text(darkHex, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: textSub)),
            ]),
          ],
        ),
      );
    }

    Widget buildSectionHeader(String num, String title, String subtitle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), border: Border.all(color: primaryColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(4)),
              child: Text(num, style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: TextStyle(color: textMain, fontSize: 15, fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 4),
          Padding(padding: const EdgeInsets.only(left: 2), child: Text(subtitle, style: TextStyle(color: textSub, fontSize: 12, height: 1.4))),
        ],
      );
    }

    Widget buildSpecColumn({required String deviceLabel, required IconData deviceIcon, required Widget preview, required List<String> dos, required List<String> donts}) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bgColor, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(deviceIcon, size: 14, color: primaryColor),
            const SizedBox(width: 6),
            Text(deviceLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textMain)),
          ]),
          const SizedBox(height: 12),
          Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardBg, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(6)), child: Center(child: preview)),
          const SizedBox(height: 14),
          Row(children: [const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 13), const SizedBox(width: 5), Text('DO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669)))]),
          const SizedBox(height: 4),
          ...dos.map((d) => Padding(padding: const EdgeInsets.only(left: 18, bottom: 3), child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)))),
          const SizedBox(height: 10),
          Row(children: [const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 13), const SizedBox(width: 5), Text("DON'T", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)))]),
          const SizedBox(height: 4),
          ...donts.map((d) => Padding(padding: const EdgeInsets.only(left: 18, bottom: 3), child: Text('• $d', style: TextStyle(fontSize: 11, color: textSub, height: 1.4)))),
        ]),
      );
    }

    Widget buildSpecRow({required Widget mobilePreview, required List<String> mobileDos, required List<String> mobileDonts, required Widget desktopPreview, required List<String> desktopDos, required List<String> desktopDonts}) {
      if (isMobile) {
        return Column(children: [
          buildSpecColumn(deviceLabel: '모바일 (Mobile) 규격', deviceIcon: Icons.phone_android, preview: mobilePreview, dos: mobileDos, donts: mobileDonts),
          const SizedBox(height: 16),
          buildSpecColumn(deviceLabel: '태블릿 & 데스크톱 규격', deviceIcon: Icons.desktop_windows, preview: desktopPreview, dos: desktopDos, donts: desktopDonts),
        ]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: buildSpecColumn(deviceLabel: '모바일 (Mobile) 규격', deviceIcon: Icons.phone_android, preview: mobilePreview, dos: mobileDos, donts: mobileDonts)),
        const SizedBox(width: 20),
        Expanded(child: buildSpecColumn(deviceLabel: '태블릿 & 데스크톱 규격', deviceIcon: Icons.desktop_windows, preview: desktopPreview, dos: desktopDos, donts: desktopDonts)),
      ]);
    }

    final isMobileApp = category.contains('mobile') || category.contains('app') || category.contains('ios') || category.contains('android');
    final btnColor = primaryColor;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF080E1A) : const Color(0xFFF9FAFB),
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80, horizontal: isMobile ? 24 : 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), border: Border.all(color: primaryColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(4)),
                child: Text('DESIGN SYSTEM SPEC', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2)),
              ),
              const SizedBox(height: 12),
              Text('디자인 시스템', style: TextStyle(color: textMain, fontWeight: FontWeight.w800, fontSize: 28, letterSpacing: -1.0)),
              const SizedBox(height: 8),
              Text(
                isMobileApp
                    ? '모바일 앱의 파운데이션(색상 토큰, 타이포그래피, 스페이싱)과 아토믹 디자인 컴포넌트를 정의합니다. 디자인 토큰 네이밍 룰로 개발 핸드오프 효율을 높입니다.'
                    : '제품의 디자인 파운데이션과 컴포넌트 시스템을 정의합니다. 토큰 네이밍 룰로 개발과 디자인의 일관성을 보장합니다.',
                style: TextStyle(color: textSub, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 32),

              // 01. Foundation
              buildSectionHeader('01', 'Foundation (기초 및 토큰 네이밍 룰)', '디자인 시스템의 핵심 기반 — 색상, 서체, 여백, 중단점'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 12),
                decoration: BoxDecoration(border: Border(left: BorderSide(color: primaryColor, width: 3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Design Token Naming Rule (디자인 토큰 명명 규칙)', style: TextStyle(color: textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    RichText(text: TextSpan(style: TextStyle(color: textSub, fontSize: 12, height: 1.6), children: [
                      const TextSpan(text: '표준 패턴: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '--{category}-{type}-{scale}\n', style: TextStyle(fontFamily: 'monospace', color: primaryColor, fontWeight: FontWeight.bold)),
                      const TextSpan(text: '• Category: color, font, space, breakpoint\n'),
                      const TextSpan(text: '• Type: primary, secondary, bg, text, border, error, success\n'),
                      const TextSpan(text: '• Scale: xs, sm, md, lg, xl, 2xl (여백) / h1, h2, body, label (서체)'),
                    ])),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Color Tokens
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardBg, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Color Tokens — Light / Dark Mode', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('동일 토큰명, 모드별 다른 값 적용 (CSS custom property 기반)', style: TextStyle(color: textSub, fontSize: 11)),
                  const SizedBox(height: 12),
                  Row(children: [
                    SizedBox(width: 100, child: Text('분류', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSub))),
                    Expanded(flex: 2, child: Text('토큰명', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSub))),
                    Text('Light', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSub)),
                    const SizedBox(width: 55),
                    Text('Dark', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSub)),
                  ]),
                  Divider(color: borderColor, height: 16),
                  buildTokenRow('Primary', '--color-primary-main', primaryColor, '#' + primaryColor.value.toRadixString(16).substring(2).toUpperCase(), secondaryColor, '#' + secondaryColor.value.toRadixString(16).substring(2).toUpperCase()),
                  buildTokenRow('Bg Primary', '--color-bg-primary', Colors.white, '#FFFFFF', const Color(0xFF0F172A), '#0F172A'),
                  buildTokenRow('Bg Secondary', '--color-bg-secondary', const Color(0xFFF8FAFC), '#F8FAFC', const Color(0xFF1E293B), '#1E293B'),
                  buildTokenRow('Text Primary', '--color-text-primary', const Color(0xFF1F2937), '#1F2937', const Color(0xFFF9FAFB), '#F9FAFB'),
                  buildTokenRow('Text Secondary', '--color-text-secondary', const Color(0xFF475569), '#475569', const Color(0xFF94A3B8), '#94A3B8'),
                  buildTokenRow('Border', '--color-border-default', const Color(0xFFE2E8F0), '#E2E8F0', const Color(0xFF334155), '#334155'),
                  buildTokenRow('Success', '--color-success-main', const Color(0xFF10B981), '#10B981', const Color(0xFF059669), '#059669'),
                  buildTokenRow('Error', '--color-error-main', const Color(0xFFEF4444), '#EF4444', const Color(0xFFDC2626), '#DC2626'),
                ]),
              ),
              const SizedBox(height: 20),

              // Typography & Spacing
              LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth > 720;
                final itemW = isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;
                return Wrap(spacing: 20, runSpacing: 16, children: [
                  SizedBox(width: itemW, child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardBg, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Typography (서체 토큰)', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...[
                        ['Display', '--font-size-display', '36px', '700'],
                        ['H1', '--font-size-h1', isMobileApp ? '24px' : '28px', '700'],
                        ['H2', '--font-size-h2', isMobileApp ? '20px' : '22px', '700'],
                        ['Body', '--font-size-body', '14px', '400'],
                        ['Label', '--font-size-label', '12px', '500'],
                        ['Caption', '--font-size-caption', '11px', '400'],
                      ].map((row) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
                        SizedBox(width: 60, child: Text(row[0], style: TextStyle(fontSize: 11, color: textMain))),
                        Expanded(child: Text(row[1], style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: primaryColor))),
                        Text('\${row[2]}  W\${row[3]}', style: TextStyle(fontSize: 10, color: textSub)),
                      ]))),
                    ]),
                  )),
                  SizedBox(width: itemW, child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardBg, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Spacing & Breakpoints (여백 & 중단점)', style: TextStyle(color: textMain, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...[
                        ['--spacing-xs', '4px', 4.0],
                        ['--spacing-sm', '8px', 8.0],
                        ['--spacing-md', '12px', 12.0],
                        ['--spacing-lg', '16px', 16.0],
                        ['--spacing-xl', '24px', 24.0],
                        ['--spacing-2xl', '40px', 40.0],
                      ].map((row) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
                        Expanded(child: Text(row[0] as String, style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: primaryColor))),
                        Text(row[1] as String, style: TextStyle(fontSize: 10, color: textSub)),
                        const SizedBox(width: 8),
                        Container(height: 6, width: (row[2] as double) * 1.2, color: primaryColor.withOpacity(0.35)),
                      ]))),
                      const SizedBox(height: 12),
                      Divider(color: borderColor, height: 8),
                      const SizedBox(height: 8),
                      ...[
                        ['--breakpoint-mobile', '< 600px'],
                        ['--breakpoint-tablet', '600–1024px'],
                        ['--breakpoint-desktop', '>= 1024px'],
                      ].map((row) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [
                        Expanded(child: Text(row[0], style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: secondaryColor))),
                        Text(row[1], style: TextStyle(fontSize: 10, color: textSub)),
                      ]))),
                    ]),
                  )),
                ]);
              }),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 32),

              // 02. Atoms
              buildSectionHeader('02', 'Atoms (원자 컴포넌트)', '가장 기본적인 UI 요소 — 버튼, 뱃지, 입력 필드, 아이콘'),
              const SizedBox(height: 20),
              buildSpecRow(
                mobilePreview: Column(children: [
                  SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobileApp ? 12 : 6))), child: const Text('확인', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: btnColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text('기본', style: TextStyle(color: btnColor, fontSize: 10, fontWeight: FontWeight.bold))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('성공', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: const Text('오류', style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold))),
                  ]),
                ]),
                mobileDos: ['터치 영역은 최소 44×44px 이상 확보하십시오.', '가장 중요한 CTA는 Full Width 버튼으로 배치하십시오.'],
                mobileDonts: ['작은 화면에서 3개 이상의 버튼을 가로 일렬 배치하지 마십시오.', '폰트 크기를 12px 미만으로 낮추지 마십시오.'],
                desktopPreview: Row(mainAxisSize: MainAxisSize.min, children: [
                  ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.check, size: 13), label: const Text('저장', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: BorderSide(color: borderColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)), child: Text('취소', style: TextStyle(fontSize: 12, color: textMain))),
                ]),
                desktopDos: ['마우스 포인팅이 가능하므로 인라인 배치(8–12px 간격)를 권장합니다.', 'Primary/Secondary 액션을 시각적으로 명확히 구분하십시오.'],
                desktopDonts: ['Full Width 버튼을 데스크톱 화면 전체 너비에 사용하지 마십시오.', '비슷한 스타일의 버튼을 4개 이상 병렬 배치하지 마십시오.'],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 32),

              // 03. Molecules
              buildSectionHeader('03', 'Molecules (분자 컴포넌트)', '원자 요소들을 결합한 단순 UI 유닛 — 검색창, 드롭다운, 카드 헤더'),
              const SizedBox(height: 20),
              buildSpecRow(
                mobilePreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('항목 선택', style: TextStyle(color: textMain, fontSize: 13)),
                    Icon(Icons.keyboard_arrow_down, size: 18, color: textSub),
                  ]),
                ),
                mobileDos: ['드롭다운 클릭 시 Bottom Sheet 방식으로 화면 하단에서 슬라이드하여 표시하십시오.', '항목 높이는 48px 이상으로 터치 편의성을 확보하십시오.'],
                mobileDonts: ['플로팅 드롭다운 레이어를 작은 화면에 겹쳐 표시하지 마십시오.', '한 화면에 드롭다운을 3개 이상 나열하지 마십시오.'],
                desktopPreview: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(6)),
                  child: Row(children: [
                    Icon(Icons.search, size: 15, color: textSub),
                    const SizedBox(width: 8),
                    Expanded(child: Text('검색어 입력...', style: TextStyle(color: textSub, fontSize: 12))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.circular(4)), child: const Text('검색', style: TextStyle(color: Colors.white, fontSize: 11))),
                  ]),
                ),
                desktopDos: ['검색 입력창과 버튼을 인라인(가로 배치)으로 구성하십시오.', '자동완성 드롭다운은 입력창 바로 아래 위치하고 최대 8개 항목까지 표시하십시오.'],
                desktopDonts: ['검색창 너비를 화면 전체(100%)로 확장하지 마십시오.', '필터와 검색 입력창을 같은 줄에 3개 이상 배치하지 마십시오.'],
              ),

              const SizedBox(height: 40),
              Divider(color: borderColor),
              const SizedBox(height: 32),

              // 04. Organisms
              buildSectionHeader('04', 'Organisms (유기체 컴포넌트)', '복잡한 UI 영역 — 헤더, 네비게이션, 콘텐츠 섹션'),
              const SizedBox(height: 20),
              buildSpecRow(
                mobilePreview: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, border: Border.all(color: borderColor)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('앱 타이틀', style: TextStyle(color: textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                      Row(children: [Icon(Icons.notifications_outlined, size: 20, color: textSub), const SizedBox(width: 12), Icon(Icons.menu, size: 20, color: textSub)]),
                    ]),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9), border: Border(top: BorderSide(color: borderColor))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      Column(children: [Icon(Icons.home, size: 20, color: btnColor), const SizedBox(height: 2), Text('홈', style: TextStyle(color: btnColor, fontSize: 10))]),
                      Column(children: [Icon(Icons.search, size: 20, color: textSub), const SizedBox(height: 2), Text('검색', style: TextStyle(color: textSub, fontSize: 10))]),
                      Column(children: [Icon(Icons.person_outline, size: 20, color: textSub), const SizedBox(height: 2), Text('마이', style: TextStyle(color: textSub, fontSize: 10))]),
                    ]),
                  ),
                ]),
                mobileDos: ['하단 탭 바(Bottom Navigation)는 3–5개 항목만 표시하십시오.', '현재 활성 탭은 색상 및 아이콘으로 명확히 구분하십시오.'],
                mobileDonts: ['상단과 하단 동시에 내비게이션을 중복 배치하지 마십시오.', '탭 아이콘 없이 텍스트만으로 탭 바를 구성하지 마십시오.'],
                desktopPreview: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, border: Border.all(color: borderColor)),
                  child: Row(children: [
                    Text('로고', style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 24),
                    ...[('홈'), ('서비스'), ('포트폴리오')].map((t) => Padding(padding: const EdgeInsets.only(right: 16), child: Text(t, style: TextStyle(color: textSub, fontSize: 12)))),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.circular(4)), child: const Text('시작하기', style: TextStyle(color: Colors.white, fontSize: 11))),
                  ]),
                ),
                desktopDos: ['상단 GNB(Global Navigation Bar)는 64px 높이를 권장합니다.', '로고, 메뉴, CTA 버튼을 왼쪽-중앙-오른쪽 구조로 배치하십시오.'],
                desktopDonts: ['데스크톱에서 하단 탭 바를 사용하지 마십시오.', 'GNB에 6개 이상의 메뉴 항목을 나열하지 마십시오.'],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesignSystemSubSection(
    String title,
    List<Widget> children,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5.copyWith(
            color: isDark ? Colors.white : AppColors.lightGray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children.map((e) => Expanded(child: e)).toList(),
        ),
      ],
    );
  }

  Widget _buildDSItem(String label, List<String> items, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withOpacity(0.5)
            : AppColors.lightGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $e',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectImages(Map<String, dynamic> projectData, bool isMobile, bool isTablet) {
    final title = projectData['title']?.toString().toLowerCase() ?? '';
    final company = projectData['company']?.toString().toLowerCase() ?? '';
    final isWallpad = (company.contains('hyundai ht') || company.contains('현대에이치티')) && (title.contains('wallpad') || title.contains('월패드'));
    final isHtHome = (company.contains('hyundai ht') || company.contains('현대에이치티')) && (title.contains('home') || title.contains('홈'));
    final isSoulark = title.contains('soulark') || title.contains('소울아크');
    final isClosers = title.contains('closers') || title.contains('클로저스');
    final isPromotion = title.contains('promotion') || title.contains('프로모션');
    final isFarm = title.contains('farm') || title.contains('농가') || title.contains('농업');
    final isAia = widget.projectId == 'p1';
    final isSamMes = widget.projectId == 'p8';
    final screenWidth = MediaQuery.of(context).size.width;

    final mainScreenImagesRaw = projectData['mainScreenImages'];
    final List<String> mainScreenImages = mainScreenImagesRaw is List
        ? List<String>.from(mainScreenImagesRaw)
        : [];
    final hasCustomImages = mainScreenImages.isNotEmpty;

    if (!isWallpad && !isHtHome && !isSoulark && !isClosers && !isPromotion && !isFarm && !isAia && !isSamMes && !hasCustomImages) {
      return const SizedBox.shrink();
    }

    final isNetwork = projectData['imageUrl'] != null && projectData['imageUrl']!.toString().startsWith('http');
    
    final List<Map<String, dynamic>> imagesToRender;
    if (hasCustomImages && !isWallpad && !isHtHome && !isSoulark && !isClosers && !isPromotion && !isFarm && !isAia && !isSamMes) {
      imagesToRender = mainScreenImages.map((imgUrl) {
        double ratio = 1.0;
        try {
          final uri = Uri.parse(imgUrl);
          final wStr = uri.queryParameters['w'];
          final hStr = uri.queryParameters['h'];
          if (wStr != null && hStr != null) {
            final w = double.tryParse(wStr);
            final h = double.tryParse(hStr);
            if (w != null && h != null && w > 0) {
              ratio = h / w;
            }
          }
        } catch (_) {}
        return {
          'url': imgUrl,
          'ratio': ratio,
        };
      }).toList();
    } else if (isWallpad) {
      imagesToRender = [];
      for (int i = 1; i <= 6; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/ht_01_slice_$i.jpg' : 'assets/images/ht_01_slice_$i.jpg',
          'ratio': 2170 / 1920,
        });
      }
      for (int i = 1; i <= 4; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/ht_02_1_slice_$i.jpg' : 'assets/images/ht_02_1_slice_$i.jpg',
          'ratio': 2385 / 1920,
        });
      }
      for (int i = 1; i <= 3; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/ht_02_2_slice_$i.jpg' : 'assets/images/ht_02_2_slice_$i.jpg',
          'ratio': 2386 / 1920,
        });
      }
      imagesToRender.add({
        'url': isNetwork ? 'http://localhost:8080/images/ht_02_2_slice_4.jpg' : 'assets/images/ht_02_2_slice_4.jpg',
        'ratio': 2383 / 1920,
      });
      for (int i = 1; i <= 3; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/ht_03_1_slice_$i.jpg' : 'assets/images/ht_03_1_slice_$i.jpg',
          'ratio': 2448 / 1920,
        });
      }
      imagesToRender.add({
        'url': isNetwork ? 'http://localhost:8080/images/ht_03_1_slice_4.jpg' : 'assets/images/ht_03_1_slice_4.jpg',
        'ratio': 2445 / 1920,
      });
      for (int i = 1; i <= 3; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/ht_03_2_slice_$i.jpg' : 'assets/images/ht_03_2_slice_$i.jpg',
          'ratio': 2448 / 1920,
        });
      }
      imagesToRender.add({
        'url': isNetwork ? 'http://localhost:8080/images/ht_03_2_slice_4.jpg' : 'assets/images/ht_03_2_slice_4.jpg',
        'ratio': 2446 / 1920,
      });
    } else if (isHtHome) {
      imagesToRender = [];
      for (int i = 1; i <= 3; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_1_slice_$i.jpg' : 'assets/images/hthome_01_1_slice_$i.jpg',
          'ratio': 2475 / 1920,
        });
      }
      imagesToRender.add({
        'url': isNetwork ? 'http://localhost:8080/images/hthome_01_1_slice_4.jpg' : 'assets/images/hthome_01_1_slice_4.jpg',
        'ratio': 2474 / 1920,
      });
      for (int i = 1; i <= 3; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_2_slice_$i.jpg' : 'assets/images/hthome_01_2_slice_$i.jpg',
          'ratio': 2475 / 1920,
        });
      }
      imagesToRender.add({
        'url': isNetwork ? 'http://localhost:8080/images/hthome_01_2_slice_4.jpg' : 'assets/images/hthome_01_2_slice_4.jpg',
        'ratio': 2474 / 1920,
      });
      for (int i = 1; i <= 4; i++) {
        imagesToRender.add({
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_3_slice_$i.jpg' : 'assets/images/hthome_01_3_slice_$i.jpg',
          'ratio': 2475 / 1920,
        });
      }
    } else if (isSoulark) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/soulark_1.jpg' : 'assets/images/soulark_1.jpg',
          'ratio': 7706 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/soulark_2.jpg' : 'assets/images/soulark_2.jpg',
          'ratio': 7706 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/soulark_3.jpg' : 'assets/images/soulark_3.jpg',
          'ratio': 7706 / 1920,
        },
      ];
    } else if (isClosers) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/closers_1.jpg' : 'assets/images/closers_1.jpg',
          'ratio': 6652 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/closers_2.jpg' : 'assets/images/closers_2.jpg',
          'ratio': 6652 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/closers_3.jpg' : 'assets/images/closers_3.jpg',
          'ratio': 6654 / 1920,
        },
      ];
    } else if (isPromotion) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/promotion_1.jpg' : 'assets/images/promotion_1.jpg',
          'ratio': 5993 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/promotion_2.jpg' : 'assets/images/promotion_2.jpg',
          'ratio': 5994 / 1920,
        },
      ];
    } else if (isAia) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_1.jpg' : 'assets/images/aia_1.jpg',
          'ratio': 2800 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_2.jpg' : 'assets/images/aia_2.jpg',
          'ratio': 2800 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_3.jpg' : 'assets/images/aia_3.jpg',
          'ratio': 2800 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_4.jpg' : 'assets/images/aia_4.jpg',
          'ratio': 2800 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_5.jpg' : 'assets/images/aia_5.jpg',
          'ratio': 2800 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/aia_6.jpg' : 'assets/images/aia_6.jpg',
          'ratio': 2589 / 1920,
        },
      ];
    } else if (isSamMes) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_1.jpg' : 'assets/images/sam_mes_f4_1.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_2.jpg' : 'assets/images/sam_mes_f4_2.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_3.jpg' : 'assets/images/sam_mes_f4_3.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_4.jpg' : 'assets/images/sam_mes_f4_4.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_5.jpg' : 'assets/images/sam_mes_f4_5.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_6.jpg' : 'assets/images/sam_mes_f4_6.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_7.jpg' : 'assets/images/sam_mes_f4_7.jpg',
          'ratio': 2700 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/sam_mes_f4_8.jpg' : 'assets/images/sam_mes_f4_8.jpg',
          'ratio': 2700 / 1920,
        },
      ];
    } else {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/farm_1.jpg' : 'assets/images/farm_1.jpg',
          'ratio': 6043 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/farm_2.jpg' : 'assets/images/farm_2.jpg',
          'ratio': 6043 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/farm_3.jpg' : 'assets/images/farm_3.jpg',
          'ratio': 6043 / 1920,
        },
      ];
    }

    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: imagesToRender.map((imgData) {
                final String imgUrl = imgData['url'] as String;
                final double ratio = imgData['ratio'] as double;
                final double calculatedHeight = screenWidth * ratio;
                print('--- DETAIL PAGE IMAGE: $imgUrl, RATIO: $ratio, HEIGHT: $calculatedHeight, SCREEN WIDTH: $screenWidth ---');

                if (imgUrl.startsWith('http')) {
                  return Image.network(
                    imgUrl,
                    width: screenWidth,
                    height: calculatedHeight,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: calculatedHeight > 500 ? 500 : calculatedHeight,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'Failed to load network image: $imgUrl',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Image.asset(
                    imgUrl,
                    width: screenWidth,
                    height: calculatedHeight,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'Asset not found: $imgUrl',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectImagesSplit(
    Map<String, dynamic> projectData,
    bool isMobile,
    bool isTablet, {
    required bool firstPart,
  }) {
    final isNetwork = projectData['imageUrl'] != null && projectData['imageUrl']!.toString().startsWith('http');
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> allImages = [
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_1.jpg' : 'assets/images/sam_mes_1.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_2.jpg' : 'assets/images/sam_mes_2.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_3.jpg' : 'assets/images/sam_mes_3.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_4.jpg' : 'assets/images/sam_mes_4.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_5.jpg' : 'assets/images/sam_mes_5.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_6.jpg' : 'assets/images/sam_mes_6.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_7.jpg' : 'assets/images/sam_mes_7.jpg',
        'ratio': 2866 / 1920,
      },
      {
        'url': isNetwork ? 'http://localhost:8080/images/sam_mes_8.jpg' : 'assets/images/sam_mes_8.jpg',
        'ratio': 2871 / 1920,
      },
    ];

    final List<Map<String, dynamic>> imagesToRender = firstPart
        ? allImages.sublist(0, 6)
        : allImages.sublist(6);

    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: imagesToRender.map((imgData) {
                final String imgUrl = imgData['url'] as String;
                final double ratio = imgData['ratio'] as double;
                final double calculatedHeight = screenWidth * ratio;

                if (imgUrl.startsWith('http')) {
                  return Image.network(
                    imgUrl,
                    width: screenWidth,
                    height: calculatedHeight,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: calculatedHeight > 500 ? 500 : calculatedHeight,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  );
                } else {
                  return Image.asset(
                    imgUrl,
                    width: screenWidth,
                    height: calculatedHeight,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  );
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Helper placeholder for backward compatibility
  Widget _buildProjectImage(String imageUrl, bool isMobile, bool isTablet) {
    return const SizedBox.shrink();
  }

  Widget _buildBackButton(bool isMobile, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 100,
        vertical: 24,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go('/portfolio'),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              ),
              const SizedBox(width: 8),
              Text(
                'Back to Portfolio',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Category Badge
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: project['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project['category'] as String,
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 24 : 32),

              // Title
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 400),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: project['gradient'] as List<Color>,
                  ).createShader(bounds),
                  child: Text(
                    project['title'] as String,
                    style:
                        (isMobile ? AppTypography.h2 : AppTypography.display1)
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 16 : 20),

              // Subtitle
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  project['subtitle'] as String,
                  style: (isMobile ? AppTypography.h6 : AppTypography.h5)
                      .copyWith(
                        color: isDark
                            ? AppColors.gray100.withValues(alpha: 0.9)
                            : AppColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Company & Year
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 800),
                child: Text(
                  '${project['company']} • ${project['year']}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark
                        ? AppColors.gray100.withValues(alpha: 0.7)
                        : AppColors.lightText2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfo(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 1000),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60,
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(children: _buildInfoCards(project, isDark, isMobile))
                : Row(children: _buildInfoCards(project, isDark, isMobile)),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInfoCards(
    Map<String, dynamic> project,
    bool isDark,
    bool isMobile,
  ) {
    final infos = [
      {'label': 'Role', 'value': project['role']},
      {'label': 'Duration', 'value': project['duration']},
      {'label': 'Team Size', 'value': project['teamSize']},
    ];

    return infos
        .map(
          (info) => Expanded(
            child: Container(
              margin: EdgeInsets.all(isMobile ? 8 : 12),
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.charcoal.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (project['gradient'] as List<Color>)[0].withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    info['label'] as String,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.gray100.withValues(alpha: 0.6)
                          : AppColors.lightText2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info['value'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.gray100
                          : AppColors.lightGray900,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildOverview(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return _buildSection(
      title: 'Project Overview',
      content: Text(
        project['overview'] as String,
        style: AppTypography.bodyLarge.copyWith(
          color: isDark
              ? AppColors.gray100.withValues(alpha: 0.9)
              : AppColors.lightText,
          height: 1.8,
        ),
      ),
      isMobile: isMobile,
      isTablet: isTablet,
      isDark: isDark,
      delay: const Duration(milliseconds: 1200),
    );
  }

  Widget _buildChallengesSolutions(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    _buildListSection(
                      title: 'Challenges',
                      items: project['challenges'] as List<String>,
                      isDark: isDark,
                      isMobile: isMobile,
                      gradient: project['gradient'] as List<Color>,
                      delay: const Duration(milliseconds: 1400),
                    ),
                    SizedBox(height: isMobile ? 32 : 0),
                    _buildListSection(
                      title: 'Solutions',
                      items: project['solutions'] as List<String>,
                      isDark: isDark,
                      isMobile: isMobile,
                      gradient: project['gradient'] as List<Color>,
                      delay: const Duration(milliseconds: 1600),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildListSection(
                        title: 'Challenges',
                        items: project['challenges'] as List<String>,
                        isDark: isDark,
                        isMobile: isMobile,
                        gradient: project['gradient'] as List<Color>,
                        delay: const Duration(milliseconds: 1400),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildListSection(
                        title: 'Solutions',
                        items: project['solutions'] as List<String>,
                        isDark: isDark,
                        isMobile: isMobile,
                        gradient: project['gradient'] as List<Color>,
                        delay: const Duration(milliseconds: 1600),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required bool isDark,
    required bool isMobile,
    required List<Color> gradient,
    required Duration delay,
  }) {
    return ScrollRevealWidget(
      delay: delay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: (isMobile ? AppTypography.h5 : AppTypography.h4).copyWith(
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: gradient[0],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.gray100.withValues(alpha: 0.8)
                            : AppColors.lightText2,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcess(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    final process = project['process'] as List<Map<String, String>>;

    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 1800),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60,
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Process',
                  style: (isMobile ? AppTypography.h4 : AppTypography.h3)
                      .copyWith(
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(height: isMobile ? 24 : 40),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: process.length,
                  itemBuilder: (context, index) {
                    return _buildProcessCard(
                      process[index],
                      isDark,
                      isMobile,
                      project['gradient'] as List<Color>,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessCard(
    Map<String, String> step,
    bool isDark,
    bool isMobile,
    List<Color> gradient,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient[0].withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: gradient[0].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              step['phase']!,
              style: AppTypography.labelSmall.copyWith(
                color: gradient[0],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Text(
            step['title']!,
            style: AppTypography.h6.copyWith(
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            step['description']!,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.gray100.withValues(alpha: 0.8)
                  : AppColors.lightText2,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return _buildSection(
      title: 'Key Achievements',
      content: Column(
        children: (project['achievements'] as List<String>)
            .map(
              (achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: (project['gradient'] as List<Color>)[0],
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        achievement,
                        style: AppTypography.bodyLarge.copyWith(
                          color: isDark
                              ? AppColors.gray100.withValues(alpha: 0.9)
                              : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
      isMobile: isMobile,
      isTablet: isTablet,
      isDark: isDark,
      delay: const Duration(milliseconds: 2000),
    );
  }

  Widget _buildTechnologies(
    Map<String, dynamic> project,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    return _buildSection(
      title: 'Technologies',
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: (project['technologies'] as List<String>).map((tech) {
          final tagColor = _getTagColor(tech, isDark);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: tagColor.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Text(
              tech,
              style: AppTypography.bodyMedium.copyWith(
                color: tagColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
      isMobile: isMobile,
      isTablet: isTablet,
      isDark: isDark,
      delay: const Duration(milliseconds: 2200),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required bool isMobile,
    required bool isTablet,
    required bool isDark,
    required Duration delay,
  }) {
    return ScrollRevealWidget(
      delay: delay,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60,
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (isMobile ? AppTypography.h4 : AppTypography.h3)
                      .copyWith(
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(height: isMobile ? 20 : 32),
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(bool isMobile, bool isTablet, bool isDark) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 2400),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 60 : 80,
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/portfolio'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryBlue, AppColors.accentCyan],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        'View All Projects',
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTagColor(String tag, bool isDark) {
    final lower = tag.toLowerCase().trim();
    if (lower.contains('figma') || lower.contains('photoshop') || lower.contains('unity3d') || lower.contains('design system') || lower.contains('zeplin') || lower.contains('illustrator')) {
      return isDark ? const Color(0xFFE040FB) : const Color(0xFF9C27B0); // Purple/Pink
    }
    if (lower.contains('web') || lower.contains('responsive') || lower.contains('html') || lower.contains('css') || lower.contains('javascript') || lower.contains('publishing') || lower.contains('퍼블리싱')) {
      return isDark ? const Color(0xFF00E5FF) : const Color(0xFF00B8D4); // Cyan/Teal
    }
    if (lower.contains('mobile') || lower.contains('ios') || lower.contains('android') || lower.contains('app')) {
      return isDark ? const Color(0xFF29B6F6) : const Color(0xFF0288D1); // Light Blue
    }
    if (lower.contains('iot') || lower.contains('device') || lower.contains('smart') || lower.contains('home') || lower.contains('월패드') || lower.contains('wallpad') || lower.contains('farm') || lower.contains('농가')) {
      return isDark ? const Color(0xFFFFB74D) : const Color(0xFFF57C00); // Orange
    }
    if (lower.contains('enterprise') || lower.contains('dashboard') || lower.contains('mes') || lower.contains('erp') || lower.contains('대시보드')) {
      return isDark ? const Color(0xFF81C784) : const Color(0xFF388E3C); // Green
    }
    if (lower.contains('accessibility') || lower.contains('testing') || lower.contains('strategy') || lower.contains('fintech') || lower.contains('lead') || lower.contains('senior') || lower.contains('접근성')) {
      return isDark ? const Color(0xFFFF8A80) : const Color(0xFFD32F2F); // Red/Coral
    }
    return isDark ? AppColors.accentCyan : AppColors.primaryBlue;
  }
}



// =========================================================================
// SAM MES+ERP Integrated Design System Viewer (Enterprise Grade)
// =========================================================================

class _SamMesDesignSystemViewer extends StatelessWidget {
  final bool isMobile;
  final bool isDark;

  const _SamMesDesignSystemViewer({
    required this.isMobile,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accentCyan;
    final primaryColor = AppColors.primaryBlue;

    final categories = [
      {
        'title': '01. Foundation (기초)',
        'icon': Icons.layers_outlined,
        'desc': '브랜드 가이드라인 및 공통 스타일 토큰 정의',
        'tags': ['Color Palette', 'Typography', 'Spacing', 'Design Tokens'],
        'color': accentColor,
      },
      {
        'title': '02. Atoms (원자)',
        'icon': Icons.auto_awesome_mosaic_outlined,
        'desc': '더 이상 나눌 수 없는 최소 단위의 기본 UI 요소',
        'tags': ['Button', 'Badge', 'Input', 'Checkbox', 'Switch', 'Label', 'Separator'],
        'color': primaryColor,
      },
      {
        'title': '03. Molecules (분자)',
        'icon': Icons.grid_view_outlined,
        'desc': '원자 컴포넌트의 단순 조합으로 구현된 기능 단위',
        'tags': ['Select', 'Accordion', 'Card', 'Search Filter'],
        'color': AppColors.highlightGreen,
      },
      {
        'title': '04. Organisms (유기체)',
        'icon': Icons.dashboard_customize_outlined,
        'desc': '분자 및 원자의 결합으로 완성된 복합 관제 인터페이스',
        'tags': ['Page Header', 'Stat Cards', 'Form Section'],
        'color': Colors.amber,
      },
      {
        'title': '05. Templates (템플릿)',
        'icon': Icons.splitscreen_outlined,
        'desc': '레이아웃 및 일관된 레이어 분할 표준 구조 정의',
        'tags': ['Unified List Template', 'Unified Form Template', 'Unified Detail Template', 'Unified Dashboard'],
        'color': Colors.purple,
      },
      {
        'title': '06. Cards (카드)',
        'icon': Icons.credit_card_outlined,
        'desc': '대규모 데이터를 압축하여 전달하는 업무 중심 카드 세트',
        'tags': ['Quote Card', 'Sales Order Card', 'Item Master Card', 'Client Card', 'Site Card'],
        'color': Colors.pink,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 24 : 60,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title & Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DESIGN SYSTEM SPEC',
                      style: AppTypography.labelSmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '통합 디자인 시스템 구성 명세 (Atomic Architecture)',
                style: (isMobile ? AppTypography.h3 : AppTypography.h2).copyWith(
                  color: isDark ? Colors.white : AppColors.lightGray900,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SAM MES+ERP 솔루션의 고품질 일관성을 보장하기 위해 도입된 디자인 시스템 구성 요소입니다. React 컴포넌트 라이브러리 및 공통 스타일 명세를 구조화하여 대기업용 시스템 완성도를 확보했습니다.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.gray100.withValues(alpha: 0.7) : AppColors.lightText2,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Responsive Grid of System Tiers
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 1.5 : 1.7,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final catColor = cat['color'] as Color;
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.charcoal.withOpacity(0.4) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.blue900.withOpacity(0.3) : AppColors.lightGray300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + Title Row
                        Row(
                          children: [
                            Icon(cat['icon'] as IconData, color: catColor, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cat['title'] as String,
                                style: AppTypography.bodyLarge.copyWith(
                                  color: isDark ? Colors.white : AppColors.lightGray900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['desc'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.gray100.withValues(alpha: 0.6) : AppColors.lightText2.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        // Component Badges Wrap
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (cat['tags'] as List<String>).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.1),
                                border: Border.all(color: catColor.withValues(alpha: 0.2), width: 0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: isDark ? catColor : catColor.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}



class BackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDark;
  final List<Color> gradient;

  BackgroundPainter({
    required this.animation,
    required this.isDark,
    required this.gradient,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    final circles = [
      {
        'x': size.width * 0.2,
        'y': size.height * 0.3,
        'radius': 150.0,
        'color': gradient[0].withValues(alpha: 0.1),
      },
      {
        'x': size.width * 0.8,
        'y': size.height * 0.6,
        'radius': 200.0,
        'color': gradient[1].withValues(alpha: 0.08),
      },
      {
        'x': size.width * 0.5,
        'y': size.height * 0.8,
        'radius': 180.0,
        'color': gradient[0].withValues(alpha: 0.06),
      },
    ];

    for (var circle in circles) {
      paint.color = circle['color'] as Color;
      final offsetY = (animation.value * 20) % 40 - 20;
      canvas.drawCircle(
        Offset(circle['x'] as double, (circle['y'] as double) + offsetY),
        circle['radius'] as double,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isDark != isDark ||
        oldDelegate.gradient != gradient;
  }
}
