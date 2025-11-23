import 'package:flutter/material.dart';

/// Unified section wrapper for consistent layout across all sections
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? maxWidth;

  const SectionWrapper({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width < 1024;

    // Unified section spacing
    const double sectionSpacing = 120.0; // Desktop
    const double sectionSpacingTablet = 100.0;
    const double sectionSpacingMobile = 80.0;

    // Unified max width
    final double defaultMaxWidth = maxWidth ?? 1200.0;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? sectionSpacingMobile
            : isTablet
                ? sectionSpacingTablet
                : sectionSpacing,
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: defaultMaxWidth),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : isTablet ? 60 : 80,
          ),
          child: child,
        ),
      ),
    );
  }
}
