import 'package:flutter/material.dart';
import '../../../../core/widgets/app_header.dart';
import '../widgets/scroll_reveal_widget.dart';
import '../widgets/geometric_network_background.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/portfolio_gallery_section.dart';
import '../widgets/project_story_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/resume_section.dart';
import '../widgets/section_indicator.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showHeaderLogo = false;
  bool _showFab = false;
  int _currentSectionIndex = 0;

  // Section Keys
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _resumeKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey(); // Renamed from careerKey
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Track revealed state manually
  final Set<GlobalKey> _revealedSections = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial check after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _scrollToSection(String section) {
    GlobalKey? key;
    int index = 0;
    switch (section) {
      case 'Home':
        key = _heroKey;
        index = 0;
        break;
      case 'Resume':
        key = _resumeKey;
        index = 1;
        break;
      case 'Experience': // Updated
        key = _experienceKey;
        index = 2;
        break;
      case 'About':
        key = _aboutKey;
        index = 3;
        break;
      case 'Portfolio':
        key = _portfolioKey;
        index = 4;
        break;
      case 'Contact':
        key = _contactKey;
        index = 5;
        break;
    }

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOutCubic,
        alignment: 0.0, // Position section at top, just below header
      );
      setState(() {
        _currentSectionIndex = index;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final height = MediaQuery.of(context).size.height;

    // Header Logo & FAB Visibility
    final showThreshold = height * 0.8;
    if (_showHeaderLogo != (offset > showThreshold)) {
      setState(() {
        _showHeaderLogo = offset > showThreshold;
        _showFab = offset > showThreshold;
      });
    }

    // Update Section Indicator & Visibility
    _updateSectionIndex();
    _checkVisibility();
  }

  void _checkVisibility() {
    final viewportHeight = MediaQuery.of(context).size.height;
    final triggerPoint = viewportHeight * 0.9;

    final keys = [
      _heroKey,
      _resumeKey,
      _experienceKey,
      _aboutKey,
      _portfolioKey,
      _contactKey,
    ];

    bool changed = false;
    for (final key in keys) {
      if (_revealedSections.contains(key)) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final position = box.localToGlobal(Offset.zero);
      final top = position.dy;

      if (top < triggerPoint) {
        _revealedSections.add(key);
        changed = true;
      }
    }

    if (changed) {
      setState(() {});
    }
  }

  void _updateSectionIndex() {
    final keys = [
      _heroKey,
      _resumeKey,
      _experienceKey,
      _aboutKey,
      _portfolioKey,
      _contactKey,
    ];
    final viewportHeight = MediaQuery.of(context).size.height;
    final checkPoint = viewportHeight * 0.3;

    int newIndex = _currentSectionIndex;

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final context = key.currentContext;
      if (context == null) continue;

      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final position = box.localToGlobal(Offset.zero);
      final top = position.dy;
      final bottom = top + box.size.height;

      if (top <= checkPoint && bottom > checkPoint) {
        newIndex = i;
        break;
      }
    }

    if (newIndex != _currentSectionIndex) {
      setState(() {
        _currentSectionIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Geometric Network Background (Deep Space)
          Positioned.fill(
            child: GeometricNetworkBackground(
              scrollController: _scrollController,
              isDark: isDark,
            ),
          ),

          // Main content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(key: _heroKey),

                // Resume Section
                ScrollRevealWidget(
                  key: _resumeKey,
                  isRevealed: _revealedSections.contains(_resumeKey),
                  child: const ResumeSection(),
                ),

                const SizedBox(height: 40),

                // Experience Section
                ScrollRevealWidget(
                  key: _experienceKey,
                  isRevealed: _revealedSections.contains(_experienceKey),
                  delay: const Duration(milliseconds: 100),
                  child: const ExperienceSection(),
                ),

                const SizedBox(height: 40),

                // About Section
                ScrollRevealWidget(
                  key: _aboutKey,
                  isRevealed: _revealedSections.contains(_aboutKey),
                  delay: const Duration(milliseconds: 200),
                  child: const AboutSection(),
                ),

                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),

          // Sticky Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              showLogo: _showHeaderLogo,
              onMenuClick: _scrollToSection,
            ),
          ),

          // Section Indicator (Right Center)
          if (size.width > 1000)
            Positioned(
              right: 40,
              top: size.height * 0.3,
              bottom: size.height * 0.3,
              child: Center(
                child: SectionIndicator(
                  currentIndex: _currentSectionIndex,
                  totalSections: 4,
                  onSelect: (index) {
                    final sections = ['Home', 'Resume', 'Experience', 'About'];
                    _scrollToSection(sections[index]);
                  },
                ),
              ),
            ),

          // FAB (Back to Top) - Brighter and Glowy
          Positioned(
            bottom: 40,
            right: 40,
            child: AnimatedScale(
              scale: _showFab ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.highlightGreen.withValues(alpha: 0.6),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: AppColors.highlightGreen, // Bright Green
                  shape: const CircleBorder(), // Standard Circle
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
