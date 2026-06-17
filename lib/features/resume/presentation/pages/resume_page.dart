import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';
import 'dart:math' as math;

/// 정재웅 이력서 - 실제 경력 기반 인터랙티브 웹 디자인
class ResumePage extends ConsumerStatefulWidget {
  const ResumePage({super.key});

  @override
  ConsumerState<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends ConsumerState<ResumePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showHeaderLogo = false;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _onScroll() {
    final threshold = MediaQuery.of(context).size.height * 0.2;
    final showLogo = _scrollController.offset > threshold;

    if (showLogo != _showHeaderLogo) {
      setState(() {
        _showHeaderLogo = showLogo;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

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
          _buildAnimatedBackground(isDark),

          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Hero Section with Parallax
                _buildHeroSection(isDark, isMobile, isTablet),

                // Profile Summary with Stats
                ScrollRevealWidget(
                  child: _buildProfileSummary(isDark, isMobile, isTablet),
                ),

                // Core Competencies (NEW)
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 100),
                  child: _buildCoreCompetencies(isDark, isMobile, isTablet),
                ),

                // Experience Timeline
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 200),
                  child: _buildExperienceTimeline(isDark, isMobile, isTablet),
                ),

                // Skills & Tools
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 300),
                  child: _buildSkillsSection(isDark, isMobile, isTablet),
                ),

                // Education & Certifications
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 400),
                  child: _buildEducationSection(isDark, isMobile, isTablet),
                ),

                // Contact & Download
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 500),
                  child: _buildContactSection(isDark, isMobile, isTablet),
                ),
              ],
            ),
          ),

          // Floating Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(showLogo: _showHeaderLogo),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundPainter(
              isDark: isDark,
              animationValue: _floatingController.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      height: isMobile ? 500 : 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.deepSpace.withValues(alpha: 0.95),
                  AppColors.blue900.withValues(alpha: 0.8),
                  AppColors.charcoal.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.lightBg.withValues(alpha: 0.95),
                  AppColors.primaryBlue.withValues(alpha: 0.05),
                  AppColors.lightCard.withValues(alpha: 0.8),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Floating elements background
          ...List.generate(5, (index) {
            return Positioned(
              left: (index * 20.0) % 100,
              top: (index * 30.0) % 100,
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  final offset =
                      math.sin(
                        (_floatingController.value * 2 * math.pi) +
                            (index * 0.5),
                      ) *
                      20;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Container(
                      width: 100 + (index * 20),
                      height: 100 + (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (isDark
                                    ? AppColors.accentCyan
                                    : AppColors.primaryBlue)
                                .withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 100 : 120,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      'RESUME',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue,
                        letterSpacing: 4,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.5, end: 0, duration: 800.ms),
                const SizedBox(height: 24),
                Text(
                      '정재웅',
                      style: TextStyle(
                        fontSize: isMobile ? 56 : (isTablet ? 72 : 96),
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                        height: 1.0,
                        letterSpacing: -3,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 200.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 800.ms,
                      delay: 200.ms,
                    )
                    .shimmer(
                      duration: 2000.ms,
                      delay: 1000.ms,
                      color:
                          (isDark
                                  ? AppColors.accentCyan
                                  : AppColors.primaryBlue)
                              .withValues(alpha: 0.3),
                    ),
                const SizedBox(height: 16),
                Text(
                      'Senior Product Designer',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : (isTablet ? 32 : 40),
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.gray200
                            : AppColors.lightGray800,
                        height: 1.2,
                        letterSpacing: -1,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 400.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: 800.ms,
                      delay: 400.ms,
                    ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _buildHeroTag(isDark, isMobile, '19년 경력'),
                    _buildHeroTag(isDark, isMobile, 'UX/UI 전문'),
                    _buildHeroTag(isDark, isMobile, 'Hi-Fi Prototyping'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTag(bool isDark, bool isMobile, String text) {
    return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.blue900.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? AppColors.accentCyan.withValues(alpha: 0.3)
                  : AppColors.primaryBlue.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                    .withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
              letterSpacing: 0.5,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), duration: 800.ms, delay: 600.ms);
  }

  Widget _buildProfileSummary(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      isDark ? AppColors.primaryBlue : AppColors.highlightGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: isMobile ? 36 : (isTablet ? 48 : 56),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.blue900.withValues(alpha: 0.2),
                        AppColors.deepSpace.withValues(alpha: 0.3),
                      ]
                    : [
                        AppColors.lightGray100,
                        AppColors.primaryBlue.withValues(alpha: 0.05),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? AppColors.accentCyan.withValues(alpha: 0.2)
                    : AppColors.primaryBlue.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Text(
              '기획부터 디자인, 협업까지 사용자 중심의 해결을 먼저 생각하는 디자이너입니다. '
              '정보를 단순하게, 시각은 명확하게 전달하는 것을 중요하게 생각하며, 사용자 입장에서 먼저 고민하고 설명 가능한 디자인을 지향합니다.\n\n'
              '에이전시부터 제조, 통신업까지 다양한 산업군에서 UX/UI 디자인을 수행해왔으며, '
              'Web, Android, iOS, Linux 등 여러 플랫폼 환경에 맞춰 설계와 구현을 진행해왔습니다.',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                height: 1.9,
                color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 48),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.1 : 1.2,
            children: [
              _buildStatCard(
                isDark,
                isMobile,
                '19년',
                '경력',
                Icons.work_history,
                AppColors.primaryBlue,
                0,
              ),
              _buildStatCard(
                isDark,
                isMobile,
                '100+',
                '프로젝트',
                Icons.folder_special,
                AppColors.accentCyan,
                100,
              ),
              _buildStatCard(
                isDark,
                isMobile,
                '다양한',
                '플랫폼',
                Icons.devices,
                AppColors.highlightGreen,
                200,
              ),
              _buildStatCard(
                isDark,
                isMobile,
                '전문',
                'Hi-Fi 프로토타입',
                Icons.code,
                const Color(0xFFFF9800),
                300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    bool isDark,
    bool isMobile,
    String value,
    String label,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.charcoal.withValues(alpha: 0.6)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: isMobile ? 32 : 40, color: color),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: delay),
        )
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: delay),
        )
        .shimmer(
          duration: 1500.ms,
          delay: Duration(milliseconds: 800 + delay),
          color: color.withValues(alpha: 0.2),
        );
  }

  Widget _buildCoreCompetencies(bool isDark, bool isMobile, bool isTablet) {
    final competencies = [
      {
        'title': 'UX/UI 기획 및 디자인',
        'description': 'User Flow, Flow Chart, 시나리오 설계, 기능 정의',
        'icon': Icons.design_services,
        'color': AppColors.primaryBlue,
      },
      {
        'title': 'Hi-Fi Prototyping',
        'description': 'XD, Figma, ProtoPie, Flutter, 3ds Max, After Effects',
        'icon': Icons.phonelink,
        'color': AppColors.accentCyan,
      },
      {
        'title': '다양한 플랫폼 경험',
        'description': 'Web, Android, iOS, Linux 환경 설계 및 구현',
        'icon': Icons.important_devices,
        'color': AppColors.highlightGreen,
      },
      {
        'title': '디자인 그룹 관리',
        'description': 'UX/UI 디렉팅, 인력/외주/일정 관리, 신규업무 생성',
        'icon': Icons.groups,
        'color': const Color(0xFFFF9800),
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.deepSpace.withValues(alpha: 0.5),
                  AppColors.charcoal.withValues(alpha: 0.8),
                ]
              : [AppColors.lightBg, Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      isDark ? AppColors.primaryBlue : AppColors.highlightGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Core Competencies',
                style: TextStyle(
                  fontSize: isMobile ? 36 : (isTablet ? 48 : 56),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 2),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isMobile ? 1.8 : (isTablet ? 1.5 : 1.8),
            ),
            itemCount: competencies.length,
            itemBuilder: (context, index) {
              final comp = competencies[index];
              return Container(
                    padding: EdgeInsets.all(isMobile ? 24 : 32),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.charcoal.withValues(alpha: 0.6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (comp['color'] as Color).withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (comp['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (comp['color'] as Color).withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            comp['icon'] as IconData,
                            size: isMobile ? 32 : 40,
                            color: comp['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          comp['title'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.gray100
                                : AppColors.lightGray900,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          comp['description'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 15,
                            color: isDark
                                ? AppColors.gray400
                                : AppColors.lightGray600,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(
                    duration: 600.ms,
                    delay: Duration(milliseconds: index * 100),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    delay: Duration(milliseconds: index * 100),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTimeline(bool isDark, bool isMobile, bool isTablet) {
    final experiences = [
      {
        'company': 'Independent Projects (Personal)',
        'position': '1인 풀스택 개발',
        'period': '2026.01 - 현재',
        'projects': [
          'ChatGPT Codex, Gemini Antigravity, Anthropic Claude 등 최신 LLM 에이전트와의 페어 프로그래밍을 통한 초고속 1인 풀스택 개발 프로세스 구축',
          'Flutter 및 Unity3D를 연동하여 기획부터 UI/UX 디자인, 클라이언트/서버 개발, 앱스토어 심사 통과까지 개발 라이프사이클 전 과정 주도',
          'AI 에이전트를 연동한 글로벌 다국어 SEO/ASO(앱스토어 최적화), 마케팅 크리에이티브 및 글로벌 광고 카피라이팅/프로모션 자동화 파이프라인 수립',
        ],
        'achievements': [
          '전통적 개발 프로세스 대비 리드타임 70% 단축 및 글로벌 22개국 다국어 로컬라이징 앱 6종 단독 출시 완료',
          '구글 애드몹(AdMob) 및 인앱 결제(IAP) 연동을 통한 비즈니스 모델(BM) 구축 및 글로벌 수익화 달성',
        ],
        'color': const Color(0xFFE91E63),
      },
      {
        'company': '(주)코드브릿지엑스',
        'position': '개발팀 / 연구원(팀원)',
        'period': '2025.09 - 2026.01',
        'projects': [
          '실시간 댓글 피드와 커뮤니케이션 기능을 내장한 온라인 기획서 플랫폼을 구축하여 기획-개발 간 소통 공정 일원화',
          'Figma 기반 High-Fidelity 반응형 프로토타입 설계를 도입하여 개발자 코드 커스터마이징 생산성 극대화',
          '디자인 토큰과 디자인 시스템 에셋을 모니터링하고 일관되게 제어하는 디자인 시스템 관리자 화면(Admin UI) 기획 및 개발',
          '프로세스 데이터 신뢰성 확보를 위한 단위/통합 테스트 기획 버전 검증 툴을 설계 및 개발하여 예외 리스크 사전 예방',
          '브랜드 아이덴티티 수립을 위한 CI/BI 리뉴얼 작업 및 서식류(명함 등) 비주얼 가이드라인 디자인',
        ],
        'achievements': [
          '디자인-개발 공정 정합성 보장을 위한 Git 기반 형상 관리 및 버전 제어 프로세스 도입',
          'MES/ERP 시스템 디자인 개발 완성률 100% 및 마일스톤 일정 준수율 100% 달성',
        ],
        'color': const Color(0xFF9C27B0),
      },
      {
        'company': '아이엔지피플',
        'position': 'UX팀 / 매니저',
        'period': '2025.01 - 2025.06',
        'projects': [
          'AIA생명 앱: 고령자 모드 UX/UI 개발',
          '한국마사회 비즈온 앱 UX/UI 시안 개발',
          '토지개발 분석 솔루션 반응형 웹 UX/UI 개발',
        ],
        'achievements': [
          '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100%',
          'AIA 생명 Phase2 고령자 모드 메인 UX 기획 및 디자인 시스템 구축',
        ],
        'color': AppColors.primaryBlue,
      },
      {
        'company': '현대에이치티',
        'position': 'GUX디자인팀 / 수석연구원',
        'period': '2018.05 - 2024.03',
        'projects': [
          'HT HOME 2.0 앱 UX/UI 개발 (2021.07 - 2023.04)',
          'HT 범용 24인치 안드로이드 월패드 UX/UI 개발',
          '포스코/현대/한양/한화건설 전용 월패드 UX/UI 개발',
          'PSQC(포스코 더샵 퀄리티 컨트롤) 웹사이트 UX/UI 개발',
        ],
        'achievements': [
          '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100%, 매출 성과 기여',
          '동종 업계 1위 유지 기반 HT 안드로이드 월패드 라인업 UX 설계 프로세스 체계화',
          'HT 범용 월패드 전용 디자인 시스템 구축 및 전 제품군 적용',
        ],
        'color': AppColors.accentCyan,
      },
      {
        'company': '블루스톤소프트',
        'position': '아트실 GUI파트 / 책임연구원',
        'period': '2016.05 - 2017.06',
        'projects': ['SOULARK 모바일 게임 UX/UI 개발'],
        'achievements': [
          '마일스톤 3/4/5단계 주요 목표 전 항목 100% 달성',
          '개발 프로세스 효율성 20% 향상',
        ],
        'color': AppColors.highlightGreen,
      },
      {
        'company': 'NEXON 코리아',
        'position': 'pitbull팀 / 과장',
        'period': '2010.10 - 2015.12',
        'projects': [
          '영웅시대30 MMORPG PC 게임 리뉴얼 UX/UI 개발',
          '클로저스 CBT 반응형 웹사이트 UX/UI 개발',
          '피파온라인3 웹사이트/모바일 앱 UX/UI 개발',
          '넥슨 다수 게임 웹사이트 UX/UI 디자인 운영',
        ],
        'achievements': [
          '사내 최초 클로저스 CBT에 PC/태블릿/모바일 대상 반응형 웹 구현 적용',
          '영웅시대30 인게임 GUI 리뉴얼 및 성공적 론칭',
        ],
        'color': const Color(0xFFFF9800),
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      isDark ? AppColors.primaryBlue : AppColors.highlightGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Experience',
                style: TextStyle(
                  fontSize: isMobile ? 36 : (isTablet ? 48 : 56),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          ...experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 32 : 40),
              child: _buildExperienceItem(
                isDark,
                isMobile,
                company: exp['company'] as String,
                position: exp['position'] as String,
                period: exp['period'] as String,
                projects: exp['projects'] as List<String>,
                achievements: exp['achievements'] as List<String>,
                color: exp['color'] as Color,
                index: index,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
    bool isDark,
    bool isMobile, {
    required String company,
    required String position,
    required String period,
    required List<String> projects,
    required List<String> achievements,
    required Color color,
    required int index,
  }) {
    return Container(
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.blue900.withValues(alpha: 0.15)
                : AppColors.lightGray100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 28,
                            fontWeight: FontWeight.w900,
                            color: color,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          position,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.gray200
                                : AppColors.lightGray800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '주요 프로젝트',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                ),
              ),
              const SizedBox(height: 12),
              ...projects.map(
                (project) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          project,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.gray300
                                : AppColors.lightGray700,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '주요 성과',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                ),
              ),
              const SizedBox(height: 12),
              ...achievements.map(
                (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, size: 18, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          achievement,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.gray200
                                : AppColors.lightGray800,
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
        )
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: index * 150),
        )
        .slideX(
          begin: -0.1,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: index * 150),
        );
  }

  Widget _buildSkillsSection(bool isDark, bool isMobile, bool isTablet) {
    final skillCategories = [
      {
        'category': 'Design Tools',
        'skills': [
          'Figma',
          'Adobe XD',
          'Photoshop',
          'Illustrator',
          'After Effects',
          'ProtoPie',
        ],
        'color': AppColors.primaryBlue,
      },
      {
        'category': 'Prototyping & Development',
        'skills': [
          'Flutter',
          'HTML/CSS/JS',
          '3ds Max',
          'Unity3D',
          'Flash AS 2.0/3.0',
        ],
        'color': AppColors.accentCyan,
      },
      {
        'category': 'Platforms',
        'skills': ['Android', 'iOS', 'Web (Responsive)', 'Linux (Custom ROM)'],
        'color': AppColors.highlightGreen,
      },
      {
        'category': 'Collaboration Tools',
        'skills': [
          'Jira',
          'Confluence',
          'Slack',
          'Zeplin',
          'MS Office (Expert)',
        ],
        'color': const Color(0xFFFF9800),
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.deepSpace.withValues(alpha: 0.5),
                  AppColors.charcoal.withValues(alpha: 0.8),
                ]
              : [AppColors.lightBg, Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      isDark ? AppColors.primaryBlue : AppColors.highlightGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Skills & Tools',
                style: TextStyle(
                  fontSize: isMobile ? 36 : (isTablet ? 48 : 56),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          ...skillCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 32 : 40),
              child: _buildSkillCategory(
                isDark,
                isMobile,
                category['category'] as String,
                category['skills'] as List<String>,
                category['color'] as Color,
                index,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(
    bool isDark,
    bool isMobile,
    String category,
    List<String> skills,
    Color color,
    int categoryIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(
              category,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 12 : 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.charcoal.withValues(alpha: 0.6)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.gray100
                          : AppColors.lightGray900,
                    ),
                  ),
                )
                .animate()
                .fadeIn(
                  duration: 500.ms,
                  delay: Duration(
                    milliseconds: categoryIndex * 200 + index * 50,
                  ),
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 500.ms,
                  delay: Duration(
                    milliseconds: categoryIndex * 200 + index * 50,
                  ),
                );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSection(bool isDark, bool isMobile, bool isTablet) {
    final education = [
      {
        'title': '학점은행제 시각디자인학과 졸업',
        'subtitle': '학점: 4.25/4.5',
        'period': '2006.08 - 2008.02',
        'icon': Icons.school,
      },
      {
        'title': '청강문화산업대학교 애니메이션과 (3D)',
        'subtitle': '학점: 3.34/4.2',
        'period': '1999.03 - 2004.02',
        'icon': Icons.school,
      },
    ];

    final certifications = [
      {
        'title': '시각디자인산업기사',
        'subtitle': '한국산업인력공단',
        'period': '2006.05',
        'icon': Icons.verified,
      },
      {
        'title': '유통관리사 2급',
        'subtitle': '대한상공회의소',
        'period': '2006.11',
        'icon': Icons.verified,
      },
      {
        'title': '워드프로세서 1급',
        'subtitle': '대한상공회의소',
        'period': '2006.02',
        'icon': Icons.verified,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                      isDark ? AppColors.primaryBlue : AppColors.highlightGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Education & Certifications',
                style: TextStyle(
                  fontSize: isMobile ? 32 : (isTablet ? 44 : 56),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            '학력',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          ...education.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildEducationItem(
                isDark,
                isMobile,
                title: edu['title'] as String,
                subtitle: edu['subtitle'] as String,
                period: edu['period'] as String,
                icon: edu['icon'] as IconData,
                color: AppColors.primaryBlue,
                index: index,
              ),
            );
          }),
          const SizedBox(height: 40),
          Text(
            '자격증',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          ...certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final cert = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildEducationItem(
                isDark,
                isMobile,
                title: cert['title'] as String,
                subtitle: cert['subtitle'] as String,
                period: cert['period'] as String,
                icon: cert['icon'] as IconData,
                color: AppColors.accentCyan,
                index: index + education.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEducationItem(
    bool isDark,
    bool isMobile, {
    required String title,
    required String subtitle,
    required String period,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return Container(
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.blue900.withValues(alpha: 0.15)
                : AppColors.lightGray100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 17,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.lightGray600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: 500.ms,
          delay: Duration(milliseconds: index * 100),
        )
        .slideX(
          begin: -0.1,
          end: 0,
          duration: 500.ms,
          delay: Duration(milliseconds: index * 100),
        );
  }

  Widget _buildContactSection(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : (isTablet ? 100 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.deepSpace, AppColors.charcoal]
              : [AppColors.lightBg, Colors.white],
        ),
      ),
      child: Column(
        children: [
          Text(
                'Let\'s Connect',
                style: TextStyle(
                  fontSize: isMobile ? 40 : (isTablet ? 52 : 64),
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  letterSpacing: -2,
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.9, 0.9), duration: 800.ms),
          const SizedBox(height: 16),
          Text(
            '새로운 기회와 협업을 기다립니다',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: isDark ? AppColors.gray400 : AppColors.lightGray600,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildContactItem(
                isDark,
                isMobile,
                Icons.email,
                'coyotejw@naver.com',
                AppColors.primaryBlue,
              ),
              _buildContactItem(
                isDark,
                isMobile,
                Icons.phone,
                '010-4375-3599',
                AppColors.accentCyan,
              ),
            ],
          ),
          const SizedBox(height: 56),
          ElevatedButton.icon(
                onPressed: () {
                  // html.window.print();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF 다운로드는 준비 중입니다.')),
                  );
                },
                icon: const Icon(Icons.download, size: 24),
                label: Text(
                  'PDF 이력서 다운로드',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.primaryBlue
                      : AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 32 : 48,
                    vertical: isMobile ? 18 : 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primaryBlue.withValues(alpha: 0.4),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 600.ms)
              .shimmer(
                duration: 2000.ms,
                delay: 1400.ms,
                color: Colors.white.withValues(alpha: 0.3),
              ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    bool isDark,
    bool isMobile,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 24,
            vertical: isMobile ? 14 : 16,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.charcoal.withValues(alpha: 0.6)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 600.ms, delay: 400.ms);
  }
}

/// Custom Painter for animated background
class BackgroundPainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  BackgroundPainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Draw animated circles
    for (int i = 0; i < 3; i++) {
      final offset = math.sin((animationValue * 2 * math.pi) + (i * 0.5)) * 30;
      final opacity = 0.03 + (math.sin(animationValue * math.pi) * 0.02);

      paint.color = (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
          .withValues(alpha: opacity);

      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.3), size.height * 0.3 + offset),
        100 + (i * 50),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
