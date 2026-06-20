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
        'gradient': projectModel.gradientColors.isNotEmpty
            ? projectModel.gradientColors
            : [AppColors.primaryBlue, AppColors.accentCyan],
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

    final isAia = projectData['title']?.toString().toLowerCase().contains('aia') == true ||
        projectData['company']?.toString().toLowerCase().contains('aia') == true;
    final isSamMes = projectData['title']?.toString().toLowerCase().contains('mes') == true ||
        projectData['company']?.toString().toLowerCase().contains('코드브릿지') == true ||
        projectData['company']?.toString().toLowerCase().contains('bridge') == true;
    final hideDetails = isAia || isSamMes;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          CustomPaint(
            painter: BackgroundPainter(
              animation: _animationController,
              isDark: isDark,
              gradient: projectData['gradient'] as List<Color>,
            ),
            size: Size.infinite,
          ),

          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Back Button
                _buildBackButton(isMobile, isDark),

                // Hero Section
                _buildHeroSection(projectData, isMobile, isTablet, isDark),

                // Design System Section (For SAM MES+ERP)
                if (isSamMes)
                  _SamMesDesignSystemViewer(isMobile: isMobile, isDark: isDark),

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
                if (!hideDetails) _buildDesignSystem(projectData, isMobile, isTablet, isDark),

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

  Widget _buildDesignSystem(
    Map<String, dynamic> projectData,
    bool isMobile,
    bool isTablet,
    bool isDark,
  ) {
    final ds = projectData['designSystem'] as DesignSystemModel?;

    return _buildSection(
      title: 'Design System Analysis',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ds == null)
            Center(
              child: Column(
                children: [
                  const Text(
                    '이미지를 분석하여 디자인 시스템을 도출할 수 있습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isAnalyzing
                        ? null
                        : () => _analyzeDesignSystem(projectData),
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(_isAnalyzing ? '분석 중...' : 'AI 분석 시작'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                _buildDesignSystemSubSection('Foundation', [
                  _buildDSItem('Colors', ds.foundation.colors, isDark),
                  _buildDSItem('Typography', ds.foundation.typography, isDark),
                  _buildDSItem('Spacing', ds.foundation.spacing, isDark),
                ], isDark),
                const SizedBox(height: 32),
                _buildDesignSystemSubSection('Atomic Design', [
                  _buildDSItem('Atoms', ds.atomic.atoms, isDark),
                  _buildDSItem('Molecules', ds.atomic.molecules, isDark),
                  _buildDSItem('Organisms', ds.atomic.organisms, isDark),
                ], isDark),
              ],
            ),
        ],
      ),
      isMobile: isMobile,
      isTablet: isTablet,
      isDark: isDark,
      delay: const Duration(milliseconds: 1500),
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
    final isAia = title.contains('aia') || company.contains('aia');
    final isSamMes = title.contains('mes') || company.contains('코드브릿지') || company.contains('bridge');
    final screenWidth = MediaQuery.of(context).size.width;

    if (!isWallpad && !isHtHome && !isSoulark && !isClosers && !isPromotion && !isFarm && !isAia && !isSamMes) {
      return const SizedBox.shrink();
    }

    final isNetwork = projectData['imageUrl'] != null && projectData['imageUrl']!.toString().startsWith('http');
    
    final List<Map<String, dynamic>> imagesToRender;
    if (isWallpad) {
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

class _SamMesDesignSystemViewer extends StatefulWidget {
  final bool isMobile;
  final bool isDark;

  const _SamMesDesignSystemViewer({
    required this.isMobile,
    required this.isDark,
  });

  @override
  State<_SamMesDesignSystemViewer> createState() => _SamMesDesignSystemViewerState();
}

class _SamMesDesignSystemViewerState extends State<_SamMesDesignSystemViewer> {
  String _activeTab = 'foundation';
  String _searchQuery = '';
  final Map<String, bool> _expandedCode = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'foundation', 'label': 'Foundation (기초)', 'icon': Icons.layers_outlined},
    {'id': 'atoms', 'label': 'Atoms (원자)', 'icon': Icons.auto_awesome_mosaic_outlined},
    {'id': 'molecules', 'label': 'Molecules (분자)', 'icon': Icons.grid_view_outlined},
    {'id': 'organisms', 'label': 'Organisms (유기체)', 'icon': Icons.dashboard_customize_outlined},
    {'id': 'templates', 'label': 'Templates (템플릿)', 'icon': Icons.splitscreen_outlined},
    {'id': 'cards', 'label': 'Cards (카드)', 'icon': Icons.credit_card_outlined},
  ];

  void _copyToClipboard(String code, String name) {
    flutter.Clipboard.setData(flutter.ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name TSX 코드가 클립보드에 복사되었습니다.'),
        backgroundColor: AppColors.highlightGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final accentColor = AppColors.accentCyan;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.isMobile ? 40 : 60,
        horizontal: widget.isMobile ? 16 : 40,
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
                      'DESIGN SYSTEM',
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
                '통합 디자인 시스템 (Atomic Architecture)',
                style: (widget.isMobile ? AppTypography.h3 : AppTypography.h2).copyWith(
                  color: isDark ? Colors.white : AppColors.lightGray900,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SAM MES+ERP 솔루션의 고품질 일관성을 보장하는 엔터프라이즈 디자인 명세서입니다. Radix UI와 Tailwind CSS 기반의 React 컴포넌트를 아토믹 설계 규칙에 따라 제공합니다.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.gray100.withValues(alpha: 0.7) : AppColors.lightText2,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.charcoal.withOpacity(0.5) : AppColors.lightGray100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.blue900.withOpacity(0.3) : AppColors.lightGray300,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: isDark ? Colors.grey : AppColors.lightText2),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                        style: TextStyle(color: isDark ? Colors.white : AppColors.lightGray900),
                        decoration: InputDecoration(
                          hintText: '컴포넌트 이름 또는 설명 검색...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey : AppColors.lightText2.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tabs
              widget.isMobile
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _tabs.map((tab) => _buildTabItem(tab)).toList(),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tabs.map((tab) => _buildTabItem(tab)).toList(),
                    ),
              const SizedBox(height: 32),

              // Component Grid/List based on active tab
              _buildActiveTabContent(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(Map<String, dynamic> tab) {
    final isSelected = _activeTab == tab['id'];
    final accentColor = AppColors.accentCyan;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = tab['id'];
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [AppColors.primaryBlue, AppColors.accentCyan])
                : null,
            color: isSelected ? null : (widget.isDark ? AppColors.charcoal.withOpacity(0.5) : AppColors.lightGray200),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.transparent : (widget.isDark ? AppColors.blue900.withOpacity(0.3) : AppColors.lightGray300),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab['icon'] as IconData, size: 16, color: isSelected ? Colors.white : (widget.isDark ? Colors.white70 : AppColors.lightGray900)),
              const SizedBox(width: 8),
              Text(
                tab['label'] as String,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : (widget.isDark ? AppColors.gray100 : AppColors.lightGray900),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(bool isDark) {
    final items = _getComponentsForActiveTab();
    final filtered = items.where((item) {
      final name = item['title'].toString().toLowerCase();
      final desc = item['description'].toString().toLowerCase();
      return name.contains(_searchQuery) || desc.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            '검색 결과가 없습니다.',
            style: TextStyle(color: isDark ? Colors.grey : AppColors.lightText2),
          ),
        ),
      );
    }

    return Column(
      children: filtered.map((item) => _buildComponentCard(item, isDark)).toList(),
    );
  }

  Widget _buildComponentCard(Map<String, dynamic> item, bool isDark) {
    final title = item['title'] as String;
    final description = item['description'] as String;
    final path = item['path'] as String;
    final code = item['code'] as String;
    final isExpanded = _expandedCode[title] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          // Card Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: AppTypography.bodyLarge.copyWith(
                              color: isDark ? Colors.white : AppColors.lightGray900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black38 : AppColors.lightGray100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isDark ? Colors.white12 : AppColors.lightGray300,
                              ),
                            ),
                            child: Text(
                              path,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.gray100.withOpacity(0.7) : AppColors.lightText2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: isDark ? Colors.white70 : AppColors.lightGray900,
                      ),
                      onPressed: () {
                        setState(() {
                          _expandedCode[title] = !isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy_outlined,
                        color: isDark ? Colors.white70 : AppColors.lightGray900,
                        size: 20,
                      ),
                      onPressed: () => _copyToClipboard(code, title),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Preview Area
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : AppColors.lightGray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.lightGray300.withOpacity(0.5),
              ),
            ),
            child: item['preview'] as Widget,
          ),
          const SizedBox(height: 20),

          // Code Snippet Area
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A), // Tailwind Slate 900
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFFE2E8F0),
                    height: 1.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getComponentsForActiveTab() {
    switch (_activeTab) {
      case 'foundation':
        return [
          {
            'title': 'Color Palette',
            'description': '엔터프라이즈 통합 생산성 강화를 위해 수립된 SAM 브랜드 전용 컬러 시스템',
            'path': '/components/foundation/color.tsx',
            'code': '''import { ColorPalette } from "./foundation/color";

<ColorPalette />''',
            'preview': Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColorRow('Brand Primary', [
                  _buildColorBlock('Blue 500', '#0056B3', const Color(0xFF0056B3)),
                  _buildColorBlock('Cyan 400', '#00A8FF', const Color(0xFF00A8FF)),
                  _buildColorBlock('Deep Blue', '#0F172A', const Color(0xFF0F172A)),
                ]),
                const SizedBox(height: 16),
                _buildColorRow('System Status', [
                  _buildColorBlock('Success', '#10B981', const Color(0xFF10B981)),
                  _buildColorBlock('Warning', '#F59E0B', const Color(0xFFF59E0B)),
                  _buildColorBlock('Danger', '#EF4444', const Color(0xFFEF4444)),
                ]),
              ],
            ),
          },
          {
            'title': 'Typography',
            'description': '화면 가독성 및 계층화를 극대화하는 Pretendard 기반의 타이포 표 가이드라인',
            'path': '/components/foundation/typography.tsx',
            'code': '''import { Typography } from "./foundation/typography";

<Typography />''',
            'preview': Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Display Header (36px Bold)', style: TextStyle(fontFamily: 'Pretendard', fontSize: 36, fontWeight: FontWeight.bold, color: widget.isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 8),
                Text('Section Title (24px Bold)', style: TextStyle(fontFamily: 'Pretendard', fontSize: 24, fontWeight: FontWeight.bold, color: widget.isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 8),
                Text('Body Regular (14px Height 1.6)', style: TextStyle(fontFamily: 'Pretendard', fontSize: 14, fontWeight: FontWeight.normal, color: widget.isDark ? Colors.grey : Colors.black87)),
              ],
            ),
          },
          {
            'title': 'Spacing',
            'description': '레이아웃 일관성을 유지하는 4px 배수 그리드 스페이싱 토큰',
            'path': '/components/foundation/spacing.tsx',
            'code': '''import { Spacing } from "./foundation/spacing";

<Spacing />''',
            'preview': Row(
              children: [
                _buildSpacingBlock('4px', 10),
                _buildSpacingBlock('8px', 20),
                _buildSpacingBlock('12px', 30),
                _buildSpacingBlock('16px', 40),
                _buildSpacingBlock('20px', 50),
              ],
            ),
          }
        ];
      case 'atoms':
        return [
          {
            'title': 'Button',
            'description': '제조 및 관제 시스템 환경에서 오동작 방지와 최상의 터치/클릭 반응을 위해 최적화된 버튼',
            'path': '/components/ui/button.tsx',
            'code': '''import { Button } from "./ui/button";

<Button>기본</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="destructive">Destructive</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>''',
            'preview': Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                  child: const Text('기본', style: TextStyle(color: Colors.white)),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentCyan)),
                  child: const Text('Outline', style: TextStyle(color: AppColors.accentCyan)),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Ghost', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Destructive', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          },
          {
            'title': 'Badge',
            'description': '품질 상태 및 작업 단계 상태값을 전달하는 시각 뱃지',
            'path': '/components/ui/badge.tsx',
            'code': '''import { Badge } from "./ui/badge";

<Badge>기본</Badge>
<Badge variant="outline">Outline</Badge>
<Badge variant="secondary">Secondary</Badge>
<Badge variant="destructive">Destructive</Badge>''',
            'preview': Row(
              children: [
                _buildBadgeWidget('기본', Colors.blue, Colors.white),
                const SizedBox(width: 8),
                _buildBadgeWidget('Outline', Colors.transparent, Colors.blue, hasBorder: true),
                const SizedBox(width: 8),
                _buildBadgeWidget('Secondary', Colors.grey, Colors.white),
                const SizedBox(width: 8),
                _buildBadgeWidget('Destructive', Colors.red, Colors.white),
              ],
            ),
          },
          {
            'title': 'Input',
            'description': '엔터프라이즈 대량 데이터 입력을 지원하는 표준 텍스트 인풋 필드',
            'path': '/components/ui/input.tsx',
            'code': '''import { Input } from "./ui/input";
import { Label } from "./ui/label";

<Label htmlFor="name">이름</Label>
<Input id="name" placeholder="이름을 입력하세요" />''',
            'preview': Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이름', style: TextStyle(fontWeight: FontWeight.bold, color: widget.isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.black38 : Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: '이름을 입력하세요',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          }
        ];
      case 'molecules':
        return [
          {
            'title': 'Select',
            'description': '품목 분류 및 공정 단계를 신속하게 교체할 수 있는 드롭다운 셀렉터',
            'path': '/components/ui/select.tsx',
            'code': '''import { Select, SelectContent, SelectItem, SelectTrigger } from "./ui/select";''',
            'preview': Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.black38 : Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text('활성 상태 선택', style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          },
          {
            'title': 'Card',
            'description': '공정 데이터 요약을 그룹화하여 가시성을 확보하는 컨테이너 카드',
            'path': '/components/ui/card.tsx',
            'code': '''import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "./ui/card";''',
            'preview': Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.black45 : Colors.white,
                border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('기본 공정 정보 카드', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('해당 공정의 전반적인 요약 정보를 전달합니다.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: const [
                      Text('상태: 정상 가동'),
                      Text('가동율: 98%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          }
        ];
      case 'organisms':
        return [
          {
            'title': 'Page Header',
            'description': '엔터프라이즈 모듈 구조상 각 페이지의 상단에 위치하여 대시보드 맥락 정보를 공유하는 헤더',
            'path': '/components/organisms/PageHeader.tsx',
            'code': '''import { PageHeader } from "./organisms/PageHeader";

<PageHeader
  title="설비 모니터링"
  subtitle="실시간 공정 관리 및 에러 이벤트 트래킹"
  action={<Button>새 설비 등록</Button>}
/>''',
            'preview': Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.black38 : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('설비 모니터링 대시보드', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('실시간 스마트 설비 제어 및 에러 트래킹', style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.8))),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                    child: const Text('새 설비 등록', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          },
          {
            'title': 'Stat Cards',
            'description': '핵심 수치 정보(KPI)를 격자 형태로 신속히 요약 전달하는 대시보드 핵심 오가니즘',
            'path': '/components/organisms/StatCards.tsx',
            'code': '''import { StatCards } from "./organisms/StatCards";''',
            'preview': GridView.count(
              crossAxisCount: widget.isMobile ? 2 : 4,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatBox('전체 작업 오더', '1,248건', Colors.blue),
                _buildStatBox('정상 설비', '98.5%', Colors.green),
                _buildStatBox('임계 경보', '3건', Colors.orange),
                _buildStatBox('정지 오더', '0건', Colors.red),
              ],
            ),
          }
        ];
      case 'templates':
        return [
          {
            'title': 'Unified List Template',
            'description': '목록-필터-검색-그리드 패턴이 포함된 정형 리스트 템플릿',
            'path': '/components/templates/UnifiedListTemplate.tsx',
            'code': '''import { UnifiedListTemplate } from "./templates/UnifiedListTemplate";''',
            'preview': Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.withOpacity(0.3), style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: const [
                  Icon(Icons.layers, size: 32, color: Colors.blue),
                  SizedBox(height: 8),
                  Text('Unified List Template', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('3컬럼 그리드, 탭 필터링 및 대용량 목록 렌더링 최적화 템플릿', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                ],
              ),
            ),
          }
        ];
      case 'cards':
        return [
          {
            'title': 'Quote Card',
            'description': 'MES ERP 연동 수주 및 발주 계약 상태 관리를 시각화한 견적 정보 카드',
            'path': '/components/cards/QuoteCard.tsx',
            'code': '''import { QuoteCard } from "./cards/QuoteCard";''',
            'preview': Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.black38 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Q-2026-A03', style: TextStyle(color: Colors.blue, fontSize: 10, fontFamily: 'monospace')),
                      ),
                      _buildBadgeWidget('승인완료', Colors.green, Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('삼성전자 평택 캠퍼스 스마트 라인 구축 건', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: const [
                        Text('최종 계약가', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('₩158,000,000', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          }
        ];
      default:
        return [];
    }
  }

  Widget _buildColorRow(String groupName, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
        const SizedBox(height: 8),
        Row(children: children),
      ],
    );
  }

  Widget _buildColorBlock(String label, String hex, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(hex, style: const TextStyle(color: Colors.white70, fontSize: 8)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingBlock(String label, double size) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            color: AppColors.accentCyan,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildBadgeWidget(String label, Color bgColor, Color textColor, {bool hasBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        border: hasBorder ? Border.all(color: textColor.withValues(alpha: 0.5)) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
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
