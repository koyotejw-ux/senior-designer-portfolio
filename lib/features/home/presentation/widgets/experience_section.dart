import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    'EXPERIENCE',
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

          // Career History
          Column(
            children: resume.careers.asMap().entries.map((entry) {
              final index = entry.key;
              final career = entry.value;

              // Unified accent color for all experience cards
              const accentColor = AppColors.accentCyan;

              return Column(
                children: [
                  ScrollRevealWidget(
                    index: index + 1,
                    child: HolographicCard(
                      title: career.company.toUpperCase(),
                      accentColor: accentColor,
                      child: _buildExperienceContent(
                        department: career.department,
                        position: career.position,
                        role: career.role,
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
    required String department,
    required String position,
    required String role,
    required String period,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level 2: Department / Team (Cyan, 14px)
        Text(
          department,
          style: const TextStyle(
            color: AppColors.accentCyan,
            fontWeight: FontWeight.w800,
            fontFamily: 'Pretendard',
            fontSize: 14,
            letterSpacing: 0.5,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        
        // Role & Description (Soft white, 13px)
        Text(
          role,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontFamily: 'Pretendard',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),

        // Position & Period Metadata Row (Muted slate, 12px)
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              position,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: Color(0xFF475569),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              period,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ],
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level 3: Subheadings (Green, 14px, Pretendard Black)
          Text(
            title,
            style: TextStyle(
              color: AppColors.highlightGreen.withValues(alpha: 0.95),
              fontWeight: FontWeight.w900, // Pretendard Black
              fontSize: 14,
              letterSpacing: 0.3,
              fontFamily: 'Pretendard',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: const TextStyle(
                  color: Color(0xFF94A3B8), // Level 4: Body (Slate-400, 12px)
                  fontFamily: 'Pretendard',
                  height: 1.3,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
