import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/resume_provider.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

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
                  'Experience',
                  style: AppTypography.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontSize: isMobile ? 44 : 72,
                    fontFamily: 'Courier',
                  ),
                ),
                Container(
                  width: 80,
                  height: 6,
                  margin: const EdgeInsets.only(top: 16, bottom: 60),
                  color: AppColors.accentCyan,
                ),
              ],
            ),
          ),

          // Career History
          Column(
            children: resume.careers.asMap().entries.map((entry) {
              final index = entry.key;
              final career = entry.value;

              // Cycle through accent colors
              final accentColor = [
                AppColors.primaryBlue,
                AppColors.highlightGreen,
                AppColors.accentCyan,
                const Color(0xFF9D00FF),
              ][index % 4];

              return Column(
                children: [
                  ScrollRevealWidget(
                    index: index + 1,
                    child: HolographicCard(
                      title: career.company.toUpperCase(),
                      accentColor: accentColor,
                      child: _buildExperienceContent(
                        company: '${career.company} / ${career.department}',
                        position: '${career.position} / ${career.role}',
                        period: career.period,
                        content: [
                          if (career.projects.isNotEmpty)
                            _buildSubSection(
                              '직무내용 (PROJECTS)',
                              career.projects,
                            ),
                          if (career.achievements.isNotEmpty)
                            _buildSubSection(
                              '업무성과 (ACHIEVEMENTS)',
                              career.achievements,
                            ),
                          if (career.tools.isNotEmpty)
                            _buildSubSection('개발도구 (TOOLS)', [
                              career.tools.join(', '),
                            ]),
                          if (career.environment != null && career.environment!.isNotEmpty)
                            _buildSubSection('개발환경 (ENVIRONMENT)', [
                              career.environment!,
                            ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceContent({
    required String company,
    required String position,
    required String period,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company & Department
        Text(
          company,
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        // Position & Role
        Text(
          position,
          style: TextStyle(
            color: AppColors.accentCyan,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        // Period
        Text(
          period,
          style: const TextStyle(
            color: Color(0xFF8B95A1),
            fontFamily: 'Courier',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 28),
        Column(children: content),
      ],
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.highlightGreen.withValues(alpha: 0.9),
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 1.5,
              fontFamily: 'Courier',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '· ',
                    style: TextStyle(
                      color: AppColors.highlightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        height: 1.5,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
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
