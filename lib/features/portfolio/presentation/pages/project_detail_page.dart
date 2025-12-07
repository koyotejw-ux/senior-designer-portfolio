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
        'role': 'Designer', // Default
        'duration': projectModel.year,
        'teamSize': '-',
        'overview': projectModel.description,
        'challenges': <String>[],
        'solutions': <String>[],
        'achievements': <String>[],
        'technologies': projectModel.tags,
        'process': <Map<String, String>>[],
        'imageUrl': projectModel.imageUrl, // Add image url
      };
    }

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

                // Project Image (New)
                if (projectData['imageUrl'] != null)
                  _buildProjectImage(
                    projectData['imageUrl'],
                    isMobile,
                    isTablet,
                  ),

                // Project Info
                _buildProjectInfo(projectData, isMobile, isTablet, isDark),

                // Overview
                _buildOverview(projectData, isMobile, isTablet, isDark),

                // Challenges & Solutions (Only if available)
                if ((projectData['challenges'] as List).isNotEmpty)
                  _buildChallengesSolutions(
                    projectData,
                    isMobile,
                    isTablet,
                    isDark,
                  ),

                // Process (Only if available)
                if ((projectData['process'] as List).isNotEmpty)
                  _buildProcess(projectData, isMobile, isTablet, isDark),

                // Achievements (Only if available)
                if ((projectData['achievements'] as List).isNotEmpty)
                  _buildAchievements(projectData, isMobile, isTablet, isDark),

                // Technologies
                if ((projectData['technologies'] as List).isNotEmpty)
                  _buildTechnologies(projectData, isMobile, isTablet, isDark),

                // Navigation
                _buildNavigation(isMobile, isTablet, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectImage(String imageUrl, bool isMobile, bool isTablet) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.toLowerCase().endsWith('.svg')
                  ? SvgPicture.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => Container(
                        height: 400,
                        color: AppColors.charcoal,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : Container(
                      color: AppColors.charcoal,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                        filterQuality: FilterQuality.high,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 400,
                            width: double.infinity,
                            color: AppColors.charcoal,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
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
