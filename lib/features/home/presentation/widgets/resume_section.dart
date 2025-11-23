import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ResumeSection extends ConsumerWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : size.width * 0.1,
        vertical: 40,
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
                  'RESUME',
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

          // 1. Personal Info
          ScrollRevealWidget(
            index: 1,
            child: HolographicCard(
              title: 'PERSONAL INFO',
              accentColor: AppColors.primaryBlue,
              child: _buildPersonalInfoGrid(isMobile),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Education
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: 'EDUCATION',
              accentColor: AppColors.highlightGreen,
              child: Column(
                children: [
                  _buildRowItem(
                    '2006.08 ~ 2008.02',
                    '시각디자인학 학사 (학점은행제) (4.25/4.5)',
                  ),
                  _buildRowItem(
                    '1999.03 ~ 2004.02',
                    '청강문화산업대학 애니메이션과 / 3D전공 (3.34/4.2)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Career Summary
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: 'CAREER SUMMARY',
              accentColor: AppColors.accentCyan,
              child: Column(
                children: [
                  _buildRowItem(
                    '2025.01 ~ 2025.06',
                    '아이엔지피플 / UX팀 / 부장 / UX/UI 기획 및 디자인',
                  ),
                  _buildRowItem(
                    '2018.05 ~ 2024.03',
                    '현대에이치티 / GUX디자인팀 / 수석연구원 / UX/UI 기획 및 디자인',
                  ),
                  _buildRowItem(
                    '2016.05 ~ 2017.06',
                    '블루스톤소프트 / 아트본부 GUI파트 / 책임연구원 / UX/UI 디자인',
                  ),
                  _buildRowItem(
                    '2010.10 ~ 2015.12',
                    '넥슨코리아 / 핏불팀 / 과장 / UX/UI 디자인, 3D Art',
                  ),
                  _buildRowItem(
                    '2008.07 ~ 2010.10',
                    'YNK KOREA / 웹팀 / 대리 / UX/UI 디자인',
                  ),
                  _buildRowItem(
                    '2008.03 ~ 2008.07',
                    '비엠소프트 / E-Sports 사업부 / 대리 / UX/UI 디자인',
                  ),
                  _buildRowItem(
                    '2005.11 ~ 2006.12',
                    '씨앤디 / 인테리어 사업부 / 사원 / UX/UI 디자인, 3D Art',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 4. Core Competencies
          ScrollRevealWidget(
            index: 4,
            child: HolographicCard(
              title: 'CORE COMPETENCIES',
              accentColor: const Color(0xFF9D00FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint(
                    '에이전시, 게임 엔터테인먼트, 제조사 디바이스 등 다양한 UX/UI 경험 보유',
                  ),
                  _buildBulletPoint('UX/UI 기획 및 디자인 모두 수행 가능'),
                  _buildBulletPoint(
                    'Hi-Fi Prototyping 2D/3D (XD/Figma/Protopie/Flutter/3dmax/Aftereffect)',
                  ),
                  _buildBulletPoint(
                    '디자인 조직 관리 (Directing/HR/Outsourcing/Scheduling/New Biz Creation)',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 5. Qualifications
          ScrollRevealWidget(
            index: 5,
            child: HolographicCard(
              title: 'QUALIFICATIONS',
              accentColor: AppColors.primaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('시각디자인산업기사 / 한국산업인력공단, 2006.05'),
                  _buildBulletPoint('유통관리사 2급 / 대한상공회의소, 2006.11'),
                  _buildBulletPoint('워드프로세서 1급 / 대한상공회의소, 2006.02'),
                  _buildBulletPoint(
                    'MS OFFICE : Expert Level (PPT 기획서 작성, 엑셀 VB 활용)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoGrid(bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('NAME', '정재웅'),
              _buildInfoRow('BIRTH', '1979. 08. 14'),
              _buildInfoRow('ADDRESS', '경기도 고양시 덕양구 향동동'),
              _buildInfoRow('MILITARY', '육군 병장 만기 제대'),
              _buildInfoRow('PHONE', '010-4375-3599'),
              _buildInfoRow('EMAIL', 'coyotejw@naver.com'),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('NAME', '정재웅'),
                    _buildInfoRow('BIRTH', '1979. 08. 14'),
                    _buildInfoRow('ADDRESS', '경기도 고양시 덕양구 향동동'),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('MILITARY', '육군 병장 만기 제대'),
                    _buildInfoRow('PHONE', '010-4375-3599'),
                    _buildInfoRow('EMAIL', 'coyotejw@naver.com'),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF8B95A1), // Muted label
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1,
                fontFamily: 'Courier',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String date, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              date,
              style: TextStyle(
                color: AppColors.highlightGreen, // Green date
                fontSize: 14,
                fontFamily: 'Courier',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 6,
            height: 6,
            color: AppColors.accentCyan, // Square bullet
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
