import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/providers/resume_provider.dart';
import 'scroll_reveal_widget.dart';
import 'holographic_card.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 1000;
    final coverLetter = ref.watch(coverLetterProvider);

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

          // 1. Greeting (인사말)
          ScrollRevealWidget(
            index: 1,
            child: HolographicCard(
              title: '인사말',
              accentColor: AppColors.primaryBlue,
              child: Text(
                coverLetter.greeting,
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

          // 2. Background (성장배경)
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: '성장배경',
              accentColor: AppColors.highlightGreen,
              child: Text(
                coverLetter.background,
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

          // 3. Personality (성격의 장단점)
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: '성격의 장단점',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.personality,
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

          // 4. Hobbies (생활신조 및 취미)
          ScrollRevealWidget(
            index: 4,
            child: HolographicCard(
              title: '생활신조 및 취미',
              accentColor: const Color(0xFF9D00FF),
              child: Text(
                coverLetter.hobbies,
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

          // 5. Aspiration (입사 후 포부)
          ScrollRevealWidget(
            index: 5,
            child: HolographicCard(
              title: '입사 후 포부',
              accentColor: AppColors.primaryBlue,
              child: Text(
                coverLetter.aspiration,
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
