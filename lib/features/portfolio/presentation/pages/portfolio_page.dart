import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Mobile App',
    'IoT Device',
    'Web Design',
    'Game UI',
  ];

  final List<Map<String, dynamic>> _projects = [
    {
      'id': 'aia-senior-mode',
      'title': 'AIA+ SENIOR MODE',
      'subtitle': '고령자 전용 모드 UX/UI 디자인 시스템',
      'company': 'ING People',
      'year': '2025',
      'category': 'Mobile App',
      'description':
          'AIA 생명 앱의 고령자 전용 모드 메인 UX 기획 및 디자인 시스템 구축. 보험료 납입, 보험계약대출 상환, 자동부활 신청 등 핵심 GUI 정의.',
      'tags': ['Mobile UX', 'Design System', 'Accessibility', 'Figma'],
      'gradient': [AppColors.accentCyan, AppColors.blue400],
      'details': {
        'role': 'Senior Product Designer',
        'duration': '2025',
        'teamSize': '8명 (디자이너 2명, 개발자 4명, PM 2명)',
        'achievements': [
          '고령자 전용 접근성 가이드라인 수립',
          '터치 영역 44px 이상, 폰트 크기 18px 이상 적용',
          '핵심 기능 3단계 이내 도달 UX 설계',
          'Figma 기반 디자인 시스템 구축'
        ],
        'technologies': ['Figma', 'Mobile UX', 'Accessibility', 'Design System'],
      },
    },
    {
      'id': 'wallpad',
      'title': 'WALLPAD',
      'subtitle': '현대건설 전용 13.3인치 안드로이드 월패드',
      'company': 'Hyundai HT',
      'year': '2021-2023',
      'category': 'IoT Device',
      'description':
          'HT 범용 월패드 디자인 시스템 구축. 현대/포스코/금호/한양/한화 등 고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 통합 디자인 시스템 적용.',
      'tags': ['IoT UI/UX', 'Android', 'Design System', 'Figma'],
      'gradient': [AppColors.primaryBlue, AppColors.accentCyan],
      'details': {
        'role': 'Lead Product Designer',
        'duration': '2년 (2021-2023)',
        'teamSize': '12명 (디자이너 3명, 개발자 7명, PM 2명)',
        'achievements': [
          '5개 건설사 대응 가능한 범용 디자인 시스템 구축',
          '7인치~24인치 디바이스 대응 반응형 UI 설계',
          '월패드-앱 연동 UX 최적화',
          '디자인 시스템 문서화 및 가이드라인 제작'
        ],
        'technologies': ['Figma', 'Android', 'IoT', 'Design System', 'Zeplin'],
      },
    },
    {
      'id': 'ht-home',
      'title': 'HT HOME 2.0',
      'subtitle': '주거전용 스마트홈 통합 앱',
      'company': 'Hyundai HT',
      'year': '2021-2023',
      'category': 'Mobile App',
      'description':
          'HT HOME 및 HT Imazu 앱 앱스토어 론칭. 월패드와 통합 연동 최적화 및 사용자 접점 확대.',
      'tags': ['Mobile App', 'iOS', 'Android', 'Smart Home'],
      'gradient': [AppColors.blue400, AppColors.accentCyan],
      'details': {
        'role': 'Senior Product Designer',
        'duration': '2년 (2021-2023)',
        'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
        'achievements': [
          'iOS/Android 앱스토어 정식 론칭',
          '월패드-앱 실시간 연동 UX 설계',
          '스마트홈 기기 통합 제어 UI 구축',
          '사용자 만족도 85% 달성'
        ],
        'technologies': [
          'Figma',
          'iOS',
          'Android',
          'Smart Home',
          'IoT Integration'
        ],
      },
    },
    {
      'id': 'soulark',
      'title': 'SOULARK',
      'subtitle': '모바일 게임 UX/UI 디자인',
      'company': 'BluestoneSoft',
      'year': '2016-2017',
      'category': 'Game UI',
      'description':
          'SOULARK 모바일 게임의 전반적인 UX/UI 개발. Unity3D 기반 GUI 인터랙션 및 애니메이션 설계.',
      'tags': ['Game UI', 'Unity3D', 'Mobile', 'Photoshop'],
      'gradient': [AppColors.highlightGreen, AppColors.accentCyan],
      'details': {
        'role': 'UI/UX Designer',
        'duration': '1년 (2016-2017)',
        'teamSize': '20명 (디자이너 4명, 개발자 12명, 기획자 4명)',
        'achievements': [
          'Unity3D 기반 GUI 시스템 구축',
          '게임 내 100+ UI 화면 디자인',
          '인터랙션 애니메이션 설계 및 구현',
          'UI 최적화로 렌더링 성능 30% 향상'
        ],
        'technologies': ['Unity3D', 'Photoshop', 'Illustrator', 'Game UI'],
      },
    },
    {
      'id': 'closers',
      'title': 'CLOSERS',
      'subtitle': '클로저스 웹사이트 UX/UI 디자인',
      'company': 'NEXON Korea',
      'year': '2014',
      'category': 'Web Design',
      'description':
          '클로저스 CBT 반응형 웹사이트 UX/UI 개발. 사내 최초로 PC/태블릿/모바일 대상 반응형 웹 구현 적용.',
      'tags': ['Web Design', 'Responsive', 'Game Promotion', 'HTML/CSS'],
      'gradient': [AppColors.primaryBlue, AppColors.blue400],
      'details': {
        'role': 'Web Designer',
        'duration': '6개월 (2014)',
        'teamSize': '10명 (디자이너 2명, 개발자 6명, 기획자 2명)',
        'achievements': [
          'NEXON 사내 최초 반응형 웹사이트 구축',
          'PC/태블릿/모바일 3단계 브레이크포인트 설계',
          'CBT 신청자 10만명 돌파',
          '웹 접근성 인증 AA 등급 획득'
        ],
        'technologies': [
          'HTML5',
          'CSS3',
          'JavaScript',
          'Responsive Design',
          'Photoshop'
        ],
      },
    },
  ];

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

  List<Map<String, dynamic>> get _filteredProjects {
    if (_selectedCategory == 'All') {
      return _projects;
    }
    return _projects
        .where((project) => project['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          CustomPaint(
            painter: BackgroundPainter(
              animation: _animationController,
              isDark: isDark,
            ),
            size: Size.infinite,
          ),

          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                _buildHeroSection(isMobile, isTablet, isDark),

                // Category Filter
                _buildCategoryFilter(isMobile, isTablet, isDark),

                // Project Grid
                _buildProjectGrid(isMobile, isTablet, isDark),

                // Footer CTA
                _buildFooterCTA(isMobile, isTablet, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              ScrollRevealWidget(
                delay: Duration.zero,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.accentCyan,
                      AppColors.highlightGreen,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Portfolio',
                    style: (isMobile ? AppTypography.h1 : AppTypography.display1)
                        .copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 20 : 24),
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  '19년 경력으로 축적한 실전 프로젝트',
                  style: (isMobile
                          ? AppTypography.bodyLarge
                          : AppTypography.h4)
                      .copyWith(
                    color: isDark
                        ? AppColors.gray100.withValues(alpha: 0.8)
                        : AppColors.lightText2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              ScrollRevealWidget(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  '대기업부터 스타트업까지, 모바일 앱부터 IoT 디바이스까지\n다양한 도메인에서의 프로덕트 디자인 경험',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.gray100.withValues(alpha: 0.6)
                        : AppColors.lightText2.withValues(alpha: 0.8),
                    height: 1.6,
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

  Widget _buildCategoryFilter(bool isMobile, bool isTablet, bool isDark) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 24 : 32,
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Wrap(
              spacing: isMobile ? 8 : 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  AppColors.accentCyan,
                                ],
                              )
                            : null,
                        color: isSelected
                            ? null
                            : (isDark
                                ? AppColors.charcoal.withValues(alpha: 0.6)
                                : AppColors.lightGray200),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : (isDark
                                  ? AppColors.blue900.withValues(alpha: 0.3)
                                  : AppColors.lightGray300),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.gray100
                                  : AppColors.lightGray900),
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectGrid(bool isMobile, bool isTablet, bool isDark) {
    final filteredProjects = _filteredProjects;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: isMobile
              ? Column(
                  children: filteredProjects.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildProjectCard(
                        entry.value,
                        isDark,
                        isMobile,
                        isTablet,
                        entry.key,
                      ),
                    );
                  }).toList(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 1 : 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    childAspectRatio: isTablet ? 1.8 : 1.3,
                  ),
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(
                      filteredProjects[index],
                      isDark,
                      isMobile,
                      isTablet,
                      index,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    Map<String, dynamic> project,
    bool isDark,
    bool isMobile,
    bool isTablet,
    int index,
  ) {
    final isHovered = _selectedIndex == index;

    return ScrollRevealWidget(
      delay: Duration(milliseconds: 200 + index * 100),
      child: MouseRegion(
        onEnter: (_) => setState(() => _selectedIndex = index),
        onExit: (_) => setState(() => _selectedIndex = -1),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            context.push('/portfolio/${project['id']}');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: isHovered
                ? (Matrix4.identity()..setTranslationRaw(0.0, -8.0, 0.0))
                : Matrix4.identity(),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 24 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          (project['gradient'] as List<Color>)[0]
                              .withValues(alpha: 0.15),
                          (project['gradient'] as List<Color>)[1]
                              .withValues(alpha: 0.08),
                        ]
                      : [
                          (project['gradient'] as List<Color>)[0]
                              .withValues(alpha: 0.08),
                          (project['gradient'] as List<Color>)[1]
                              .withValues(alpha: 0.04),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? (project['gradient'] as List<Color>)[0]
                          .withValues(alpha: isHovered ? 0.5 : 0.3)
                      : (project['gradient'] as List<Color>)[0]
                          .withValues(alpha: isHovered ? 0.3 : 0.2),
                  width: isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? (project['gradient'] as List<Color>)[0]
                            .withValues(alpha: isHovered ? 0.3 : 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: isHovered ? 30 : 20,
                    offset: Offset(0, isHovered ? 12 : 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: project['gradient'] as List<Color>,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      project['category'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 16 : 20),

                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: project['gradient'] as List<Color>,
                    ).createShader(bounds),
                    child: Text(
                      project['title'] as String,
                      style: (isMobile
                              ? AppTypography.h5
                              : AppTypography.h4)
                          .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    project['subtitle'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.gray100 : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Company & Year
                  Text(
                    '${project['company']} • ${project['year']}',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.gray100.withValues(alpha: 0.6)
                          : AppColors.lightText2.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),

                  SizedBox(height: isMobile ? 12 : 16),

                  // Description
                  Text(
                    project['description'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.gray100.withValues(alpha: 0.8)
                          : AppColors.lightText2,
                      height: 1.6,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (project['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? (project['gradient'] as List<Color>)[0]
                                  .withValues(alpha: 0.2)
                              : (project['gradient'] as List<Color>)[0]
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? (project['gradient'] as List<Color>)[0]
                                : (project['gradient'] as List<Color>)[0]
                                    .withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterCTA(bool isMobile, bool isTablet, bool isDark) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 800),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 60 : 80,
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.all(isMobile ? 32 : 48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue.withValues(alpha: 0.1),
                  AppColors.accentCyan.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '더 자세한 프로젝트 경험이 궁금하신가요?',
                  style:
                      (isMobile ? AppTypography.h5 : AppTypography.h4).copyWith(
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  '19년간 축적한 실전 경험과 노하우를\n경력기술서와 자기소개서에서 확인하실 수 있습니다',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.gray100.withValues(alpha: 0.8)
                        : AppColors.lightText2,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 24 : 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.push('/documents'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 32,
                            vertical: isMobile ? 12 : 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.accentCyan,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.accentCyan.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            '이력서 및 문서 보기',
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

  BackgroundPainter({
    required this.animation,
    required this.isDark,
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
        'color': AppColors.primaryBlue.withValues(alpha: 0.1),
      },
      {
        'x': size.width * 0.8,
        'y': size.height * 0.6,
        'radius': 200.0,
        'color': AppColors.accentCyan.withValues(alpha: 0.08),
      },
      {
        'x': size.width * 0.5,
        'y': size.height * 0.8,
        'radius': 180.0,
        'color': AppColors.highlightGreen.withValues(alpha: 0.06),
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
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
