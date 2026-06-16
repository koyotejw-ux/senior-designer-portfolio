import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import 'holographic_card.dart';

/// 프로젝트 스토리텔링 섹션 - 대기업용 프로세스 시각화
class ProjectStorySection extends ConsumerWidget {
  const ProjectStorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Project Journey',
            style: TextStyle(
              fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1.5,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 0.ms)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 0.ms),

          const SizedBox(height: 16),

          Text(
            '문제 발견부터 솔루션 구현까지, 데이터 기반 의사결정 프로세스',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              height: 1.6,
              color: AppColors.gray400,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms),

          SizedBox(height: isMobile ? 40 : 60),

          // Story Timeline
          _buildTimelineItem(
            context,
            isDark,
            isMobile,
            step: 1,
            title: '문제 발견 & 리서치',
            description: '사용자 불편 사항 및 비즈니스 니즈 파악',
            details: [
              '사용자 인터뷰 20+ 진행',
              'GA4 데이터 분석을 통한 행동 패턴 파악',
              '경쟁사 벤치마킹 및 시장 조사',
              '페인 포인트 우선순위화',
            ],
            icon: Icons.search,
            color: AppColors.accentCyan,
            delay: 400.ms,
          ),

          _buildTimelineConnector(isDark, isMobile),

          _buildTimelineItem(
            context,
            isDark,
            isMobile,
            step: 2,
            title: '가설 수립 & 검증',
            description: '데이터 기반 솔루션 아이디어 도출 및 검증',
            details: [
              'User Journey Map 작성',
              'A/B 테스트 설계 및 프로토타입 제작',
              'Figma 프로토타입으로 사용자 테스트 5회',
              'AI 기반 자동화 도입 검토',
            ],
            icon: Icons.science,
            color: AppColors.highlightGreen,
            delay: 600.ms,
          ),

          _buildTimelineConnector(isDark, isMobile),

          _buildTimelineItem(
            context,
            isDark,
            isMobile,
            step: 3,
            title: '디자인 & 개발',
            description: '디자인 시스템 기반 효율적 구현',
            details: [
              'Atomic Design 패턴 적용',
              'Flutter/React로 크로스 플랫폼 구현',
              'Storybook을 통한 컴포넌트 문서화',
              'CI/CD 파이프라인 구축',
            ],
            icon: Icons.palette,
            color: const Color(0xFFFF9800),
            delay: 800.ms,
          ),

          _buildTimelineConnector(isDark, isMobile),

          _buildTimelineItem(
            context,
            isDark,
            isMobile,
            step: 4,
            title: '배포 & 모니터링',
            description: '출시 후 지속적 개선 및 성과 측정',
            details: [
              '단계적 롤아웃 (10% → 50% → 100%)',
              'Firebase Analytics로 실시간 모니터링',
              'NPS 점수 15% 개선, 전환율 23% 향상',
              '사용자 피드백 기반 지속적 개선',
            ],
            icon: Icons.rocket_launch,
            color: const Color(0xFFE91E63),
            delay: 1000.ms,
            isLast: true,
          ),

          SizedBox(height: isMobile ? 40 : 60),

          // Key Takeaways
          HolographicCard(
            title: 'Key Insights',
            accentColor: AppColors.highlightGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInsightItem(
                  isDark,
                  '데이터 기반 의사결정',
                  '모든 디자인 결정은 사용자 데이터와 A/B 테스트로 검증',
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  isDark,
                  '크로스 펑셔널 협업',
                  'PM, 개발자, 데이터 분석가와 긴밀한 협업으로 20% 빠른 출시',
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  isDark,
                  'AI/ML 활용',
                  '자동화 도입으로 운영 비용 35% 절감 달성',
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1200.ms)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    bool isDark,
    bool isMobile,
    {
    required int step,
    required String title,
    required String description,
    required List<String> details,
    required IconData icon,
    required Color color,
    required Duration delay,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Number Circle
        Container(
          width: isMobile ? 48 : 60,
          height: isMobile ? 48 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: isMobile ? 24 : 28,
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Content
        Expanded(
          child: HolographicCard(
            title: 'STEP 0$step',
            accentColor: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ...details.map((detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              detail,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: delay)
        .slideX(begin: -0.1, end: 0, duration: 600.ms, delay: delay);
  }

  Widget _buildTimelineConnector(bool isDark, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 23 : 29,
        top: 12,
        bottom: 12,
      ),
      child: Container(
        width: 2,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accentCyan.withValues(alpha: 0.5),
              AppColors.accentCyan.withValues(alpha: 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightItem(bool isDark, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.highlightGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.gray400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
