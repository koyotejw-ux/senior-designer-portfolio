import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isMobile ? 24 : size.width * 0.1,
        right: isMobile ? 24 : size.width * 0.1,
        top: isMobile ? 100 : 120,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ScrollRevealWidget(
            index: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT ME',
                  style: AppTypography.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    fontSize: isMobile ? 40 : 60,
                    fontFamily: 'Courier',
                  ),
                ),
                Container(
                  width: 100,
                  height: 8,
                  margin: const EdgeInsets.only(top: 20, bottom: 60),
                  color: AppColors.accentCyan,
                ),
              ],
            ),
          ),

          // 1. Introduction
          ScrollRevealWidget(
            index: 1,
            child: HolographicCard(
              title: 'INTRODUCTION',
              accentColor: AppColors.primaryBlue,
              child: Text(
                '안녕하세요, 19년차 UX/UI 디자이너 정재웅입니다.\n\n'
                '저는 사용자 경험을 깊이 있게 고민하고, 이를 직관적이고 아름다운 디자인으로 구현하는 것을 목표로 합니다. '
                '다양한 산업 분야에서의 경험을 바탕으로 비즈니스 목표와 사용자 니즈를 조화롭게 연결하는 디자인 솔루션을 제공해 왔습니다.\n\n'
                '단순히 보기 좋은 디자인을 넘어, 사용자가 편리함과 감동을 느낄 수 있는 경험을 만들기 위해 끊임없이 연구하고 도전합니다.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Philosophy
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: 'PHILOSOPHY',
              accentColor: AppColors.highlightGreen,
              child: Text(
                '디자인은 문제 해결의 과정이라고 생각합니다. '
                '복잡한 문제를 단순하고 명쾌하게 풀어내는 것이 디자이너의 역할이며, 그 과정에서 사용자에 대한 배려가 가장 중요하다고 믿습니다.\n\n'
                '또한, 디자인은 혼자 하는 것이 아니라 팀과 함께 만들어가는 것입니다. '
                '원활한 소통과 협업을 통해 더 나은 결과물을 만들어낼 수 있다고 확신합니다.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Aspirations
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: 'ASPIRATIONS',
              accentColor: AppColors.accentCyan,
              child: Text(
                '목표를 향해 가는 길은 때로 멀고 험난할 수 있지만, 저는 그 과정을 새로운 기회이자 성장의 시간으로 여깁니다. '
                '단순히 결과만을 쫓기보다, 과정 속에서 끊임없이 배우고 발전하며 완성된 결과에 도달하는 것을 중요하게 생각합니다.\n\n'
                '채용 공고를 보며 저의 경험과 가치관이 이곳의 방향성과 잘 맞는다고 느꼈고, 함께 성장하고 싶다는 확신이 들었습니다.\n\n'
                '어떤 환경이든 처음부터 완벽할 수는 없지만, 주어진 역할을 책임감 있게 완수해 온 경험을 바탕으로, '
                '스스로 문제를 정의하고 해결하며 유연하게 움직이는 디자이너로 성장해 왔습니다.\n\n'
                '기회를 주신다면, 지금까지 쌓아온 경험과 역량을 바탕으로 팀과 함께 의미 있는 성과를 만들어내기 위해 최선을 다하겠습니다.\n\n'
                '감사합니다.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
