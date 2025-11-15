import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';

/// 자기소개서 페이지 - 실제 경력 기반 스토리텔링 및 가치관
class CoverLetterPage extends ConsumerStatefulWidget {
  const CoverLetterPage({super.key});

  @override
  ConsumerState<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends ConsumerState<CoverLetterPage>
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

                ScrollRevealWidget(
                  child: _buildIntroSection(isDark, isMobile, isTablet),
                ),

                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 100),
                  child: _buildJourneySection(isDark, isMobile, isTablet),
                ),

                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 200),
                  child: _buildStrengthsSection(isDark, isMobile, isTablet),
                ),

                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 300),
                  child: _buildPhilosophySection(isDark, isMobile, isTablet),
                ),

                ScrollRevealWidget(
                  delay: const Duration(milliseconds: 400),
                  child: _buildGoalsSection(isDark, isMobile, isTablet),
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
      height: isMobile ? 600 : 700,
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
                'COVER LETTER',
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
              '자기소개서',
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

            const SizedBox(height: 32),

            // Quote
            Container(
              padding: EdgeInsets.all(isMobile ? 24 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                        .withValues(alpha: isDark ? 0.15 : 0.1),
                    (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                        .withValues(alpha: isDark ? 0.08 : 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
                          .withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue)
                        .withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: isDark
                            ? AppColors.accentCyan
                            : AppColors.primaryBlue,
                        size: isMobile ? 32 : 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '19년간 사용자 중심 디자인을 실천해온 UX/UI 디자이너',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.accentCyan
                                : AppColors.primaryBlue,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '디자인은 단순히 아름다운 인터페이스를 만드는 것이 아닙니다. 사용자의 문제를 해결하고, 비즈니스 가치를 창출하며, 더 나은 경험을 제공하는 것입니다. 저는 데이터 기반 의사결정과 체계적인 디자인 시스템 구축을 통해 이를 실현해왔습니다.',
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 17,
                      height: 1.8,
                      color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms)
                .scale(
                    begin: const Offset(0.95, 0.95),
                    duration: 800.ms,
                    delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(bool isDark, bool isMobile, bool isTablet) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: isMobile ? 28 : 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '저는 이런 사람입니다',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : (isTablet ? 40 : 56),
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    letterSpacing: -1.5,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          _buildIntroCard(
            isDark,
            isMobile,
            '사용자 경험 전문가',
            '19년간 NEXON, 현대HT 등 대기업에서 350만+ 사용자를 대상으로 한 제품 UX/UI를 설계했습니다. 게임 UI부터 스마트홈 플랫폼까지, 다양한 도메인에서 사용자 중심 디자인을 실천해왔습니다.',
            Icons.psychology,
            AppColors.primaryBlue,
            0,
          ),

          const SizedBox(height: 24),

          _buildIntroCard(
            isDark,
            isMobile,
            '디자인 시스템 구축자',
            'Figma 기반 200+ 컴포넌트 디자인 시스템을 구축하고, Atomic Design 방법론을 적용하여 팀의 생산성을 40% 이상 향상시킨 경험이 있습니다. 체계적인 시스템으로 일관성과 확장성을 확보합니다.',
            Icons.dashboard_customize,
            AppColors.accentCyan,
            100,
          ),

          const SizedBox(height: 24),

          _buildIntroCard(
            isDark,
            isMobile,
            '데이터 기반 의사결정자',
            '30+ 사용자 테스트와 A/B 테스트를 통해 디자인을 검증하고, 데이터 분석을 통해 평균 30% 이상의 주요 지표 개선을 달성했습니다. 직관이 아닌 데이터로 설계합니다.',
            Icons.analytics,
            AppColors.highlightGreen,
            200,
          ),

          const SizedBox(height: 24),

          _buildIntroCard(
            isDark,
            isMobile,
            'Full-Stack Designer',
            'Flutter, React 등 프론트엔드 개발 역량을 갖추어, 디자인과 개발 사이의 간극을 없애고 빠르게 프로토타입을 구현하여 아이디어를 검증합니다. 코드로 소통하는 디자이너입니다.',
            Icons.code,
            const Color(0xFFFF9800),
            300,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection(bool isDark, bool isMobile, bool isTablet) {
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
          Text(
            '나의 여정',
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

          const SizedBox(height: 48),

          _buildJourneyItem(
            isDark,
            isMobile,
            '2005-2008',
            '디자인의 시작',
            '애니메이션을 전공하며 3D 디자인과 모션 그래픽을 배웠습니다. 시각디자인 학사 과정에서 4.25/4.5의 높은 학점으로 UX/UI의 기초를 다졌습니다.',
            AppColors.primaryBlue,
            Icons.school,
          ),

          _buildJourneyItem(
            isDark,
            isMobile,
            '2008-2015',
            '게임 UI 전문가로 성장',
            'YNK KOREA와 NEXON에서 10개 이상의 모바일 게임과 MMORPG UI/UX를 설계하며, 300만+ 글로벌 사용자를 대상으로 한 복잡한 시스템 디자인 역량을 키웠습니다.',
            AppColors.accentCyan,
            Icons.games,
          ),

          _buildJourneyItem(
            isDark,
            isMobile,
            '2018-2024',
            '스마트홈 UX 리더',
            '현대HT에서 HT HOME 2.0과 WALLPAD 시리즈를 총괄하며, IoT 플랫폼 디자인 시스템을 구축했습니다. 50만+ 누적 사용자, 150+ IoT 기기 연동 경험을 쌓았습니다.',
            AppColors.highlightGreen,
            Icons.home_work,
          ),

          _buildJourneyItem(
            isDark,
            isMobile,
            '2025-현재',
            '시니어 UX 매니저',
            'AIA생명 앱 고령자 모드 UX를 설계하며 접근성 전문성을 확보했습니다. WCAG 2.1 AA 준수, 100% 디자인 완성률과 일정 준수를 달성하며 프로젝트 관리 역량을 입증했습니다.',
            const Color(0xFFFF9800),
            Icons.accessibility_new,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsSection(bool isDark, bool isMobile, bool isTablet) {
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
          Text(
            '저만의 강점',
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

          const SizedBox(height: 48),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isMobile ? 1.3 : 1.1,
            children: [
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.emoji_events,
                '검증된 성과',
                '350만+ 누적 사용자\n평균 30% 지표 개선\n100% 프로젝트 완성률',
                AppColors.primaryBlue,
                0,
              ),
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.science,
                '기술 융합 역량',
                'Flutter/React 개발\nAI/ML 활용 UX 설계\n데이터 분석 기반 설계',
                AppColors.accentCyan,
                100,
              ),
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.groups,
                '협업 전문성',
                '크로스 펑셔널 협업\nPM/개발자와 소통\n디자인 시스템 공유',
                AppColors.highlightGreen,
                200,
              ),
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.language,
                '글로벌 경험',
                '5개 언어 현지화\n다문화 UX 설계\n글로벌 출시 경험',
                const Color(0xFFFF9800),
                300,
              ),
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.lightbulb,
                '체계적 사고',
                '디자인 시스템 구축\nAtomic Design 적용\n200+ 컴포넌트 관리',
                AppColors.accentCyan,
                400,
              ),
              _buildStrengthCard(
                isDark,
                isMobile,
                Icons.trending_up,
                '성장 마인드셋',
                '지속적 학습\n새 기술 빠른 습득\n피드백 기반 개선',
                AppColors.primaryBlue,
                500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhilosophySection(bool isDark, bool isMobile, bool isTablet) {
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
          Text(
            '일하는 방식',
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

          const SizedBox(height: 48),

          _buildPhilosophyCard(
            isDark,
            isMobile,
            '01',
            '사용자 중심',
            '모든 디자인 결정의 시작은 사용자입니다. 페르소나를 정의하고, 사용자 리서치를 통해 진짜 문제를 찾아냅니다.',
            AppColors.primaryBlue,
            Icons.people_alt,
          ),

          const SizedBox(height: 24),

          _buildPhilosophyCard(
            isDark,
            isMobile,
            '02',
            '데이터 기반',
            '직관이 아닌 데이터로 의사결정합니다. A/B 테스트, 사용자 분석, 지표 추적을 통해 디자인을 검증합니다.',
            AppColors.accentCyan,
            Icons.insights,
          ),

          const SizedBox(height: 24),

          _buildPhilosophyCard(
            isDark,
            isMobile,
            '03',
            '체계적 설계',
            '디자인 시스템을 구축하여 일관성을 확보하고, Atomic Design으로 재사용 가능한 컴포넌트를 만듭니다.',
            AppColors.highlightGreen,
            Icons.widgets,
          ),

          const SizedBox(height: 24),

          _buildPhilosophyCard(
            isDark,
            isMobile,
            '04',
            '지속적 개선',
            '출시가 끝이 아닙니다. 사용자 피드백을 빠르게 수집하고, 데이터를 분석하여 끊임없이 개선합니다.',
            const Color(0xFFFF9800),
            Icons.autorenew,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(bool isDark, bool isMobile, bool isTablet) {
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
            '앞으로의 목표',
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

          const SizedBox(height: 48),

          Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.1),
                  AppColors.accentCyan.withValues(alpha: isDark ? 0.15 : 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
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
                                AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: isMobile ? 28 : 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '비전',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.accentCyan
                              : AppColors.primaryBlue,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'AI와 디자인의 융합을 통해 더 지능적이고 개인화된 사용자 경험을 만들고 싶습니다.',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    height: 1.6,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '19년간 쌓아온 UX/UI 전문성과 데이터 분석, AI/ML 활용 역량을 바탕으로, 수백만 사용자에게 영향을 미치는 혁신적인 제품을 설계하고 싶습니다.',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    height: 1.8,
                    color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.2, end: 0, duration: 800.ms)
              .scale(begin: const Offset(0.95, 0.95), duration: 800.ms),

          const SizedBox(height: 32),

          Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.highlightGreen
                      .withValues(alpha: isDark ? 0.15 : 0.1),
                  AppColors.accentCyan.withValues(alpha: isDark ? 0.15 : 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.highlightGreen.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.highlightGreen,
                            AppColors.accentCyan,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.highlightGreen
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.stars,
                        color: Colors.white,
                        size: isMobile ? 28 : 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '기여',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.highlightGreen
                              : AppColors.highlightGreen.withValues(alpha: 0.9),
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Full-Stack Designer로서 디자인과 개발의 간극을 없애고, 빠른 프로토타이핑으로 조직의 혁신 속도를 가속화하겠습니다.',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    height: 1.6,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '체계적인 디자인 시스템 구축과 데이터 기반 의사결정으로, 팀의 생산성을 높이고 일관된 사용자 경험을 제공하는데 기여하겠습니다.',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    height: 1.8,
                    color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideY(
                  begin: 0.2, end: 0, duration: 800.ms, delay: 200.ms)
              .scale(
                  begin: const Offset(0.95, 0.95),
                  duration: 800.ms,
                  delay: 200.ms),

          const SizedBox(height: 48),

          // Final Message
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 20 : 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.accentCyan,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '함께 혁신적인 사용자 경험을 만들고 싶습니다',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .scale(
                    begin: const Offset(0.9, 0.9),
                    duration: 800.ms,
                    delay: 400.ms)
                .shimmer(
                  duration: 2000.ms,
                  delay: 1200.ms,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets

  Widget _buildIntroCard(
    bool isDark,
    bool isMobile,
    String title,
    String description,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
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
              size: isMobile ? 28 : 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                    color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                    letterSpacing: -0.2,
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
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: Duration(milliseconds: delay))
        .scale(
            begin: const Offset(0.95, 0.95),
            duration: 600.ms,
            delay: Duration(milliseconds: delay));
  }

  Widget _buildJourneyItem(
    bool isDark,
    bool isMobile,
    String period,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                  size: isMobile ? 24 : 28,
                ),
              ),
              Container(
                width: 2,
                height: 80,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.5),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.gray100 : AppColors.lightGray900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                    color: isDark ? AppColors.gray400 : AppColors.lightGray600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.1, end: 0, duration: 600.ms);
  }

  Widget _buildStrengthCard(
    bool isDark,
    bool isMobile,
    IconData icon,
    String title,
    String description,
    Color color,
    int delay,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.1),
            color.withValues(alpha: isDark ? 0.08 : 0.05),
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              height: 1.6,
              color: isDark ? AppColors.gray400 : AppColors.lightGray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay))
        .scale(
            begin: const Offset(0.9, 0.9),
            duration: 600.ms,
            delay: Duration(milliseconds: delay));
  }

  Widget _buildPhilosophyCard(
    bool isDark,
    bool isMobile,
    String number,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
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
              size: isMobile ? 28 : 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: isMobile ? 40 : 48,
                        fontWeight: FontWeight.w900,
                        color: color.withValues(alpha: 0.2),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                    color: isDark ? AppColors.gray300 : AppColors.lightGray700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.1, end: 0, duration: 600.ms);
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
