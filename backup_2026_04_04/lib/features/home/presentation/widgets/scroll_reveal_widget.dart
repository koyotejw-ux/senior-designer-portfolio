import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final int index; // For staggering
  final double parallaxOffset;
  final Duration delay;
  final bool? isRevealed; // Manual trigger override

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.index = 0,
    this.parallaxOffset = 0.0,
    this.delay = Duration.zero,
    this.isRevealed,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  late final Key _detectorKey;

  @override
  void initState() {
    super.initState();
    _detectorKey = UniqueKey();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Slower for elegance
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Easing Animation: easeOutCubic for smooth natural slide
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.isRevealed == true) {
      _triggerAnimation();
    }
  }

  @override
  void didUpdateWidget(ScrollRevealWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed == true && !_hasAnimated) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;

    Future.delayed(
      widget.delay + Duration(milliseconds: widget.index * 150),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (widget.isRevealed == true) return;

        if (info.visibleFraction > 0.01 && !_hasAnimated) {
          _triggerAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
