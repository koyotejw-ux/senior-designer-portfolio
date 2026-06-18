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
      'company': 'ING People',
      'year': '2025',
      'category': 'Mobile App',
      'gradient': [AppColors.accentCyan, AppColors.blue400],
      'role': 'Senior Product Designer',
      'duration': '2025 (진행 중)',
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
        'role': projectModel.role ?? 'Designer',
        'duration': projectModel.duration ?? projectModel.year,
        'teamSize': projectModel.teamSize ?? '-',
        'overview': projectModel.description,
        'challenges': <String>[],
        'solutions': <String>[],
        'achievements': <String>[],
        'technologies': projectModel.tags,
        'process': <Map<String, String>>[],
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

                // Project Image(s)
                _buildProjectImages(
                  projectData,
                  isMobile,
                  isTablet,
                ),

                // Project Info
                if (!isAia) _buildProjectInfo(projectData, isMobile, isTablet, isDark),

                // Overview
                if (!isAia) _buildOverview(projectData, isMobile, isTablet, isDark),

                // Challenges & Solutions (Only if available)
                if (!isAia && (projectData['challenges'] as List).isNotEmpty)
                  _buildChallengesSolutions(
                    projectData,
                    isMobile,
                    isTablet,
                    isDark,
                  ),

                // Main Screens Gallery (New)
                if (!isAia &&
                    !(projectData['company']?.toString().toLowerCase().contains('hyundai ht') == true &&
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
                if (!isAia) _buildDesignSystem(projectData, isMobile, isTablet, isDark),

                // Process (Only if available)
                if (!isAia && (projectData['process'] as List).isNotEmpty)
                  _buildProcess(projectData, isMobile, isTablet, isDark),

                // Achievements (Only if available)
                if (!isAia && (projectData['achievements'] as List).isNotEmpty)
                  _buildAchievements(projectData, isMobile, isTablet, isDark),

                // Technologies
                if (!isAia && (projectData['technologies'] as List).isNotEmpty)
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
    final isWallpad = company.contains('hyundai ht') && (title.contains('wallpad') || title.contains('월패드'));
    final isHtHome = company.contains('hyundai ht') && (title.contains('home') || title.contains('홈'));
    final isSoulark = title.contains('soulark') || title.contains('소울아크');
    final isClosers = title.contains('closers') || title.contains('클로저스');
    final isPromotion = title.contains('promotion') || title.contains('프로모션');
    final isFarm = title.contains('farm') || title.contains('농가') || title.contains('농업');
    final isAia = title.contains('aia') || company.contains('aia');
    final screenWidth = MediaQuery.of(context).size.width;

    if (!isWallpad && !isHtHome && !isSoulark && !isClosers && !isPromotion && !isFarm && !isAia) {
      return const SizedBox.shrink();
    }

    final isNetwork = projectData['imageUrl'] != null && projectData['imageUrl']!.toString().startsWith('http');
    
    final List<Map<String, dynamic>> imagesToRender;
    if (isWallpad) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/ht_01.jpg' : 'assets/images/ht_01.jpg',
          'ratio': 13020 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/ht_02_1.jpg' : 'assets/images/ht_02_1.jpg',
          'ratio': 9540 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/ht_02_2.jpg' : 'assets/images/ht_02_2.jpg',
          'ratio': 9541 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/ht_03_1.jpg' : 'assets/images/ht_03_1.jpg',
          'ratio': 9789 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/ht_03_2.jpg' : 'assets/images/ht_03_2.jpg',
          'ratio': 9790 / 1920,
        },
      ];
    } else if (isHtHome) {
      imagesToRender = [
        {
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_1.jpg' : 'assets/images/hthome_01_1.jpg',
          'ratio': 9899 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_2.jpg' : 'assets/images/hthome_01_2.jpg',
          'ratio': 9899 / 1920,
        },
        {
          'url': isNetwork ? 'http://localhost:8080/images/hthome_01_3.jpg' : 'assets/images/hthome_01_3.jpg',
          'ratio': 9900 / 1920,
        },
      ];
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (project['gradient'] as List<Color>)
                    .map((c) => c.withValues(alpha: 0.2))
                    .toList(),
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (project['gradient'] as List<Color>)[0].withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Text(
              tech,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? (project['gradient'] as List<Color>)[0]
                    : (project['gradient'] as List<Color>)[0].withValues(
                        alpha: 0.9,
                      ),
                fontWeight: FontWeight.w700,
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
