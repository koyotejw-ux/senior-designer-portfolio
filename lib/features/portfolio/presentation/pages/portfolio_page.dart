import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';
import '../../../home/data/providers/content_provider.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  final String? initialTab;
  const PortfolioPage({super.key, this.initialTab});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;
  int _selectedIndex = -1;
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
      'id': 'p7',
      'title': 'FARM SYSTEM',
      'subtitle': '스마트 농가 모니터링 시스템 UX/UI',
      'company': 'Smart Farm Solution',
      'year': '2023-2024',
      'category': 'IoT Device',
      'description': '농가 온습도 모니터링, 급수 및 조명 제어, 작물 상태 진단 등 스마트 팜 IoT 관리 화면 기획 및 UI 설계.',
      'tags': ['IoT Device', 'Dashboard', 'Design System', 'Figma'],
      'gradient': [AppColors.highlightGreen, AppColors.accentCyan],
      'imageUrl': 'assets/images/farm_1.jpg',
      'mainScreenImages': [
        'assets/images/farm_1.jpg',
        'assets/images/farm_2.jpg',
        'assets/images/farm_3.jpg'
      ],
      'details': {
        'role': 'Lead Product Designer',
        'duration': '6개월 (2023-2024)',
        'teamSize': '6명 (디자이너 1명, 개발자 4명, PM 1명)',
        'achievements': [
          '농가 실시간 모니터링 대시보드 UI 설계',
          '원격 기기 제어(급수, 조명) 사용자 시나리오 정의',
          '데이터 수집 및 통계 시각화 구현',
          '현장 필드 테스트 피드백 반영 사용성 개선',
        ],
        'technologies': [
          'Figma',
          'IoT Device',
          'Design System',
          'Dashboard',
        ],
      },
    },
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
      'imageUrl': 'assets/images/aia_thumbnail.jpg',
      'mainScreenImages': [
        'assets/images/aia.jpg',
      ],
      'details': {
        'role': 'Senior Product Designer',
        'duration': '2025',
        'teamSize': '8명 (디자이너 2명, 개발자 4명, PM 2명)',
        'achievements': [
          '고령자 전용 접근성 가이드라인 수립',
          '터치 영역 44px 이상, 폰트 크기 18px 이상 적용',
          '핵심 기능 3단계 이내 도달 UX 설계',
          'Figma 기반 디자인 시스템 구축',
        ],
        'technologies': [
          'Figma',
          'Mobile UX',
          'Accessibility',
          'Design System',
        ],
      },
    },
    {
      'id': 'wallpad',
      'title': '현대에이치티 월패드',
      'subtitle': 'HT 범용 안드로이드 월패드 디자인 시스템',
      'company': 'Hyundai HT',
      'year': '2018-2023',
      'category': 'IoT Device',
      'description':
          '동종 업계 1위 유지 기반 HT 안드로이드 월패드 라인업 UX 설계 프로세스 체계화. 현대/포스코/금호/한양/한화/대림 등 고객사 맞춤형 월패드(7~24인치) UX/UI 기획 및 통합 디자인 시스템 적용.',
      'tags': ['Figma', 'Android', 'Design System', 'IoT UI/UX'],
      'gradient': [AppColors.primaryBlue, AppColors.accentCyan],
      'imageUrl': 'assets/images/ht_01.jpg',
      'mainScreenImages': [
        'assets/images/ht_01.jpg',
        'assets/images/ht_02_1.jpg',
        'assets/images/ht_02_2.jpg',
        'assets/images/ht_03_1.jpg',
        'assets/images/ht_03_2.jpg'
      ],
      'details': {
        'role': 'Product Lead',
        'duration': '5년 7개월 (2018-2023)',
        'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
        'achievements': [
          '동종 업계 1위 유지 기반 UX 설계 프로세스 체계화',
          '5개 건설사 대응 범용 디자인 시스템 구축',
          '7~24인치 디바이스 대응 반응형 UI 설계',
          '월패드-앱 연동 UX 최적화',
          'HT 범용 월패드 전용 디자인 시스템 구축 및 전 제품군 적용',
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
      'imageUrl': 'assets/images/hthome_01_1.jpg',
      'mainScreenImages': [
        'assets/images/hthome_01_1.jpg',
        'assets/images/hthome_01_2.jpg',
        'assets/images/hthome_01_3.jpg'
      ],
      'details': {
        'role': 'Senior Product Designer',
        'duration': '2년 (2021-2023)',
        'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
        'achievements': [
          'iOS/Android 앱스토어 정식 론칭',
          '월패드-앱 실시간 연동 UX 설계',
          '스마트홈 기기 통합 제어 UI 구축',
          '사용자 만족도 85% 달성',
        ],
        'technologies': [
          'Figma',
          'iOS',
          'Android',
          'Smart Home',
          'IoT Integration',
        ],
      },
    },
    {
      'id': 'p4',
      'title': 'SOULARK',
      'subtitle': '모바일 게임 UX/UI 디자인',
      'company': 'BluestoneSoft',
      'year': '2016-2017',
      'category': 'Game UI',
      'description':
          'SOULARK 모바일 게임의 전반적인 UX/UI 개발. Unity3D 기반 GUI 인터랙션 및 애니메이션 설계.',
      'tags': ['Game UI', 'Unity3D', 'Mobile', 'Photoshop'],
      'gradient': [AppColors.highlightGreen, AppColors.accentCyan],
      'imageUrl': 'assets/images/soulark_1.jpg',
      'mainScreenImages': [
        'assets/images/soulark_1.jpg',
        'assets/images/soulark_2.jpg',
        'assets/images/soulark_3.jpg'
      ],
      'details': {
        'role': 'UI/UX Designer',
        'duration': '1년 (2016-2017)',
        'teamSize': '20명 (디자이너 4명, 개발자 12명, 기획자 4명)',
        'achievements': [
          'Unity3D 기반 GUI 시스템 구축',
          '게임 내 100+ UI 화면 디자인',
          '인터랙션 애니메이션 설계 및 구현',
          'UI 최적화로 렌더링 성능 30% 향상',
        ],
        'technologies': ['Unity3D', 'Photoshop', 'Illustrator', 'Game UI'],
      },
    },
    {
      'id': 'p5',
      'title': 'CLOSERS',
      'subtitle': '클로저스 웹사이트 UX/UI 디자인',
      'company': 'NEXON Korea',
      'year': '2014',
      'category': 'Web Design',
      'description':
          '클로저스 CBT 반응형 웹사이트 UX/UI 개발. 사내 최초로 PC/태블릿/모바일 대상 반응형 웹 구현 적용.',
      'tags': ['Web Design', 'Responsive', 'Game Promotion', 'HTML/CSS'],
      'gradient': [AppColors.primaryBlue, AppColors.blue400],
      'imageUrl': 'assets/images/closers_1.jpg',
      'mainScreenImages': [
        'assets/images/closers_1.jpg',
        'assets/images/closers_2.jpg',
        'assets/images/closers_3.jpg'
      ],
      'details': {
        'role': 'Web Designer',
        'duration': '6개월 (2014)',
        'teamSize': '10명 (디자이너 2명, 개발자 6명, 기획자 2명)',
        'achievements': [
          'NEXON 사내 최초 반응형 웹사이트 구축',
          'PC/태블릿/모바일 3단계 브레이크포인트 설계',
          'CBT 신청자 10만명 돌파',
          '웹 접근성 인증 AA 등급 획득',
        ],
        'technologies': [
          'HTML5',
          'CSS3',
          'JavaScript',
          'Responsive Design',
          'Photoshop',
        ],
      },
    },
    {
      'id': 'p6',
      'title': 'NEXON PROMOTION',
      'subtitle': '넥슨 게임 프로모션 디자인 및 웹 퍼블리싱',
      'company': 'NEXON Korea',
      'year': '2010.10-2014.12',
      'category': 'Web Design',
      'description':
          '넥슨 라이브 게임들의 대규모 업데이트 및 신작 론칭 프로모션 웹사이트 UX/UI 디자인 및 퍼블리싱 총괄. 사내 표준 마크업 가이드 준수 및 크로스 브라우징 완벽 구현.',
      'tags': ['Web Design', 'Promotion', 'HTML/CSS', 'Photoshop'],
      'gradient': [AppColors.accentCyan, AppColors.highlightGreen],
      'imageUrl': 'assets/images/promotion_1.jpg',
      'mainScreenImages': [
        'assets/images/promotion_1.jpg',
        'assets/images/promotion_2.jpg'
      ],
      'details': {
        'role': 'Senior Web Designer',
        'duration': '4년 (2010-2014)',
        'teamSize': '8명 (디자이너 2명, 개발자 4명, PM 2명)',
        'achievements': [
          '넥슨 라이브 게임 업데이트 프로모션 총괄',
          '사내 웹 표준 가이드라인 수립 및 크로스 브라우징 보장',
          '프로모션 페이지 방문율 및 이벤트 참여율 향상',
          'SEO 및 로딩 최적화를 통한 성능 개선',
        ],
        'technologies': [
          'HTML5',
          'CSS3',
          'JavaScript',
          'Photoshop',
          'Illustrator',
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

    int startIndex = 0;
    if (widget.initialTab == 'corporate') {
      startIndex = 1;
    }

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: startIndex,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _allProjects {
    final providerProjects = ref.watch(projectsProvider).valueOrNull ?? [];
    final mappedProviderProjects = providerProjects
        .map(
          (p) => {
            'id': p.id,
            'title': p.title,
            'subtitle': p.subtitle,
            'company': p.company,
            'year': p.year,
            'category': p.category,
            'description': p.description,
            'tags': p.tags,
            'gradient': p.gradientColors.isNotEmpty
                ? p.gradientColors
                : [AppColors.primaryBlue, AppColors.accentCyan],
            'details': {
              'role': p.role,
              'duration': p.duration,
              'teamSize': p.teamSize,
              'achievements': <String>[],
              'technologies': p.tags,
            },
            'imageUrl': p.imageUrl,
            'isCorporate': p.isCorporate,
          },
        )
        .toList();

    // Avoid duplicates if same ID exists
    final Map<String, Map<String, dynamic>> merged = {};
    for (var p in _projects) {
      merged[p['id'] as String] = p;
    }
    for (var p in mappedProviderProjects) {
      merged[p['id'] as String] = p;
    }

    return merged.values.toList();
  }

  List<Map<String, dynamic>> get _filteredProjects {
    // Top tab (Representative) shows ONLY projects where isCorporate is false
    final all = _allProjects
        .where((p) => (p['isCorporate'] ?? false) == false)
        .toList();
    if (_selectedCategory == 'All') {
      return all;
    }
    return all
        .where((project) => project['category'] == _selectedCategory)
        .toList();
  }

  Map<String, List<Map<String, dynamic>>> get _corporateProjects {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    // Corporate tab shows ONLY projects where isCorporate is true
    final corporateOnly = _allProjects
        .where((p) => (p['isCorporate'] ?? false) == true)
        .toList();
    for (var project in corporateOnly) {
      final company = project['company'] as String;
      if (!grouped.containsKey(company)) {
        grouped[company] = [];
      }
      grouped[company]!.add(project);
    }
    return grouped;
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

          // Main Content (Tab Bar + Tab Bar View)
          Column(
            children: [
              _buildTabBar(isMobile, isDark),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Representative Portfolio
                    _buildRepresentativeTab(isMobile, isTablet, isDark),
                    // Tab 2: Corporate Portfolio
                    _buildCorporateTab(isMobile, isTablet, isDark),
                  ],
                ),
              ),
            ],
          ),

          // Back Button
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildRepresentativeTab(bool isMobile, bool isTablet, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(isMobile, isTablet, isDark),
          _buildCategoryFilter(isMobile, isTablet, isDark),
          _buildProjectGrid(isMobile, isTablet, isDark),
          _buildFooterCTA(isMobile, isTablet, isDark),
        ],
      ),
    );
  }

  Widget _buildCorporateTab(bool isMobile, bool isTablet, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCorporateHeroSection(isMobile, isTablet, isDark),
          _buildCorporateGallery(isMobile, isTablet, isDark),
          _buildFooterCTA(isMobile, isTablet, isDark),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 20,
      left: 20,
      child: SafeArea(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'BACK',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isMobile, bool isDark) {
    return Container(
      padding: EdgeInsets.only(top: isMobile ? 40 : 60, bottom: 20),
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: isMobile ? 320 : 500,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.charcoal.withOpacity(0.5)
                : AppColors.lightGray200,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? AppColors.blue900.withOpacity(0.3)
                  : AppColors.lightGray300,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.accentCyan],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: isDark
                ? AppColors.gray100
                : AppColors.lightText2,
            labelStyle: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 1.1,
            ),
            unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            tabs: const [
              Tab(text: '대표 포트폴리오'),
              Tab(text: '회사별 포트폴리오'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorporateHeroSection(bool isMobile, bool isTablet, bool isDark) {
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
        child: Column(
          children: [
            ScrollRevealWidget(
              delay: Duration.zero,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.accentCyan, AppColors.highlightGreen],
                ).createShader(bounds),
                child: Text(
                  'Corporate Journey',
                  style: (isMobile ? AppTypography.h2 : AppTypography.h1)
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '회사별로 정리된 프로젝트 갤러리입니다',
              style: AppTypography.bodyLarge.copyWith(
                color: isDark ? AppColors.gray100 : AppColors.lightText2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorporateGallery(bool isMobile, bool isTablet, bool isDark) {
    final corporateData = _corporateProjects;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: corporateData.keys.length,
            itemBuilder: (context, index) {
              final company = corporateData.keys.elementAt(index);
              final projects = corporateData[company]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.accentCyan,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          company,
                          style: AppTypography.h4.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColors.lightGray900,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${projects.length})',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.gray100.withOpacity(0.5)
                                : AppColors.lightText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, pIndex) {
                      return _buildCorporateProjectCard(
                        projects[pIndex],
                        isDark,
                        isMobile,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCorporateProjectCard(
    Map<String, dynamic> project,
    bool isDark,
    bool isMobile,
  ) {
    return ScrollRevealWidget(
      delay: const Duration(milliseconds: 100),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.push('/portfolio/${project['id']}'),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.charcoal.withOpacity(0.4)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (project['gradient'] as List<Color>)[0].withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: project['gradient'] as List<Color>,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.work_outline,
                        color: Colors.white.withOpacity(0.5),
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'] as String,
                        style: AppTypography.bodyLarge.copyWith(
                          color: isDark ? Colors.white : AppColors.lightGray900,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project['subtitle'] as String,
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.gray100.withOpacity(0.7)
                              : AppColors.lightText2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
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
                    style:
                        (isMobile ? AppTypography.h1 : AppTypography.display1)
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
                  style: (isMobile ? AppTypography.bodyLarge : AppTypography.h4)
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
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
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
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
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
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
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
                          (project['gradient'] as List<Color>)[0].withValues(
                            alpha: 0.15,
                          ),
                          (project['gradient'] as List<Color>)[1].withValues(
                            alpha: 0.08,
                          ),
                        ]
                      : [
                          (project['gradient'] as List<Color>)[0].withValues(
                            alpha: 0.08,
                          ),
                          (project['gradient'] as List<Color>)[1].withValues(
                            alpha: 0.04,
                          ),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? (project['gradient'] as List<Color>)[0].withValues(
                          alpha: isHovered ? 0.5 : 0.3,
                        )
                      : (project['gradient'] as List<Color>)[0].withValues(
                          alpha: isHovered ? 0.3 : 0.2,
                        ),
                  width: isHovered ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? (project['gradient'] as List<Color>)[0].withValues(
                            alpha: isHovered ? 0.3 : 0.2,
                          )
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
                      style: (isMobile ? AppTypography.h5 : AppTypography.h4)
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
                          horizontal: 10,
                          vertical: 4,
                        ),
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
          horizontal: isMobile
              ? 24
              : isTablet
              ? 60
              : 100,
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
                  style: (isMobile ? AppTypography.h5 : AppTypography.h4)
                      .copyWith(
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
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
                                color: AppColors.accentCyan.withValues(
                                  alpha: 0.3,
                                ),
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

  BackgroundPainter({required this.animation, required this.isDark})
    : super(repaint: animation);

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
