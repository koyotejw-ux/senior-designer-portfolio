import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

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
                  'EXPERIENCE',
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

          // 1. ING People
          ScrollRevealWidget(
            index: 1,
            child: HolographicCard(
              title: 'ING PEOPLE',
              accentColor: AppColors.primaryBlue,
              child: _buildExperienceContent(
                company: '아이엔지피플 / UX팀 / 부장',
                period: '2025.01 ~ 2025.06',
                content: [
                  _buildSubSection('RESPONSIBILITIES', [
                    'AIA생명 앱 : 시니어모드 UX/UI 구축 | Product Designer : 2025.02-2025.06',
                    '마사회(KRA) 비즈온 앱 UX/UI 시안 | Product Designer : 2025.02 - 2025.02',
                    '토지개발분석 솔루션 반응형 웹 UX/UI | Product Designer : 2025.01 - 2025.02',
                  ]),
                  _buildSubSection('ACHIEVEMENTS', [
                    '디자인 완료율 100%, 일정 준수율 100%',
                    'AIA생명 2차 고도화 시니어모드 메인 UX 기획 및 디자인 시스템 구축',
                    '보험금 납입, 대출상환, 자동부활, 자동이체 등 핵심 GUI 정의',
                    '토지분석 플랫폼 UX/UI 기획 및 디자인 방향성 수립',
                  ]),
                  _buildSubSection('TOOLS', ['FIGMA, MS Office']),
                  _buildSubSection('REASON FOR LEAVING', ['휴식 (교통사고)']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Hyundai HT
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: 'HYUNDAI HT',
              accentColor: AppColors.highlightGreen,
              child: _buildExperienceContent(
                company: '현대에이치티 / GUX디자인팀 / 수석연구원',
                period: '2018.05 ~ 2024.02',
                content: [
                  _buildSubSection('RESPONSIBILITIES', [
                    'HT 일반형 24인치 안드로이드 월패드 UX/UI | Product Lead : 2023.07 - 2023.12',
                    '포스코건설 10.1/13.3인치 안드로이드 월패드 UX/UI | Product Lead : 2022.11 - 2023.10',
                    '현대건설 13.3인치 안드로이드 월패드 UX/UI | Product Lead : 2021.12 - 2023.06',
                    '현대엔지니어링 7인치 안드로이드 미니 월패드 UX/UI | Product Lead : 2022.03-2023.08',
                    '포스코건설 PSQC 시운전 솔루션 웹 UX/UI | Product Lead : 2021.10 - 2023.10',
                    '금호건설 안드로이드 월패드 UX/UI | Product Lead : 2021.05 - 2022.12',
                    '한양건설 수자인 안드로이드 월패드 UX/UI | Product Lead : 2020.06 - 2022.08',
                    '한화건설 포레나 안드로이드 월패드 UX/UI | Product Lead : 2020.08 - 2022.08',
                    'HT 일반형 10.1인치 안면인식 안드로이드 로비폰 UX/UI | Product Lead : 2022.01 - 2022.12',
                    'DL건설 24인치 세로형 안드로이드 월패드 UX/UI | Product Lead : 2022.03 - 2022.09',
                    'HT 일반형 안드로이드 월패드 UX/UI | Product Lead : 2018.05 - 2023.12',
                    'HT 일반형 주거용 이마주 앱 UX/UI | Product Lead : 2018.07 - 2020.06',
                    'HT HOME IOT 앱 UX/UI | Product Designer, Product Lead : 2018.06 - 2020.06',
                    'HT HOME 2.0 앱 UX/UI | Product Lead : 2021.07 - 2023.04',
                    'HT/건설사 월패드 UX/UI 운영 | Product Lead : 2018.05 - 2020.05',
                    'HT 입주민 홈페이지 UX/UI | Product Lead : 2020.08 - 2022.08',
                    'HT INITIALDATA 자동화 솔루션 UX/UI | Product Lead : 2021.08 - 2022.08',
                    '운전자 안전 솔루션 메저 앱/관리자 웹 UX/UI | Product Lead : 2019.12 - 2022.06',
                    'PSQC (포스코 더샵 품질관리) 웹 UX/UI | Product Lead : 2021.08 - 2023.10',
                    '협성 마리나 G7 객실관리 웹 UX/UI | Product Lead : 2021.03 - 2021.12',
                  ]),
                  _buildSubSection('ACHIEVEMENTS', [
                    '디자인 완료율 100%, 일정 준수율 100%, 매출 기여',
                    'HT 안드로이드 월패드 라인업 UX 디자인 프로세스 체계화 (업계 1위)',
                    '건설사별 커스텀 월패드(7~24인치) 디자인 시스템 적용',
                    'HT HOME & HT 이마주 앱 앱스토어 런칭',
                    '월패드/앱과 연동되는 반응형 입주민 웹사이트(PC/Tablet/Mobile) 디자인',
                    '일반형 월패드 디자인 시스템 구축 및 전 제품군 적용',
                  ]),
                  _buildSubSection('TOOLS', [
                    'FIGMA, Adobe XD, Photoshop, Illustrator, Lottie, Aftereffect, Protopie, Zeplin, Jira, Confluence, Slack, MS Office',
                  ]),
                  _buildSubSection('ENVIRONMENT', [
                    'Android (include Custom Rom) / IOS / WEB',
                  ]),
                  _buildSubSection('REASON FOR LEAVING', ['휴식 (건강상 이유)']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Bluestone Soft
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: 'BLUESTONE SOFT',
              accentColor: AppColors.accentCyan,
              child: _buildExperienceContent(
                company: '블루스톤소프트 / 아트본부 / 책임연구원',
                period: '2016.05 ~ 2017.06',
                content: [
                  _buildSubSection('RESPONSIBILITIES', [
                    'SOULARK 모바일 게임 UX/UI | UX/UI Designer : 2016.05 - 2017.06',
                  ]),
                  _buildSubSection('ACHIEVEMENTS', [
                    '디자인 완료율 100%, 일정 준수율 100%',
                    '개발 프로세스 효율성 20% 향상',
                    '마일스톤 3/4/5 목표 100% 달성',
                  ]),
                  _buildSubSection('TOOLS', [
                    'Photoshop, Illustrator, Aftereffect, Unity3D',
                  ]),
                  _buildSubSection('ENVIRONMENT', ['Android / IOS (Unity3D)']),
                  _buildSubSection('REASON FOR LEAVING', ['개발 환경']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 4. NEXON Korea
          ScrollRevealWidget(
            index: 4,
            child: HolographicCard(
              title: 'NEXON KOREA',
              accentColor: const Color(0xFF9D00FF),
              child: _buildExperienceContent(
                company: '넥슨코리아 / 핏불팀 / 과장',
                period: '2010.10 ~ 2015.12',
                content: [
                  _buildSubSection('RESPONSIBILITIES', [
                    'PROJECT B 곤충대전 모바일 게임 UX/UI | UX/UI Designer : 2015.10 - 2015.12',
                    'PROJECT V MMORPG 모바일 게임 UX/UI | UX/UI Designer : 2015.07 - 2015.09',
                    'OX? OX! 퀴즈퀴즈 모바일 게임 UX/UI | UX/UI Designer : 2015.03 - 2015.06',
                    '클로저스 웹사이트 UX/UI 운영 | UX/UI Designer : 2014.06 - 2014.09',
                    '클로저스 CBT 반응형 웹사이트 UX/UI | UX/UI Designer : 2014.06 - 2014.09',
                    '넥슨 아레나 앱 UX/UI | UX/UI Designer : 2014.04 - 2014.05',
                    '엘소드 웹사이트 UX/UI 운영 | UX/UI Designer : 2014.05 - 2014.06',
                    '크레이지 아케이드 & 비엔비 UX/UI 운영 | UX/UI Designer : 2013.05 - 2014.04',
                    '카트라이더 UX/UI 운영 | UX/UI Designer : 2013.05 - 2014.04',
                    '피파 온라인 3 OBT 웹사이트 UX/UI | UX/UI Designer : 2012.11 - 2013.01',
                    '피파 온라인 3 모바일 앱 UX/UI | UX/UI Designer : 2013.01 - 2013.02',
                    '히어로 시대 30 CBT/OBT 웹사이트 UX/UI | UX/UI Designer : 2011.09 - 2012.02',
                    '히어로 시대 30 MMORPG PC 게임 리뉴얼 UX/UI | UX/UI Designer : 2010.10 - 2012.05',
                  ]),
                  _buildSubSection('ACHIEVEMENTS', [
                    '디자인 완료율 100%, 일정 준수율 100%',
                    '게임/프로모션 디자인을 통한 유저 유입 및 매출 기여',
                    '사내 최초 클로저스 CBT 사이트 반응형 웹 구현',
                    '히어로 시대 30 인게임 GUI 리뉴얼 및 런칭 성공',
                  ]),
                  _buildSubSection('TOOLS', [
                    'Photoshop, Illustrator, Aftereffect, Unity3D, Flash AS 3.0',
                  ]),
                  _buildSubSection('ENVIRONMENT', [
                    'Android / IOS (Unity3D) / WEB',
                  ]),
                  _buildSubSection('REASON FOR LEAVING', ['팀 해체']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceContent({
    required String company,
    required String period,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          company,
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            height: 1.2,
            fontFamily: 'Courier',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          period,
          style: TextStyle(
            color: AppColors.highlightGreen, // Green Accent
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
        Column(children: content),
      ],
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF8B95A1), // Muted label
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.5,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '· ',
                    style: TextStyle(
                      color: AppColors.highlightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white, // White text
                        height: 1.6,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
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
}
