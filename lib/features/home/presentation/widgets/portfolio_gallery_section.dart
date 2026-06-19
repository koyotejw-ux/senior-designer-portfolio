import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/project_model.dart';
import '../../data/providers/content_provider.dart';
import '../pages/project_detail_page.dart';
import 'holographic_card.dart';
import 'web_optimized_image.dart';

class PortfolioGallerySection extends ConsumerStatefulWidget {
  const PortfolioGallerySection({super.key});

  @override
  ConsumerState<PortfolioGallerySection> createState() =>
      _PortfolioGallerySectionState();
}

class _PortfolioGallerySectionState
    extends ConsumerState<PortfolioGallerySection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width < AppConstants.tabletBreakpoint;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final projectsAsync = ref.watch(projectsProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 80 : 120,
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 100,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.01,
        ), // Faint color to ensure hit-testing/visibility
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
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
                  'PORTFOLIO',
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 40 : 64,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 72),

              // Project Grid/List
              projectsAsync.when(
                data: (allProjects) {
                  final projects = allProjects
                      .where((p) => p.isCorporate == false)
                      .toList();
                  if (projects.isEmpty) {
                    return Center(
                      child: Text(
                        'No projects yet.',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }
                  if (isMobile || isTablet) {
                    return Column(
                      children: projects.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildProjectCard(
                            entry.value,
                            isDark,
                            isMobile,
                            entry.key,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 1 : 2,
                        crossAxisSpacing: 32,
                        mainAxisSpacing: 32,
                        childAspectRatio: isTablet
                            ? 1.8
                            : 1.1, // Increased for tablet to prevent overflow
                      ),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(
                          projects[index],
                          isDark,
                          isMobile,
                          index,
                        );
                      },
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading projects: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    String label,
    IconData icon,
    List<Color> colors,
    VoidCallback onTap,
    bool isDark,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.5),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: colors[1].withValues(alpha: 0.3),
                blurRadius: 50,
                offset: const Offset(0, 15),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Text(
                label.toUpperCase(),
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildProjectCard(
    ProjectModel project,
    bool isDark,
    bool isMobile,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    final accentColor = project.gradientColors.isNotEmpty
        ? project.gradientColors[0]
        : AppColors.primaryBlue;

    return MouseRegion(
          onEnter: (_) => setState(() => _selectedIndex = index),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // Navigate to detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProjectDetailPage(projectId: project.id),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              transform: isSelected
                  ? (Matrix4.identity()..setTranslationRaw(0.0, -8.0, 0.0))
                  : Matrix4.identity(),
              child: HolographicCard(
                accentColor: accentColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image (if available)
                      if (project.imageUrl != null) ...[
                        GestureDetector(
                          onTap: () {
                            // Navigate to detail page when image is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailPage(projectId: project.id),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: project.imageUrl!.toLowerCase().endsWith('.svg')
                                  ? SvgPicture.network(
                                      project.imageUrl!,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      placeholderBuilder: (context) => Container(
                                        color: AppColors.charcoal,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          color: AppColors.charcoal.withValues(
                                            alpha: 0.3,
                                          ),
                                          child: project.imageUrl!.startsWith('http')
                                              ? Image.network(
                                                  project.imageUrl!,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.topCenter,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    color: AppColors.charcoal,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Image.asset(
                                                  project.imageUrl!,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.topCenter,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    color: AppColors.charcoal,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        // Transparent overlay to ensure click detection
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          project.category,
                          style: AppTypography.labelSmall.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Title
                      Text(
                        project.title,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          color: Colors.white,
                          fontWeight: FontWeight.w900, // Pretendard Black
                          fontSize: 20,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        project.subtitle,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Company & Year
                      Row(
                        children: [
                          Icon(
                            Icons.business_center_outlined,
                            size: 12,
                            color: const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            project.company,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            project.year,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        project.description,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFF94A3B8), // Level 4 Body
                          height: 1.4,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Text(
                              tag.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                color: accentColor.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                letterSpacing: 1.0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: (200 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
