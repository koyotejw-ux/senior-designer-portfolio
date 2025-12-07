import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/content_provider.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;
    final profileAsync = ref.watch(profileProvider);

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

          profileAsync.when(
            data: (profile) {
              if (profile == null) {
                return const Center(
                  child: Text(
                    'No profile data available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Column(
                children: [
                  // 1. Introduction
                  ScrollRevealWidget(
                    index: 1,
                    child: HolographicCard(
                      title: 'INTRODUCTION',
                      accentColor: AppColors.primaryBlue,
                      child: Text(
                        profile.introduction,
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
                        profile.philosophy,
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
                        profile.aspirations,
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
}
