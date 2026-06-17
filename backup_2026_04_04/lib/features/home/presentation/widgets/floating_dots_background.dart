import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingDotsBackground extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDark;

  const FloatingDotsBackground({
    super.key,
    required this.scrollController,
    required this.isDark,
  });

  @override
  State<FloatingDotsBackground> createState() => _FloatingDotsBackgroundState();
}

class _FloatingDotsBackgroundState extends State<FloatingDotsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scrollOffset = 0;
  final List<_Dot> _dots = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    widget.scrollController.addListener(_onScroll);
    _generateDots();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
  }

  void _generateDots() {
    final random = math.Random();

    // Large Dots (Background anchors) - Start below Hero (y > 1.0)
    _dots.add(
      _Dot(
        xPercent: 0.1,
        yPercent: 1.1,
        size: 40,
        color: AppColors.primaryBlue,
        parallaxFactor: 0.2,
        speed: 0.5,
      ),
    );
    _dots.add(
      _Dot(
        xPercent: 0.85,
        yPercent: 1.25,
        size: 50,
        color: AppColors.accentCyan,
        parallaxFactor: 0.3,
        speed: 0.7,
      ),
    );
    _dots.add(
      _Dot(
        xPercent: 0.2,
        yPercent: 1.5,
        size: 30,
        color: AppColors.highlightGreen,
        parallaxFactor: 0.15,
        speed: 0.4,
      ),
    );
    _dots.add(
      _Dot(
        xPercent: 0.9,
        yPercent: 1.7,
        size: 45,
        color: const Color(0xFF9D00FF),
        parallaxFactor: 0.25,
        speed: 0.6,
      ),
    );

    // Medium Dots
    for (int i = 0; i < 12; i++) {
      _dots.add(
        _Dot(
          xPercent: random.nextDouble(),
          yPercent: 1.0 + random.nextDouble() * 3.0, // Start from 1.0 to 4.0
          size: 15 + random.nextDouble() * 15,
          color: [
            AppColors.primaryBlue,
            AppColors.accentCyan,
            AppColors.highlightGreen,
            const Color(0xFF9D00FF),
          ][random.nextInt(4)],
          parallaxFactor: 0.1 + random.nextDouble() * 0.2,
          speed: 0.5 + random.nextDouble() * 1.0,
        ),
      );
    }

    // Small Dots (Fast moving, high parallax)
    for (int i = 0; i < 25; i++) {
      _dots.add(
        _Dot(
          xPercent: random.nextDouble(),
          yPercent: 1.0 + random.nextDouble() * 3.0, // Start from 1.0 to 4.0
          size: 4 + random.nextDouble() * 8,
          color: [
            AppColors.primaryBlue,
            AppColors.accentCyan,
          ][random.nextInt(2)],
          parallaxFactor: 0.3 + random.nextDouble() * 0.3,
          speed: 1.0 + random.nextDouble() * 1.5,
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _DotPainter(
            animationValue: _controller.value,
            scrollOffset: _scrollOffset,
            dots: _dots,
            isDark: widget.isDark,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Dot {
  final double xPercent;
  final double yPercent;
  final double size;
  final Color color;
  final double parallaxFactor;
  final double speed;

  _Dot({
    required this.xPercent,
    required this.yPercent,
    required this.size,
    required this.color,
    required this.parallaxFactor,
    required this.speed,
  });
}

class _DotPainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final List<_Dot> dots;
  final bool isDark;

  _DotPainter({
    required this.animationValue,
    required this.scrollOffset,
    required this.dots,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in dots) {
      _drawDot(canvas, size, dot);
    }
  }

  void _drawDot(Canvas canvas, Size size, _Dot dot) {
    double baseX = size.width * dot.xPercent;
    double baseY = size.height * dot.yPercent;

    // Floating effect
    double floatY = math.sin((animationValue * dot.speed * 2 * math.pi)) * 15;

    // Parallax effect
    double parallaxY = scrollOffset * dot.parallaxFactor;

    double finalY = (baseY + floatY - parallaxY);

    // Wrap around logic
    final totalHeight = size.height * 4.0;
    finalY = finalY % totalHeight;
    if (finalY < -dot.size) finalY += totalHeight;
    if (finalY > size.height + dot.size) finalY -= totalHeight;

    double effectiveY = (baseY - parallaxY) % (size.height * 4.0);
    if (effectiveY < -100) effectiveY += size.height * 4.0;

    final center = Offset(baseX, effectiveY + floatY);

    // Draw Square (Pixel Dot)
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = dot.color.withValues(
        alpha: isDark ? 0.4 : 0.3,
      ); // Slightly more opaque than cubes

    // Glow for larger dots
    if (dot.size > 20) {
      canvas.drawRect(
        Rect.fromCenter(
          center: center,
          width: dot.size + 4,
          height: dot.size + 4,
        ),
        Paint()
          ..color = dot.color.withValues(alpha: 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Main Dot
    canvas.drawRect(
      Rect.fromCenter(center: center, width: dot.size, height: dot.size),
      paint,
    );

    // Inner Detail (Optional pixel art look)
    if (dot.size > 10) {
      canvas.drawRect(
        Rect.fromCenter(
          center: center,
          width: dot.size * 0.6,
          height: dot.size * 0.6,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.1),
      );
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => true;
}
