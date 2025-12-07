import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_header.dart';
import '../widgets/scroll_reveal_widget.dart';
import '../widgets/geometric_network_background.dart';
import '../widgets/floating_dots_background.dart';
import '../widgets/loading_screen.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/portfolio_gallery_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/resume_section.dart';
import '../widgets/section_indicator.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? initialSection;

  const HomePage({super.key, this.initialSection});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showHeaderLogo = false;
  bool _showFab = false;
  bool _isLoading = false;
  bool _showLoading = false;
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
    // Start with loading state
    _isLoading = true;
    _showLoading = true;

    // Initial check after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();

      // Handle initial section scroll
      if (widget.initialSection != null) {
        if (widget.initialSection == 'contact') {
          _scrollToSection('Contact');
        } else if (widget.initialSection == 'portfolio') {
          _scrollToSection('Portfolio');
        }
      }
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
      case 'Experience':
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
        alignment: 0.0,
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

    final showThreshold = height * 0.8;
    if (_showHeaderLogo != (offset > showThreshold)) {
      setState(() {
        _showHeaderLogo = offset > showThreshold;
        _showFab = offset > showThreshold;
      });
    }

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
          Positioned.fill(
            child: GeometricNetworkBackground(
              scrollController: _scrollController,
              isDark: isDark,
            ),
          ),
          Positioned.fill(
            child: FloatingDotsBackground(
              scrollController: _scrollController,
              isDark: isDark,
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroSection(key: _heroKey),
                ScrollRevealWidget(
                  key: _resumeKey,
                  isRevealed: _revealedSections.contains(_resumeKey),
                  child: const ResumeSection(),
                ),
                const SizedBox(height: 40),
                ScrollRevealWidget(
                  key: _experienceKey,
                  isRevealed: _revealedSections.contains(_experienceKey),
                  delay: const Duration(milliseconds: 100),
                  child: const ExperienceSection(),
                ),
                const SizedBox(height: 40),
                ScrollRevealWidget(
                  key: _aboutKey,
                  isRevealed: _revealedSections.contains(_aboutKey),
                  delay: const Duration(milliseconds: 200),
                  child: const AboutSection(),
                ),
                const SizedBox(height: 40),
                ScrollRevealWidget(
                  key: _portfolioKey,
                  isRevealed: _revealedSections.contains(_portfolioKey),
                  delay: const Duration(milliseconds: 300),
                  child: const PortfolioGallerySection(),
                ),
                const SizedBox(height: 40),
                ScrollRevealWidget(
                  key: _contactKey,
                  isRevealed: _revealedSections.contains(_contactKey),
                  delay: const Duration(milliseconds: 400),
                  child: const ContactSection(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(
              showLogo: _showHeaderLogo,
              onMenuClick: _scrollToSection,
            ),
          ),
          Positioned(
            right: size.width > 600 ? 40 : 10,
            top: size.height * 0.3,
            bottom: size.height * 0.3,
            child: Center(
              child: SectionIndicator(
                currentIndex: _currentSectionIndex,
                totalSections: 6,
                onSelect: (index) {
                  final sections = [
                    'Home',
                    'Resume',
                    'Experience',
                    'About',
                    'Portfolio',
                    'Contact',
                  ];
                  _scrollToSection(sections[index]);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: _showFab ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.6),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      heroTag: 'admin_fab',
                      onPressed: () => GoRouter.of(context).go('/admin'),
                      backgroundColor: AppColors.primaryBlue,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: _showFab ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.highlightGreen.withValues(
                            alpha: 0.6,
                          ),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      heroTag: 'scroll_top_fab',
                      onPressed: _scrollToTop,
                      backgroundColor: AppColors.highlightGreen,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showLoading)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _isLoading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                onEnd: () {
                  if (!_isLoading) {
                    setState(() {
                      _showLoading = false;
                    });
                  }
                },
                child: LoadingScreen(
                  onCompleted: () {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
