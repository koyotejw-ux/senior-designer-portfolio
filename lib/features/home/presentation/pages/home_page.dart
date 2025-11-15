import 'package:flutter/material.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/scroll_reveal_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/portfolio_gallery_section.dart';
import '../widgets/project_story_section.dart';
import '../widgets/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showHeaderLogo = false;
  late AnimationController _smoothScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _smoothScrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _onScroll() {
    // Show logo when scrolled past hero section (approximately 70% of screen height)
    final threshold = MediaQuery.of(context).size.height * 0.7;
    final showLogo = _scrollController.offset > threshold;

    if (showLogo != _showHeaderLogo) {
      setState(() {
        _showHeaderLogo = showLogo;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _smoothScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main content with smooth scroll
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const HeroSection(),
                  ScrollRevealWidget(
                    child: const AboutSection(),
                  ),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 100),
                    child: const SkillsSection(),
                  ),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 200),
                    child: const ExperienceSection(),
                  ),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 250),
                    child: const ProjectStorySection(),
                  ),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 300),
                    child: const PortfolioGallerySection(),
                  ),
                  ScrollRevealWidget(
                    delay: const Duration(milliseconds: 400),
                    child: const ContactSection(),
                  ),
                ],
              ),
            ),
          ),

          // Scroll Progress Indicator - temporarily disabled
          // ScrollProgressIndicator(scrollController: _scrollController),

          // Circular Scroll Indicator - temporarily disabled
          // CircularScrollIndicator(scrollController: _scrollController),

          // Floating Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(showLogo: _showHeaderLogo),
          ),
        ],
      ),
    );
  }
}
