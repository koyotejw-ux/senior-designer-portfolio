import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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
          'description':
              '65세 이상 고령자 페르소나 3종 정의. 각 페르소나별 니즈와 사용 시나리오 매핑.',
        },
        {
          'phase': 'Design',
          'title': 'UX/UI 디자인',
          'description':
              '접근성 가이드라인 기반 UI 컴포넌트 설계. 대형 터치 영역, 고대비 색상, 큰 폰트 적용.',
        },
        {
          'phase': 'Validation',
          'title': '사용성 테스트',
          'description':
              '시니어 20명 대상 5회 반복 테스트. 피드백 반영하여 UI 개선. 최종 만족도 92% 달성.',
        },
      ],
    },
    'wallpad': {
      'title': 'WALLPAD',
      'subtitle': '현대건설 전용 13.3인치 안드로이드 월패드',
      'company': 'Hyundai HT',
      'year': '2021-2023',
      'category': 'IoT Device',
      'gradient': [AppColors.primaryBlue, AppColors.accentCyan],
      'role': 'Lead Product Designer',
      'duration': '2년 (2021-2023)',
      'teamSize': '12명 (디자이너 3명, 개발자 7명, PM 2명)',
      'overview':
          'HT 범용 월패드 디자인 시스템을 구축하여 현대, 포스코, 금호, 한양, 한화 등 5개 건설사에 맞춤형 월패드를 제공한 프로젝트입니다. 7인치부터 24인치까지 다양한 디바이스를 지원하는 통합 디자인 시스템을 개발했습니다.',
      'challenges': [
        '5개 건설사별 브랜드 아이덴티티 유지 및 커스터마이징',
        '7인치~24인치 다양한 디바이스 대응 반응형 UI 설계',
        '기존 레거시 시스템과의 호환성 및 데이터 마이그레이션',
        '입주민 연령대별 사용성 격차 해소 (20대~70대)',
      ],
      'solutions': [
        '건설사별 테마 시스템 구축: 컬러, 로고, 아이콘 커스터마이징',
        '반응형 그리드 시스템 설계: 7~24인치 모든 디바이스 대응',
        'Figma 기반 통합 디자인 시스템: 재사용 가능한 컴포넌트 100+',
        '3세대 사용성 테스트: 각 연령대별 UI 최적화',
      ],
      'achievements': [
        '5개 건설사 대응 가능한 범용 디자인 시스템 구축',
        '7인치~24인치 디바이스 대응 반응형 UI 설계',
        '월패드-앱 연동 UX 최적화 (응답속도 40% 개선)',
        '디자인 시스템 문서화 및 가이드라인 제작 (200+ 페이지)',
        '입주민 만족도 87% 달성 (5개 건설사 평균)',
      ],
      'technologies': [
        'Figma',
        'Android',
        'IoT',
        'Design System',
        'Zeplin',
        'Responsive Design',
      ],
      'process': [
        {
          'phase': 'Research',
          'title': '시장 조사',
          'description':
              '5개 건설사 요구사항 수집 및 분석. 기존 월패드 사용성 평가. 경쟁사 벤치마킹.',
        },
        {
          'phase': 'Strategy',
          'title': '디자인 전략 수립',
          'description':
              '범용 디자인 시스템 아키텍처 설계. 건설사별 커스터마이징 전략 수립.',
        },
        {
          'phase': 'Design',
          'title': '디자인 시스템 구축',
          'description':
              'Figma 기반 컴포넌트 라이브러리 개발. 반응형 그리드 시스템 설계. 테마 시스템 구현.',
        },
        {
          'phase': 'Deploy',
          'title': '배포 및 검증',
          'description':
              '5개 건설사 순차 배포. 입주민 피드백 수집 및 개선. 사용성 테스트 실시.',
        },
      ],
    },
    'ht-home': {
      'title': 'HT HOME 2.0',
      'subtitle': '주거전용 스마트홈 통합 앱',
      'company': 'Hyundai HT',
      'year': '2021-2023',
      'category': 'Mobile App',
      'gradient': [AppColors.blue400, AppColors.accentCyan],
      'role': 'Senior Product Designer',
      'duration': '2년 (2021-2023)',
      'teamSize': '15명 (디자이너 3명, 개발자 10명, PM 2명)',
      'overview':
          'HT HOME 및 HT Imazu 앱을 iOS/Android 앱스토어에 정식 론칭한 프로젝트입니다. 월패드와 실시간 연동하여 스마트홈 기기를 통합 제어할 수 있는 모바일 앱을 개발했습니다.',
      'challenges': [
        '월패드-앱 실시간 연동 시 네트워크 지연 최소화',
        'iOS/Android 플랫폼별 디자인 가이드라인 준수',
        '다양한 스마트홈 기기(조명, 난방, 가전 등) 통합 제어 UI',
        '보안 및 프라이버시 이슈 해결 (입주민 정보 보호)',
      ],
      'solutions': [
        '실시간 연동 UX 설계: 로딩 상태 명확화, 오프라인 모드 제공',
        '플랫폼별 네이티브 UI 적용: iOS Human Interface, Android Material Design',
        '기기별 제어 패널 통합: 일관된 인터랙션 패턴 적용',
        '보안 강화: 생체 인증, 2단계 인증, 데이터 암호화',
      ],
      'achievements': [
        'iOS/Android 앱스토어 정식 론칭',
        '월패드-앱 실시간 연동 UX 설계 (응답속도 40% 개선)',
        '스마트홈 기기 통합 제어 UI 구축 (10+ 기기 지원)',
        '사용자 만족도 85% 달성 (앱스토어 리뷰 평균)',
        '월간 활성 사용자(MAU) 5만명 돌파',
      ],
      'technologies': [
        'Figma',
        'iOS',
        'Android',
        'Smart Home',
        'IoT Integration',
        'Real-time Sync',
      ],
      'process': [
        {
          'phase': 'Research',
          'title': '사용자 리서치',
          'description':
              '입주민 50명 대상 인터뷰 및 관찰. 스마트홈 사용 패턴 분석. 니즈 및 페인 포인트 도출.',
        },
        {
          'phase': 'Design',
          'title': 'UX/UI 디자인',
          'description':
              'iOS/Android 플랫폼별 디자인 가이드라인 준수. 월패드-앱 연동 UX 설계. 기기 제어 UI 개발.',
        },
        {
          'phase': 'Development',
          'title': '개발 협업',
          'description':
              '개발팀과 긴밀한 협업. 디자인 QA 및 개선. 사용성 테스트 반복.',
        },
        {
          'phase': 'Launch',
          'title': '앱스토어 론칭',
          'description':
              'iOS/Android 앱스토어 정식 출시. 사용자 피드백 수집 및 개선. 마케팅 지원.',
        },
      ],
    },
    'soulark': {
      'title': 'SOULARK',
      'subtitle': '모바일 게임 UX/UI 디자인',
      'company': 'BluestoneSoft',
      'year': '2016-2017',
      'category': 'Game UI',
      'gradient': [AppColors.highlightGreen, AppColors.accentCyan],
      'role': 'UI/UX Designer',
      'duration': '1년 (2016-2017)',
      'teamSize': '20명 (디자이너 4명, 개발자 12명, 기획자 4명)',
      'overview':
          'SOULARK 모바일 게임의 전반적인 UX/UI를 개발한 프로젝트입니다. Unity3D 기반 GUI 시스템을 구축하고, 100개 이상의 게임 UI 화면을 디자인했습니다.',
      'challenges': [
        'Unity3D 기반 GUI 시스템 구축 (모바일 최적화)',
        '100+ UI 화면 일관성 유지 및 디자인 시스템화',
        '게임 성능 최적화: UI 렌더링 부하 최소화',
        '복잡한 인벤토리, 캐릭터 육성 등 게임 시스템 UI 설계',
      ],
      'solutions': [
        'Unity3D GUI 컴포넌트 라이브러리 구축: 재사용 가능한 UI 요소',
        '게임 디자인 시스템 수립: 컬러, 타이포그래피, 아이콘 가이드라인',
        'UI 애틀라스 최적화: 텍스처 메모리 사용량 40% 절감',
        '프로토타입 반복 테스트: 사용자 피드백 반영',
      ],
      'achievements': [
        'Unity3D 기반 GUI 시스템 구축',
        '게임 내 100+ UI 화면 디자인',
        '인터랙션 애니메이션 설계 및 구현 (50+ 애니메이션)',
        'UI 최적화로 렌더링 성능 30% 향상',
        'CBT 참가자 만족도 88% 달성',
      ],
      'technologies': [
        'Unity3D',
        'Photoshop',
        'Illustrator',
        'Game UI',
        'Animation',
      ],
      'process': [
        {
          'phase': 'Concept',
          'title': '컨셉 디자인',
          'description':
              '게임 세계관 및 아트 스타일 정의. UI 무드보드 및 스타일 가이드 제작.',
        },
        {
          'phase': 'Design',
          'title': 'UI 디자인',
          'description':
              '100+ UI 화면 디자인. 게임 디자인 시스템 구축. 인터랙션 애니메이션 설계.',
        },
        {
          'phase': 'Implementation',
          'title': 'Unity 구현',
          'description':
              'Unity3D GUI 컴포넌트 개발. UI 애틀라스 최적화. 렌더링 성능 개선.',
        },
        {
          'phase': 'Testing',
          'title': 'CBT 테스트',
          'description':
              '클로즈 베타 테스트 진행. 사용자 피드백 수집 및 개선. 최종 QA.',
        },
      ],
    },
    'closers': {
      'title': 'CLOSERS',
      'subtitle': '클로저스 웹사이트 UX/UI 디자인',
      'company': 'NEXON Korea',
      'year': '2014',
      'category': 'Web Design',
      'gradient': [AppColors.primaryBlue, AppColors.blue400],
      'role': 'Web Designer',
      'duration': '6개월 (2014)',
      'teamSize': '10명 (디자이너 2명, 개발자 6명, 기획자 2명)',
      'overview':
          '클로저스 CBT 반응형 웹사이트를 UX/UI 개발한 프로젝트입니다. NEXON 사내 최초로 PC/태블릿/모바일 대상 반응형 웹을 구현했습니다.',
      'challenges': [
        'NEXON 사내 최초 반응형 웹사이트 구축 (선례 없음)',
        'PC/태블릿/모바일 3단계 브레이크포인트 설계',
        '게임 프로모션 콘텐츠와 CBT 신청 플로우 최적화',
        '웹 접근성 인증 AA 등급 달성 요구사항',
      ],
      'solutions': [
        '반응형 그리드 시스템 설계: 1200px/768px/320px 브레이크포인트',
        'Progressive Enhancement 전략: 모바일 우선 설계',
        'CBT 신청 플로우 최적화: 3단계 이내 완료',
        '웹 접근성 가이드라인 준수: WCAG 2.0 AA 등급',
      ],
      'achievements': [
        'NEXON 사내 최초 반응형 웹사이트 구축',
        'PC/태블릿/모바일 3단계 브레이크포인트 설계',
        'CBT 신청자 10만명 돌파 (목표 대비 200% 달성)',
        '웹 접근성 인증 AA 등급 획득',
        '사내 반응형 웹 표준 가이드라인으로 채택',
      ],
      'technologies': [
        'HTML5',
        'CSS3',
        'JavaScript',
        'Responsive Design',
        'Photoshop',
        'Web Accessibility',
      ],
      'process': [
        {
          'phase': 'Planning',
          'title': '기획 및 전략',
          'description':
              '게임 프로모션 전략 수립. CBT 신청 플로우 설계. 반응형 웹 요구사항 정의.',
        },
        {
          'phase': 'Design',
          'title': 'UI 디자인',
          'description':
              'PC/태블릿/모바일 UI 디자인. 반응형 그리드 시스템 구축. 웹 접근성 고려.',
        },
        {
          'phase': 'Development',
          'title': '퍼블리싱',
          'description':
              'HTML5/CSS3/JS 개발. 반응형 웹 구현. 크로스 브라우저 테스트.',
        },
        {
          'phase': 'Launch',
          'title': 'CBT 론칭',
          'description':
              '웹사이트 정식 오픈. CBT 신청 모니터링. 사용자 피드백 수집.',
        },
      ],
    },
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

    final project = _projectData[widget.projectId];

    if (project == null) {
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              gradient: project['gradient'] as List<Color>,
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
                _buildHeroSection(project, isMobile, isTablet, isDark),

                // Project Info
                _buildProjectInfo(project, isMobile, isTablet, isDark),

                // Overview
                _buildOverview(project, isMobile, isTablet, isDark),

                // Challenges & Solutions
                _buildChallengesSolutions(project, isMobile, isTablet, isDark),

                // Process
                _buildProcess(project, isMobile, isTablet, isDark),

                // Achievements
                _buildAchievements(project, isMobile, isTablet, isDark),

                // Technologies
                _buildTechnologies(project, isMobile, isTablet, isDark),

                // Navigation
                _buildNavigation(isMobile, isTablet, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(bool isMobile, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: ScrollRevealWidget(
        delay: Duration.zero,
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
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    style: (isMobile
                            ? AppTypography.h2
                            : AppTypography.display1)
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
                  style:
                      (isMobile ? AppTypography.h6 : AppTypography.h5).copyWith(
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
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(
                    children: _buildInfoCards(project, isDark, isMobile),
                  )
                : Row(
                    children: _buildInfoCards(project, isDark, isMobile),
                  ),
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
        .map((info) => Expanded(
              child: Container(
                margin: EdgeInsets.all(isMobile ? 8 : 12),
                padding: EdgeInsets.all(isMobile ? 20 : 24),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.charcoal.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (project['gradient'] as List<Color>)[0]
                        .withValues(alpha: 0.3),
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
            ))
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
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
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
          ...items.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.gray100.withValues(alpha: 0.9)
                            : AppColors.lightText,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Design Process',
                  style:
                      (isMobile ? AppTypography.h4 : AppTypography.h3).copyWith(
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: isMobile ? 32 : 48),
                if (isMobile)
                  Column(
                    children: process
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildProcessCard(
                                entry.value,
                                isDark,
                                isMobile,
                                project['gradient'] as List<Color>,
                              ),
                            ))
                        .toList(),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
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
        border: Border.all(
          color: gradient[0].withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              step['phase']!,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
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
        children:
            (project['achievements'] as List<String>).asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: project['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${e.key + 1}',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      e.value,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark
                            ? AppColors.gray100.withValues(alpha: 0.9)
                            : AppColors.lightText,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
                color:
                    (project['gradient'] as List<Color>)[0].withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              tech,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? (project['gradient'] as List<Color>)[0]
                    : (project['gradient'] as List<Color>)[0]
                        .withValues(alpha: 0.9),
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
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      (isMobile ? AppTypography.h4 : AppTypography.h3).copyWith(
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
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
          horizontal: isMobile ? 24 : isTablet ? 60 : 100,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 32,
                        vertical: isMobile ? 12 : 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryBlue, AppColors.accentCyan],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(alpha: 0.3),
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
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}
