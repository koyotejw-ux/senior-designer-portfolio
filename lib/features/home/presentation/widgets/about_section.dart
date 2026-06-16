import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    'ABOUT ME',
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

          // 1. Greeting (인사말)
          ScrollRevealWidget(
            index: 1,
            child: HolographicCard(
              title: 'Product Strategy',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.greeting,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Background (성장배경)
          ScrollRevealWidget(
            index: 2,
            child: HolographicCard(
              title: '20 Years of Impact',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.background,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 3. Personality (성격의 장단점)
          ScrollRevealWidget(
            index: 3,
            child: HolographicCard(
              title: 'Tech Leadership',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.personality,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 4. Hobbies (생활신조 및 취미)
          ScrollRevealWidget(
            index: 4,
            child: HolographicCard(
              title: 'AI Workflow Research',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.hobbies,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 5. Aspiration (입사 후 포부)
          ScrollRevealWidget(
            index: 5,
            child: HolographicCard(
              title: 'Future Vision',
              accentColor: AppColors.accentCyan,
              child: Text(
                coverLetter.aspiration,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
