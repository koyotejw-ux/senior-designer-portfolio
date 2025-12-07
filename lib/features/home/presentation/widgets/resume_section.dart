import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/content_provider.dart';
import '../../data/models/profile_model.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class ResumeSection extends ConsumerWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;

    final profileAsync = ref.watch(profileProvider);
    final educationAsync = ref.watch(educationProvider);
    final experienceAsync = ref.watch(experienceProvider);
    final skillsAsync = ref.watch(skillsProvider);

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
              title: 'PERSONAL INFO',
              accentColor: AppColors.primaryBlue,
              child: profileAsync.when(
                data: (profile) => _buildPersonalInfoGrid(isMobile, profile),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Education
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: 'EDUCATION',
              accentColor: AppColors.highlightGreen,
              child: educationAsync.when(
                data: (educations) => Column(
                  children: educations
                      .map(
                        (edu) => _buildRowItem(
                          edu.period,
                          '${edu.school} / ${edu.major} (${edu.gpa})',
                        ),
                      )
                      .toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
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
              child: experienceAsync.when(
                data: (experiences) => Column(
                  children: experiences
                      .map(
                        (exp) => _buildRowItem(
                          exp.period,
                          '${exp.company} / ${exp.role}',
                        ),
                      )
                      .toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
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
              child: skillsAsync.when(
                data: (skills) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: skills
                      .where((s) => s.category == 'competency')
                      .map((s) => _buildBulletPoint(s.description))
                      .toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
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
              child: skillsAsync.when(
                data: (skills) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: skills
                      .where((s) => s.category == 'qualification')
                      .map((s) => _buildBulletPoint(s.description))
                      .toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoGrid(bool isMobile, ProfileModel? profile) {
    if (profile == null) {
      return const Text(
        'No profile data',
        style: TextStyle(color: Colors.white),
      );
    }

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('NAME', profile.name),
              _buildInfoRow('BIRTH', profile.birth),
              _buildInfoRow('ADDRESS', profile.address),
              _buildInfoRow('MILITARY', profile.military),
              _buildInfoRow('PHONE', profile.phone),
              _buildInfoRow('EMAIL', profile.email),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('NAME', profile.name),
                    _buildInfoRow('BIRTH', profile.birth),
                    _buildInfoRow('ADDRESS', profile.address),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    _buildInfoRow('MILITARY', profile.military),
                    _buildInfoRow('PHONE', profile.phone),
                    _buildInfoRow('EMAIL', profile.email),
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
