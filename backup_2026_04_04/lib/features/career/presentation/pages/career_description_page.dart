import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';

/// 경력기술서 페이지 - 실제 포트폴리오 기반 프로젝트 상세 및 성과
class CareerDescriptionPage extends ConsumerStatefulWidget {
  const CareerDescriptionPage({super.key});

  @override
  ConsumerState<CareerDescriptionPage> createState() =>
      _CareerDescriptionPageState();
}

class _CareerDescriptionPageState extends ConsumerState<CareerDescriptionPage>
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
    final threshold = MediaQuery.of(context).size.height * 0.3;
    final showLogo = _scrollController.offset > threshold;

    if (showLogo != _showHeaderLogo) {
      setState(() {
        _showHeaderLogo = showLogo;
      });
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
          Positioned.fill(
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
          ),

          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(isDark, isMobile, isTablet),

                // AIA+ SENIOR MODE Project
                ScrollRevealWidget(
                  child: _buildAIAProject(isDark, isMobile, isTablet),
                ),

                // HT HOME 2.0 & WALLPAD Project
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 100),
                  child: _buildHTHomeProject(isDark, isMobile, isTablet),
                ),

                // SOULARK Project
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 200),
                  child: _buildSoularkProject(isDark, isMobile, isTablet),
                ),

                // CLOSERS Project
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 300),
                  child: _buildClosersProject(isDark, isMobile, isTablet),
                ),

                // Key Achievements Summary
                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 400),
                  child: _buildKeyAchievements(isDark, isMobile, isTablet),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // Header
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
                  AppColors.deepSpace,
                  AppColors.blue900,
                  AppColors.charcoal,
                ]
              : [
                  AppColors.lightBg,
                  AppColors.primaryBlue.withValues(alpha: 0.1),
                  AppColors.lightCard,
                ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 100 : 120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                          .withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Text(
                'CAREER DESCRIPTION',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.accentCyan : AppColors.primaryBlue,
                  letterSpacing: 2,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

            const SizedBox(height: 24),

            // Title
            Text(
              '경력기술서',
              style: TextStyle(
                fontSize: isMobile ? 56 : (isTablet ? 72 : 96),
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                height: 1.1,
                letterSpacing: -3,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 200.ms)
                .slideX(begin: -0.2, end: 0, duration: 800.ms, delay: 200.ms)
                .shimmer(
                  duration: 2000.ms,
                  delay: 1000.ms,
                  color: (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                      .withValues(alpha: 0.3),
                ),

            const SizedBox(height: 24),

            // Subtitle
            Text(
              '실제 프로젝트 케이스 스터디 및 성과 지표',
              style: TextStyle(
                fontSize: isMobile ? 18 : (isTablet ? 22 : 28),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                height: 1.4,
                letterSpacing: -0.5,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms),

            const SizedBox(height: 32),

            // Stats Row
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildMiniStatCard(
                  isDark,
                  isMobile,
                  '4개',
                  '주요 프로젝트',
                  Icons.folder_special,
                  AppColors.primaryBlue,
                  0,
                ),
                _buildMiniStatCard(
                  isDark,
                  isMobile,
                  '19년',
                  '경력',
                  Icons.timeline,
                  AppColors.accentCyan,
                  100,
                ),
                _buildMiniStatCard(
                  isDark,
                  isMobile,
                  '100+',
                  '출시 기능',
                  Icons.rocket_launch,
                  AppColors.highlightGreen,
                  200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(
    bool isDark,
    bool isMobile,
    String value,
    String label,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isMobile ? 20 : 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 600 + delay))
        .slideY(
            begin: 0.3, end: 0, duration: 600.ms, delay: Duration(milliseconds: 600 + delay))
        .scale(
            begin: const Offset(0.8, 0.8),
            duration: 600.ms,
            delay: Duration(milliseconds: 600 + delay));
  }

  Widget _buildAIAProject(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.charcoal,
                  AppColors.deepSpace.withValues(alpha: 0.5),
                ]
              : [
                  Colors.white,
                  AppColors.lightCard.withValues(alpha: 0.3),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryBlue.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.business,
                        color: Colors.white, size: isMobile ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(
                      '아이엔지피플 | 2025.01 - 2025.06',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'UX Manager',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Project Title
          Text(
            'AIA+ SENIOR MODE',
            style: TextStyle(
              fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              letterSpacing: -2,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.1, end: 0, duration: 600.ms),

          const SizedBox(height: 12),

          Text(
            'AIA생명 앱 고령자 전용 UX 모드',
            style: TextStyle(
              fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.accentCyan
                  : AppColors.primaryBlue.withValues(alpha: 0.8),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 40),

          // Overview
          _buildSectionTitle(isDark, isMobile, '프로젝트 개요',
              AppColors.primaryBlue, Icons.description),
          const SizedBox(height: 16),
          Text(
            'AIA생명 모바일 앱에 고령자(시니어) 전용 UX 모드를 설계하고 디자인 시스템을 구축한 프로젝트입니다. 시니어 사용자의 인지적 특성과 신체적 제약을 고려하여 가독성, 접근성, 직관성을 극대화한 사용자 경험을 제공했습니다.',
            style: TextStyle(
              fontSize: isMobile ? 15 : 17,
              height: 1.8,
              color: isDark ? AppColors.gray300 : AppColors.lightGray700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 48),

          // Key Roles
          _buildSectionTitle(isDark, isMobile, '주요 역할 및 기여',
              AppColors.accentCyan, Icons.engineering),
          const SizedBox(height: 20),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            'UX 기획 및 디자인 시스템 구축',
            '시니어 모드 전용 디자인 시스템 설계 및 컴포넌트 라이브러리 구축',
            Icons.palette,
            AppColors.primaryBlue,
            0,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '사용자 리서치 및 접근성 최적화',
            '시니어 사용자 페르소나 정의 및 접근성 가이드라인 적용 (WCAG 2.1 AA 준수)',
            Icons.accessibility_new,
            AppColors.accentCyan,
            100,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '프로젝트 일정 관리',
            '디자인 개발 완성률 100%, 프로젝트 일정 준수율 100% 달성',
            Icons.task_alt,
            AppColors.highlightGreen,
            200,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '크로스 펑셔널 협업',
            'PM, iOS/Android 개발자, QA 팀과 긴밀한 협업으로 원활한 구현',
            Icons.groups,
            const Color(0xFFFF9800),
            300,
          ),

          const SizedBox(height: 48),

          // Key Features
          _buildSectionTitle(isDark, isMobile, '핵심 기능 및 설계',
              AppColors.highlightGreen, Icons.stars),
          const SizedBox(height: 20),
          _buildFeatureGrid(isDark, isMobile, isTablet, [
            {
              'icon': Icons.text_fields,
              'title': '큰 글씨 모드',
              'description': '최소 16sp 이상 폰트 크기, 명료한 타이포그래피',
              'color': AppColors.primaryBlue,
            },
            {
              'icon': Icons.touch_app,
              'title': '터치 영역 확대',
              'description': '최소 44x44pt 터치 타겟 사이즈 보장',
              'color': AppColors.accentCyan,
            },
            {
              'icon': Icons.contrast,
              'title': '고대비 색상',
              'description': 'WCAG 2.1 AA 준수 명도 대비 4.5:1 이상',
              'color': AppColors.highlightGreen,
            },
            {
              'icon': Icons.linear_scale,
              'title': '단순화된 네비게이션',
              'description': '최대 2-depth 구조, 직관적 메뉴 설계',
              'color': const Color(0xFFFF9800),
            },
          ]),

          const SizedBox(height: 48),

          // Achievements
          _buildSectionTitle(isDark, isMobile, '성과 및 임팩트',
              const Color(0xFFFF9800), Icons.emoji_events),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildEnhancedMetricCard(
                  isDark,
                  isMobile,
                  '100%',
                  '디자인 완성률',
                  Icons.check_circle,
                  AppColors.highlightGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnhancedMetricCard(
                  isDark,
                  isMobile,
                  '100%',
                  '일정 준수율',
                  Icons.schedule,
                  AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildEnhancedMetricCard(
                  isDark,
                  isMobile,
                  'AA',
                  'WCAG 준수',
                  Icons.verified,
                  AppColors.accentCyan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Additional Context
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBlue.withValues(alpha: 0.1)
                  : AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppColors.primaryBlue,
                  size: isMobile ? 28 : 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Phase 2에서는 AI 기반 음성 인터페이스와 개인화 추천 시스템이 추가될 예정이며, 현재 메인 UX 기획 및 디자인 시스템 확장 작업 진행 중입니다.',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      height: 1.6,
                      color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHTHomeProject(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : AppColors.lightBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentCyan,
                      AppColors.accentCyan.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home_work,
                        color: Colors.white, size: isMobile ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(
                      '현대에이치티 | 2018.05 - 2024.03',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Lead Designer',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Project Title
          Text(
            'HT HOME 2.0 & WALLPAD',
            style: TextStyle(
              fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              letterSpacing: -2,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.1, end: 0, duration: 600.ms),

          const SizedBox(height: 12),

          Text(
            '스마트홈 IoT 플랫폼 & 홈네트워크 월패드 디자인',
            style: TextStyle(
              fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.accentCyan
                  : AppColors.primaryBlue.withValues(alpha: 0.8),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 40),

          // Overview
          _buildSectionTitle(isDark, isMobile, '프로젝트 개요',
              AppColors.accentCyan, Icons.description),
          const SizedBox(height: 16),
          Text(
            '현대HT의 차세대 스마트홈 플랫폼 및 월패드 시스템의 전체 UX/UI 설계를 담당했습니다. IoT 기기 제어, 에너지 관리, 보안 시스템을 통합한 올인원 플랫폼으로, 사용자 중심 디자인과 디자인 시스템 구축을 통해 일관된 사용자 경험을 제공했습니다.',
            style: TextStyle(
              fontSize: isMobile ? 15 : 17,
              height: 1.8,
              color: isDark ? AppColors.gray300 : AppColors.lightGray700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 48),

          // Key Projects
          _buildSectionTitle(isDark, isMobile, '주요 프로젝트',
              AppColors.primaryBlue, Icons.apps),
          const SizedBox(height: 20),
          _buildSubProjectCard(
            isDark,
            isMobile,
            'HT HOME 2.0 앱',
            '스마트홈 통합 제어 모바일 앱 (iOS/Android/Web)',
            [
              '150+ IoT 기기 연동 및 제어 UI',
              '실시간 에너지 모니터링 대시보드',
              '음성 제어 인터페이스 설계',
              '다크모드 및 접근성 최적화',
            ],
            AppColors.accentCyan,
            Icons.phone_iphone,
          ),
          const SizedBox(height: 16),
          _buildSubProjectCard(
            isDark,
            isMobile,
            'WALLPAD 시리즈',
            '아파트 월패드 디바이스 UI (10인치/7인치 태블릿)',
            [
              '홈네트워크 제어 시스템 UI 설계',
              '방문자 인터폰 화상 통화 인터페이스',
              '엘리베이터 호출, 택배 알림 등 편의 기능',
              '터치 최적화 및 고령자 접근성 고려',
            ],
            AppColors.primaryBlue,
            Icons.tablet_mac,
          ),

          const SizedBox(height: 48),

          // Key Roles
          _buildSectionTitle(isDark, isMobile, '주요 역할 및 성과',
              AppColors.highlightGreen, Icons.engineering),
          const SizedBox(height: 20),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '디자인 시스템 총괄',
            'Figma 기반 200+ 컴포넌트 디자인 시스템 구축 및 가이드라인 문서화',
            Icons.dashboard_customize,
            AppColors.accentCyan,
            0,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            'UX 리서치 및 최적화',
            '30+ 사용자 인터뷰 및 A/B 테스트를 통한 지속적 개선',
            Icons.analytics,
            AppColors.primaryBlue,
            100,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '프로토타이핑 및 협업',
            'Figma Prototype을 통한 인터랙션 검증 및 개발팀과 긴밀한 협업',
            Icons.psychology,
            AppColors.highlightGreen,
            200,
          ),

          const SizedBox(height: 48),

          // Achievements
          _buildSectionTitle(isDark, isMobile, '성과 및 임팩트',
              const Color(0xFFFF9800), Icons.emoji_events),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '50만+',
                '누적 사용자',
                Icons.people,
                AppColors.primaryBlue,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '150+',
                'IoT 기기 연동',
                Icons.devices,
                AppColors.accentCyan,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '200+',
                '디자인 컴포넌트',
                Icons.extension,
                AppColors.highlightGreen,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '30+',
                '사용자 테스트',
                Icons.science,
                const Color(0xFFFF9800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoularkProject(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.charcoal,
                  AppColors.blue900.withValues(alpha: 0.5),
                ]
              : [
                  Colors.white,
                  AppColors.primaryBlue.withValues(alpha: 0.05),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.highlightGreen,
                      AppColors.highlightGreen.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.highlightGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.games,
                        color: Colors.white, size: isMobile ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(
                      'NEXON 코리아 | 2010.10 - 2015.12',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.highlightGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.highlightGreen.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Senior UI Designer',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.highlightGreen,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Project Title
          Text(
            'SOULARK',
            style: TextStyle(
              fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              letterSpacing: -2,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.1, end: 0, duration: 600.ms),

          const SizedBox(height: 12),

          Text(
            'MMORPG 게임 UI/UX 디자인 총괄',
            style: TextStyle(
              fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.highlightGreen
                  : AppColors.highlightGreen.withValues(alpha: 0.9),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 40),

          // Overview
          _buildSectionTitle(isDark, isMobile, '프로젝트 개요',
              AppColors.highlightGreen, Icons.description),
          const SizedBox(height: 16),
          Text(
            'NEXON의 글로벌 MMORPG 게임 SOULARK의 전체 UI/UX 디자인을 담당했습니다. 복잡한 게임 메커니즘을 직관적인 인터페이스로 구현하고, 몰입감 있는 사용자 경험을 제공하기 위한 게임 UI 디자인 시스템을 구축했습니다.',
            style: TextStyle(
              fontSize: isMobile ? 15 : 17,
              height: 1.8,
              color: isDark ? AppColors.gray300 : AppColors.lightGray700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 48),

          // Key Roles
          _buildSectionTitle(isDark, isMobile, '주요 역할 및 기여',
              AppColors.accentCyan, Icons.engineering),
          const SizedBox(height: 20),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '게임 UI 총괄 설계',
            '150+ 게임 화면 및 인터랙션 디자인, HUD/메뉴/인벤토리 시스템 설계',
            Icons.videogame_asset,
            AppColors.highlightGreen,
            0,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '디자인 시스템 구축',
            'Unity UI 기반 컴포넌트 라이브러리 및 아트 가이드라인 수립',
            Icons.layers,
            AppColors.accentCyan,
            100,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            'UX 최적화 및 테스트',
            '플레이어 행동 분석 및 A/B 테스트를 통한 지속적 개선',
            Icons.timeline,
            AppColors.primaryBlue,
            200,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '글로벌 현지화',
            '5개 언어 UI 현지화 및 문화권별 UX 최적화',
            Icons.language,
            const Color(0xFFFF9800),
            300,
          ),

          const SizedBox(height: 48),

          // Key Features
          _buildSectionTitle(isDark, isMobile, '핵심 디자인 요소',
              AppColors.primaryBlue, Icons.stars),
          const SizedBox(height: 20),
          _buildFeatureGrid(isDark, isMobile, isTablet, [
            {
              'icon': Icons.speed,
              'title': '직관적 HUD',
              'description': '실시간 전투 정보를 시각화한 미니멀 HUD 설계',
              'color': AppColors.highlightGreen,
            },
            {
              'icon': Icons.grid_view,
              'title': '체계적 인벤토리',
              'description': '드래그앤드롭 기반 인벤토리 및 장비 관리 시스템',
              'color': AppColors.accentCyan,
            },
            {
              'icon': Icons.people_alt,
              'title': '소셜 인터랙션',
              'description': '파티/길드 시스템, 채팅, 친구 관리 UI',
              'color': AppColors.primaryBlue,
            },
            {
              'icon': Icons.emoji_events,
              'title': '퀘스트 시스템',
              'description': '스토리 진행 및 목표 추적 UI/UX 설계',
              'color': const Color(0xFFFF9800),
            },
          ]),

          const SizedBox(height: 48),

          // Achievements
          _buildSectionTitle(isDark, isMobile, '성과 및 임팩트',
              const Color(0xFFFF9800), Icons.emoji_events),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '100만+',
                '글로벌 유저',
                Icons.public,
                AppColors.primaryBlue,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '150+',
                'UI 화면 설계',
                Icons.web,
                AppColors.highlightGreen,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '5개',
                '언어 현지화',
                Icons.translate,
                AppColors.accentCyan,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClosersProject(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : AppColors.lightBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF9800),
                      const Color(0xFFFF9800).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sports_esports,
                        color: Colors.white, size: isMobile ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(
                      'NEXON 코리아 | 2010.10 - 2015.12',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'UI Designer',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Project Title
          Text(
            'CLOSERS',
            style: TextStyle(
              fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              letterSpacing: -2,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.1, end: 0, duration: 600.ms),

          const SizedBox(height: 12),

          Text(
            '액션 RPG 게임 UI/UX 디자인',
            style: TextStyle(
              fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? const Color(0xFFFF9800)
                  : const Color(0xFFFF9800).withValues(alpha: 0.9),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 40),

          // Overview
          _buildSectionTitle(isDark, isMobile, '프로젝트 개요',
              const Color(0xFFFF9800), Icons.description),
          const SizedBox(height: 16),
          Text(
            'NEXON의 액션 RPG 게임 CLOSERS의 UI/UX 디자인을 담당했습니다. 빠른 액션 전투에 최적화된 인터페이스를 설계하고, 캐릭터 성장 시스템과 소셜 기능을 통합한 사용자 경험을 제공했습니다.',
            style: TextStyle(
              fontSize: isMobile ? 15 : 17,
              height: 1.8,
              color: isDark ? AppColors.gray300 : AppColors.lightGray700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 48),

          // Key Roles
          _buildSectionTitle(isDark, isMobile, '주요 역할 및 기여',
              AppColors.primaryBlue, Icons.engineering),
          const SizedBox(height: 20),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '전투 UI 설계',
            '실시간 액션 전투에 최적화된 스킬/HP/버프 디바프 UI 설계',
            Icons.whatshot,
            const Color(0xFFFF9800),
            0,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '캐릭터 성장 시스템 UI',
            '스킬 트리, 장비 강화, 아이템 제작 등 복합 시스템 UI 설계',
            Icons.trending_up,
            AppColors.accentCyan,
            100,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '소셜 기능 통합',
            '파티 매칭, 길드 시스템, 채팅 UI 등 커뮤니티 기능 설계',
            Icons.group,
            AppColors.highlightGreen,
            200,
          ),
          _buildEnhancedRoleItem(
            isDark,
            isMobile,
            '크로스 플랫폼 최적화',
            'PC 및 콘솔 버전 UI 최적화 및 컨트롤러 인터페이스 설계',
            Icons.devices,
            AppColors.primaryBlue,
            300,
          ),

          const SizedBox(height: 48),

          // Achievements
          _buildSectionTitle(isDark, isMobile, '성과 및 임팩트',
              AppColors.accentCyan, Icons.emoji_events),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '200만+',
                '글로벌 유저',
                Icons.people,
                AppColors.primaryBlue,
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '120+',
                'UI 화면',
                Icons.dashboard,
                const Color(0xFFFF9800),
              ),
              _buildEnhancedMetricCard(
                isDark,
                isMobile,
                '3개',
                '플랫폼 지원',
                Icons.computer,
                AppColors.accentCyan,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyAchievements(bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.charcoal,
                  AppColors.deepSpace.withValues(alpha: 0.8),
                ]
              : [
                  Colors.white,
                  AppColors.lightCard.withValues(alpha: 0.5),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '전체 경력 핵심 성과',
            style: TextStyle(
              fontSize: isMobile ? 40 : (isTablet ? 52 : 72),
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.gray100 : AppColors.lightGray900,
              letterSpacing: -2,
              height: 1.1,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideX(begin: -0.1, end: 0, duration: 800.ms),

          const SizedBox(height: 48),

          _buildEnhancedAchievementItem(
            isDark,
            isMobile,
            icon: Icons.people,
            title: '350만+ 누적 사용자',
            description:
                '설계하고 출시한 모든 제품들의 총 누적 사용자 수 (스마트홈 앱, MMORPG, 액션 RPG 등)',
            color: AppColors.primaryBlue,
            delay: 0,
          ),

          const SizedBox(height: 24),

          _buildEnhancedAchievementItem(
            isDark,
            isMobile,
            icon: Icons.engineering,
            title: '4개 주요 프로젝트 총괄',
            description:
                'AIA+ SENIOR MODE, HT HOME 2.0, SOULARK, CLOSERS 등 프로젝트에서 UX/UI 디자인 총괄',
            color: AppColors.accentCyan,
            delay: 100,
          ),

          const SizedBox(height: 24),

          _buildEnhancedAchievementItem(
            isDark,
            isMobile,
            icon: Icons.language,
            title: '글로벌 5개 언어 현지화',
            description: '다국어 UI 현지화 및 문화권별 UX 최적화 경험 (한/영/중/일/독)',
            color: AppColors.highlightGreen,
            delay: 200,
          ),

          const SizedBox(height: 24),

          _buildEnhancedAchievementItem(
            isDark,
            isMobile,
            icon: Icons.extension,
            title: '디자인 시스템 구축 전문가',
            description:
                'Figma/Unity UI 기반 200+ 컴포넌트 디자인 시스템 구축 및 가이드라인 문서화',
            color: const Color(0xFFFF9800),
            delay: 300,
          ),

          const SizedBox(height: 24),

          _buildEnhancedAchievementItem(
            isDark,
            isMobile,
            icon: Icons.accessibility_new,
            title: '접근성 전문성',
            description: 'WCAG 2.1 AA 준수 경험, 시니어 모드 UX 설계 등 포용적 디자인 역량',
            color: AppColors.accentCyan,
            delay: 400,
          ),
        ],
      ),
    );
  }

  // Helper Widgets

  Widget _buildSectionTitle(
    bool isDark,
    bool isMobile,
    String title,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: isMobile ? 20 : 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedRoleItem(
    bool isDark,
    bool isMobile,
    String title,
    String description,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.08)
            : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
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
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 15,
                    color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay))
        .slideX(
            begin: -0.1, end: 0, duration: 600.ms, delay: Duration(milliseconds: delay));
  }

  Widget _buildFeatureGrid(
    bool isDark,
    bool isMobile,
    bool isTablet,
    List<Map<String, dynamic>> features,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 2),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 3 : 2.5,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: isDark
                ? (feature['color'] as Color).withValues(alpha: 0.08)
                : (feature['color'] as Color).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (feature['color'] as Color).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                feature['icon'] as IconData,
                color: feature['color'] as Color,
                size: isMobile ? 28 : 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.gray100
                            : AppColors.lightGray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.lightGray600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(
                duration: 600.ms, delay: Duration(milliseconds: index * 100))
            .scale(
                begin: const Offset(0.9, 0.9),
                duration: 600.ms,
                delay: Duration(milliseconds: index * 100));
      },
    );
  }

  Widget _buildEnhancedMetricCard(
    bool isDark,
    bool isMobile,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.1),
            color.withValues(alpha: isDark ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isMobile ? 28 : 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.gray400 : AppColors.lightGray600,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 600.ms);
  }

  Widget _buildSubProjectCard(
    bool isDark,
    bool isMobile,
    String title,
    String subtitle,
    List<String> features,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.08)
            : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: isMobile ? 24 : 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: isDark
                            ? AppColors.gray400
                            : AppColors.lightGray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          height: 1.5,
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.lightGray700,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, duration: 600.ms);
  }

  Widget _buildEnhancedAchievementItem(
    bool isDark,
    bool isMobile, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.12 : 0.08),
            color.withValues(alpha: isDark ? 0.06 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isMobile ? 32 : 40,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 15,
                    height: 1.6,
                    color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: Duration(milliseconds: delay))
        .slideX(begin: -0.1, end: 0, duration: 800.ms, delay: Duration(milliseconds: delay))
        .scale(
            begin: const Offset(0.95, 0.95),
            duration: 800.ms,
            delay: Duration(milliseconds: delay));
  }
}

// Custom Painter for Animated Background
class BackgroundPainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  BackgroundPainter({
    required this.isDark,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Draw floating circles
    for (int i = 0; i < 3; i++) {
      final offset =
          math.sin((animationValue * 2 * math.pi) + (i * 0.5)) * 30;
      final opacity = 0.03 + (math.sin(animationValue * math.pi) * 0.02);

      paint.color = (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
          .withValues(alpha: opacity);

      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.3), size.height * 0.3 + offset),
        100 + (i * 50),
        paint,
      );
    }

    // Draw connecting lines
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
        .withValues(alpha: 0.02);

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    for (int i = 0; i <= 10; i++) {
      final x = size.width * (i / 10);
      final y = size.height * 0.5 +
          math.sin((animationValue * 2 * math.pi) + (i * 0.3)) * 20;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDark != isDark;
  }
}
