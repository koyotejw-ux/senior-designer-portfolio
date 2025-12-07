import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/content_provider.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;
    final experienceAsync = ref.watch(experienceProvider);

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

          experienceAsync.when(
            data: (experiences) {
              return Column(
                children: experiences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exp = entry.value;

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
                          title: exp.company.toUpperCase(),
                          accentColor: accentColor,
                          child: _buildExperienceContent(
                            company: '${exp.company} / ${exp.role}',
                            period: exp.period,
                            content: [
                              if (exp.responsibilities.isNotEmpty)
                                _buildSubSection(
                                  'RESPONSIBILITIES',
                                  exp.responsibilities,
                                ),
                              if (exp.achievements.isNotEmpty)
                                _buildSubSection(
                                  'ACHIEVEMENTS',
                                  exp.achievements,
                                ),
                              if (exp.tools.isNotEmpty)
                                _buildSubSection('TOOLS', [
                                  exp.tools.join(', '),
                                ]),
                              if (exp.environment.isNotEmpty)
                                _buildSubSection('ENVIRONMENT', [
                                  exp.environment.join(', '),
                                ]),
                              if (exp.reasonForLeaving.isNotEmpty)
                                _buildSubSection('REASON FOR LEAVING', [
                                  exp.reasonForLeaving,
                                ]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text(
              'Error: $err',
              style: const TextStyle(color: Colors.white),
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
