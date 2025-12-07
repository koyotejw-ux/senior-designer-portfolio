import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/project_model.dart';
import '../../data/providers/content_provider.dart';
import '../pages/project_detail_page.dart';
import 'holographic_card.dart';

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
              // Section Header
              Row(
                children: [
                  Container(
                    width: 4,
                    height: isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.highlightGreen,
                          AppColors.accentCyan,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Featured Projects',
                    style: (isMobile ? AppTypography.h3 : AppTypography.h2)
                        .copyWith(
                          color: isDark
                              ? AppColors.gray100
                              : AppColors.lightGray900,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              SizedBox(height: isMobile ? 48 : 72),

              // Project Grid/List
              projectsAsync.when(
                data: (projects) {
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
                  if (isMobile) {
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
                        childAspectRatio: isTablet ? 1.8 : 1.4,
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
            ],
          ),
        ),
      ),
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image (if available)
                    if (project.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: project.imageUrl!.toLowerCase().endsWith('.svg')
                            ? SvgPicture.network(
                                project.imageUrl!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                placeholderBuilder: (context) => Container(
                                  height: 200,
                                  color: AppColors.charcoal,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: AppColors.charcoal.withValues(
                                  alpha: 0.3,
                                ),
                                child: Center(
                                  child: Image.network(
                                    project.imageUrl!,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: AppColors.charcoal,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Loading...',
                                                style: AppTypography.bodySmall
                                                    .copyWith(
                                                      color: AppColors.gray100,
                                                      fontSize: 10,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: AppColors.charcoal,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
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

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      project.title,
                      style: AppTypography.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(
                            color: accentColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      project.subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.gray100,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Company & Year
                    Text(
                      '${project.company} • ${project.year}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray100.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontFamily: 'Courier',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      project.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.gray100.withValues(alpha: 0.8),
                        height: 1.6,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 20),

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
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            tag.toUpperCase(),
                            style: AppTypography.bodySmall.copyWith(
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
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: (200 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
