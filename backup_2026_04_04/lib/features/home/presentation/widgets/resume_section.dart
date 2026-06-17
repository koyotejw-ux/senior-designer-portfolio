import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/resume_model.dart';
import '../../data/providers/resume_provider.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ResumeSection extends ConsumerWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;

    final resume = ref.watch(resumeProvider);

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
              title: '인적사항',
              accentColor: AppColors.highlightGreen,
              child: _buildPersonalInfoGrid(isMobile, resume.personalInfo),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Education
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: '학력',
              accentColor: AppColors.accentCyan,
              child: Column(
                children: resume.education
                    .map(
                      (edu) => _buildRowItem(
                        edu.period,
                        '${edu.institution} ${edu.major} ${edu.gpa}',
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Career Summary
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: '경력사항',
              accentColor: AppColors.primaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resume.careers
                    .map((career) => _buildCareerDetailItem(career, isMobile))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 4. Core Competencies
          ScrollRevealWidget(
            index: 4,
            child: HolographicCard(
              title: '핵심역량',
              accentColor: AppColors.highlightGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resume.coreCompetencies
                    .map((comp) => _buildBulletPoint(comp))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 5. Certifications
          ScrollRevealWidget(
            index: 5,
            child: HolographicCard(
              title: '자격사항',
              accentColor: AppColors.accentCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resume.certifications
                    .map(
                      (cert) =>
                          _buildBulletPoint('${cert.name} / ${cert.issuer}, ${cert.date}'),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoGrid(bool isMobile, personalInfo) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('성명', personalInfo.name),
              _buildInfoRow('생년월일', personalInfo.birthDate),
              _buildInfoRow('주소', personalInfo.address),
              _buildInfoRow('병역', personalInfo.militaryService),
              _buildInfoRow('휴대번호', personalInfo.phone),
              _buildInfoRow('이메일', personalInfo.email),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('성명', personalInfo.name),
                    _buildInfoRow('생년월일', personalInfo.birthDate),
                    _buildInfoRow('주소', personalInfo.address),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('병역', personalInfo.militaryService),
                    _buildInfoRow('휴대번호', personalInfo.phone),
                    _buildInfoRow('이메일', personalInfo.email),
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

  Widget _buildCareerDetailItem(Career career, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1d29).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: 회사명 및 기간
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      career.company,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.highlightGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${career.department} · ${career.position}',
                      style: const TextStyle(
                        color: Color(0xFF8B95A1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  career.period,
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 역할
          _buildSectionTitle('담당 업무'),
          const SizedBox(height: 8),
          Text(
            career.role,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // 주요 프로젝트
          if (career.projects.isNotEmpty) ...[
            _buildSectionTitle('주요 프로젝트'),
            const SizedBox(height: 12),
            ...career.projects.map((project) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          project,
                          style: const TextStyle(
                            color: Color(0xFFe0e4e8),
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
          ],

          // 주요 성과
          if (career.achievements.isNotEmpty) ...[
            _buildSectionTitle('주요 성과'),
            const SizedBox(height: 12),
            ...career.achievements.map((achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.highlightGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          achievement,
                          style: const TextStyle(
                            color: Color(0xFFe0e4e8),
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
          ],

          // 사용 도구
          if (career.tools.isNotEmpty) ...[
            _buildSectionTitle('사용 도구'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: career.tools.map((tool) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2d3a),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    tool,
                    style: TextStyle(
                      color: AppColors.accentCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // 개발 환경
          if (career.environment != null && career.environment!.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  '개발환경',
                  style: TextStyle(
                    color: const Color(0xFF8B95A1),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    career.environment!,
                    style: const TextStyle(
                      color: Color(0xFFe0e4e8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // 퇴사 사유
          if (career.resignationReason != null &&
              career.resignationReason!.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  '퇴사사유',
                  style: TextStyle(
                    color: const Color(0xFF8B95A1),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  career.resignationReason!,
                  style: const TextStyle(
                    color: Color(0xFFe0e4e8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.accentCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
