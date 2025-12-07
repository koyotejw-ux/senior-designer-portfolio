import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingCubesBackground extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDark;

  const FloatingCubesBackground({
    super.key,
    required this.scrollController,
    required this.isDark,
  });

  @override
  State<FloatingCubesBackground> createState() =>
      _FloatingCubesBackgroundState();
}

class _FloatingCubesBackgroundState extends State<FloatingCubesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scrollOffset = 0;
  final List<_Cube> _cubes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    widget.scrollController.addListener(_onScroll);
    _generateCubes();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
  }

  void _generateCubes() {
    final random = math.Random();
    // We'll generate cubes for a virtual height that covers reasonable scrolling
    // Since we can't know exact content height easily here, we'll generate enough for a long page
    // or wrap them modulo the screen height.
    // Let's try generating them in a fixed large area and loop them or just fixed positions.
    // Better: Fixed positions relative to viewport height percentages, but spread out.

    // Large Cubes (Background anchors)
    _cubes.add(
      _Cube(
        xPercent: 0.1,
        yPercent: 0.1,
        size: 120,
        color: AppColors.primaryBlue,
        parallaxFactor: 0.2,
        speed: 0.5,
      ),
    );
    _cubes.add(
      _Cube(
        xPercent: 0.85,
        yPercent: 0.25,
        size: 150,
        color: AppColors.accentCyan,
        parallaxFactor: 0.3,
        speed: 0.7,
      ),
    );
    _cubes.add(
      _Cube(
        xPercent: 0.2,
        yPercent: 0.5,
        size: 100,
        color: AppColors.highlightGreen,
        parallaxFactor: 0.15,
        speed: 0.4,
      ),
    );
    _cubes.add(
      _Cube(
        xPercent: 0.9,
        yPercent: 0.7,
        size: 130,
        color: const Color(0xFF9D00FF), // Purple
        parallaxFactor: 0.25,
        speed: 0.6,
      ),
    );

    // Medium Cubes
    for (int i = 0; i < 8; i++) {
      _cubes.add(
        _Cube(
          xPercent: random.nextDouble(),
          yPercent:
              random.nextDouble() *
              1.5, // Spread over 1.5x screen height initially
          size: 40 + random.nextDouble() * 40,
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

    // Small Cubes (Fast moving, high parallax)
    for (int i = 0; i < 15; i++) {
      _cubes.add(
        _Cube(
          xPercent: random.nextDouble(),
          yPercent: random.nextDouble() * 2.0,
          size: 10 + random.nextDouble() * 20,
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
          painter: _CubePainter(
            animationValue: _controller.value,
            scrollOffset: _scrollOffset,
            cubes: _cubes,
            isDark: widget.isDark,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Cube {
  final double xPercent;
  final double yPercent;
  final double size;
  final Color color;
  final double parallaxFactor;
  final double speed;

  _Cube({
    required this.xPercent,
    required this.yPercent,
    required this.size,
    required this.color,
    required this.parallaxFactor,
    required this.speed,
  });
}

class _CubePainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final List<_Cube> cubes;
  final bool isDark;

  _CubePainter({
    required this.animationValue,
    required this.scrollOffset,
    required this.cubes,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final cube in cubes) {
      _drawIsometricCube(canvas, size, cube);
    }
  }

  void _drawIsometricCube(Canvas canvas, Size size, _Cube cube) {
    // Calculate Position
    // Base Y + Float Animation - Parallax
    // We wrap Y so cubes reappear if they scroll off too far, or just let them be fixed in "world space"
    // Let's map yPercent to the entire scrollable area? No, that's hard to know.
    // Let's map yPercent to screen height, but repeat it every screen height with some offset?
    // Or just let them be background elements that move relative to scroll.

    // Current approach: Fixed world positions relative to screen height chunks.
    // We want them to feel like they are in a deep space.

    double baseX = size.width * cube.xPercent;
    double baseY = size.height * cube.yPercent;

    // Floating effect
    double floatY = math.sin((animationValue * cube.speed * 2 * math.pi)) * 15;

    // Parallax effect
    // We want them to move slower than scroll (background) or faster (foreground).
    // parallaxFactor 0.1 means it moves 10% of scroll speed (very distant).
    // parallaxFactor 0.5 means it moves 50% of scroll speed.
    double parallaxY = scrollOffset * cube.parallaxFactor;

    double finalY = (baseY + floatY - parallaxY);

    // Wrap around logic to keep cubes visible during long scrolls
    // If cube goes above top, wrap to bottom + buffer
    // If cube goes below bottom, wrap to top - buffer
    // This creates an "infinite" field of cubes
    final totalHeight = size.height * 1.5; // Loop over this height
    finalY = finalY % totalHeight;
    if (finalY < -cube.size) finalY += totalHeight;
    if (finalY > size.height + cube.size) finalY -= totalHeight;

    // Adjust for visual centering if needed, but modulo handles it.
    // Actually modulo might make them jump.
    // Let's try simple modulo on the (baseY - parallaxY) component.

    double effectiveY = (baseY - parallaxY) % (size.height * 1.5);
    if (effectiveY < -100) effectiveY += size.height * 1.5;

    final center = Offset(baseX, effectiveY + floatY);

    // Draw Cube
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = cube.color.withValues(alpha: isDark ? 0.3 : 0.2);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = cube.color.withValues(alpha: isDark ? 0.05 : 0.02);

    // Isometric Math
    //       P1
    //      /  \
    //    P2    P3

    // Simpler Iso:
    // Angle 30 degrees (pi/6)
    final r = cube.size / 2;
    final dx = r * math.cos(math.pi / 6);
    final dy = r * math.sin(math.pi / 6);

    final pCenter = center;
    final pTop = center + Offset(0, -r);
    final pBottom = center + Offset(0, r);

    final pTopRight = center + Offset(dx, -dy);
    final pBottomRight = center + Offset(dx, dy);

    final pTopLeft = center + Offset(-dx, -dy);
    final pBottomLeft = center + Offset(-dx, dy);

    // Draw Faces

    // Top Face
    final topFace = Path()
      ..moveTo(pCenter.dx, pCenter.dy)
      ..lineTo(pTopLeft.dx, pTopLeft.dy)
      ..lineTo(pTop.dx, pTop.dy)
      ..lineTo(pTopRight.dx, pTopRight.dy)
      ..close();

    // Right Face
    final rightFace = Path()
      ..moveTo(pCenter.dx, pCenter.dy)
      ..lineTo(pTopRight.dx, pTopRight.dy)
      ..lineTo(pBottomRight.dx, pBottomRight.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..close();

    // Left Face
    final leftFace = Path()
      ..moveTo(pCenter.dx, pCenter.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pBottomLeft.dx, pBottomLeft.dy)
      ..lineTo(pTopLeft.dx, pTopLeft.dy)
      ..close();

    // Draw Fills
    canvas.drawPath(
      topFace,
      fillPaint..color = cube.color.withValues(alpha: isDark ? 0.1 : 0.05),
    );
    canvas.drawPath(
      rightFace,
      fillPaint..color = cube.color.withValues(alpha: isDark ? 0.08 : 0.04),
    );
    canvas.drawPath(
      leftFace,
      fillPaint..color = cube.color.withValues(alpha: isDark ? 0.06 : 0.03),
    );

    // Draw Outlines
    canvas.drawPath(topFace, paint);
    canvas.drawPath(rightFace, paint);
    canvas.drawPath(leftFace, paint);

    // Glow (Optional)
    /*
    if (cube.size > 80) {
      canvas.drawPath(topFace, Paint()
        ..color = cube.color.withOpacity(0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20)
      );
    }
    */
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) => true;
}
