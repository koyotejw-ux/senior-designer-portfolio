import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppColors.accentCyan,
                      AppColors.highlightGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'RESUME',
                    style: GoogleFonts.outfit(
                      fontSize: isMobile ? 40 : 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
                color: AppColors.accentCyan.withValues(alpha: 0.85),
                fontWeight: FontWeight.w900, // Pretendard Black
                fontSize: 13,
                letterSpacing: 0.3,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF94A3B8), // Level 4: Body (Slate-400, 12px)
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                fontFamily: 'Pretendard',
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
                color: AppColors.accentCyan,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF94A3B8), // Level 4: Body (Slate-400, 12px)
                fontSize: 12,
                height: 1.3,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF94A3B8), // Level 4: Body (Slate-400, 12px)
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w400,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }

  Widget _buildCareerDetailItem(Career career, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isMobile ? 120 : 180,
            child: Text(
              career.period,
              style: TextStyle(
                color: AppColors.accentCyan,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${career.department} · ${career.position}',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.highlightGreen.withValues(alpha: 0.95),
        fontSize: 14,
        fontWeight: FontWeight.w900, // Pretendard Black
        letterSpacing: 0.3,
        fontFamily: 'Pretendard',
      ),
    );
  }
}
