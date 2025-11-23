import 'package:flutter/material.dart';

/// Parallax scroll effect widget that moves content at different speeds
class ParallaxWidget extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final double parallaxFactor; // 0.0 = no movement, 1.0 = same as scroll

  const ParallaxWidget({
    super.key,
    required this.child,
    required this.scrollController,
    this.parallaxFactor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final scrollOffset = scrollController.hasClients ? scrollController.offset : 0.0;
        final offset = scrollOffset * parallaxFactor;

        return Transform.translate(
          offset: Offset(0, -offset),
          child: child,
        );
      },
      child: child,
    );
  }
}
