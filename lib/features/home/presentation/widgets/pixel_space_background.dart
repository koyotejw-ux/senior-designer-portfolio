import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PixelSpaceBackground extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDark;

  const PixelSpaceBackground({
    super.key,
    required this.scrollController,
    required this.isDark,
  });

  @override
  State<PixelSpaceBackground> createState() => _PixelSpaceBackgroundState();
}

class _PixelSpaceBackgroundState extends State<PixelSpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scrollOffset = 0;

  // Star data: x, y, size, speed, brightness
  final List<List<double>> _stars = [];
  // Planet data: x, y, size, type (color index), speed
  final List<List<double>> _planets = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    widget.scrollController.addListener(_onScroll);
    _generateSpaceObjects();
  }

  void _generateSpaceObjects() {
    final random = math.Random();

    // Generate Stars
    for (int i = 0; i < 200; i++) {
      _stars.add([
        random.nextDouble(), // x
        random.nextDouble(), // y
        random.nextInt(3) + 1.0, // size (1-3 pixels)
        random.nextDouble() * 0.2 + 0.05, // speed
        random.nextDouble() * 0.5 + 0.5, // brightness
      ]);
    }

    // Generate Planets
    for (int i = 0; i < 5; i++) {
      _planets.add([
        random.nextDouble(), // x
        random.nextDouble() * 2.0, // y (spread vertically more)
        random.nextInt(40) + 20.0, // size
        random.nextInt(3).toDouble(), // type
        random.nextDouble() * 0.1 + 0.02, // speed
      ]);
    }
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
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
          painter: _PixelSpacePainter(
            scrollOffset: _scrollOffset,
            animationValue: _controller.value,
            stars: _stars,
            planets: _planets,
            isDark: widget.isDark,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _PixelSpacePainter extends CustomPainter {
  final double scrollOffset;
  final double animationValue;
  final List<List<double>> stars;
  final List<List<double>> planets;
  final bool isDark;

  _PixelSpacePainter({
    required this.scrollOffset,
    required this.animationValue,
    required this.stars,
    required this.planets,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Background
    final bgPaint = Paint()
      ..color = isDark
          ? const Color(0xFF010103)
          : const Color(0xFF050510); // Deeper black
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 1. FAR LAYER (Stars) - Slowest
    for (final star in stars) {
      final x = star[0] * size.width;
      // Speed factor 0.05 - very slow
      double y = (star[1] * size.height - scrollOffset * 0.05) % size.height;
      if (y < 0) y += size.height;

      final starSize = star[2];
      final brightness = star[4];

      // Twinkle effect
      final twinkle = math.sin(animationValue * 10 + star[0] * 10) * 0.3 + 0.7;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: brightness * twinkle * (isDark ? 0.8 : 0.5),
        );

      canvas.drawRect(Rect.fromLTWH(x, y, starSize, starSize), paint);
    }

    // 2. MID LAYER (Small Planets/Distant Objects) - Medium Speed
    for (int i = 0; i < planets.length ~/ 2; i++) {
      _drawPlanetLayer(canvas, size, planets[i], 0.3); // Speed 0.3
    }

    // 3. NEAR LAYER (Large Objects) - Fastest
    for (int i = planets.length ~/ 2; i < planets.length; i++) {
      _drawPlanetLayer(
        canvas,
        size,
        planets[i],
        1.2,
      ); // Speed 1.2 - noticeably faster
    }
  }

  void _drawPlanetLayer(
    Canvas canvas,
    Size size,
    List<double> planet,
    double speed,
  ) {
    final x = planet[0] * size.width;
    // Parallax Y calculation
    double y =
        (planet[1] * size.height - scrollOffset * speed) % (size.height * 1.5);
    if (y < -100) y += size.height * 1.5; // Wrap around with buffer

    // Scale size based on speed (closer objects are bigger)
    final baseSize = planet[2];
    final displaySize = baseSize * (speed * 0.8 + 0.5);

    final type = planet[3].toInt();

    Color planetColor;
    switch (type) {
      case 0:
        planetColor = AppColors.primaryBlue;
        break;
      case 1:
        planetColor = AppColors.accentCyan;
        break;
      default:
        planetColor = AppColors.highlightGreen;
    }

    // Adjust opacity for depth (farther objects are dimmer)
    final opacity = (speed * 0.5).clamp(0.3, 1.0);

    _drawPixelPlanet(
      canvas,
      Offset(x, y),
      displaySize,
      planetColor.withValues(alpha: opacity),
    );
  }

  void _drawPixelPlanet(
    Canvas canvas,
    Offset center,
    double size,
    Color color,
  ) {
    final pixelSize = size / 12; // Pixelated look relative to size
    final radius = size / 2;
    final steps = (size / pixelSize).ceil();

    final paint = Paint()..color = color;
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.4);
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);

    for (int i = 0; i < steps; i++) {
      for (int j = 0; j < steps; j++) {
        final px = i * pixelSize - radius;
        final py = j * pixelSize - radius;

        // Circle check
        if (px * px + py * py <= radius * radius) {
          final rect = Rect.fromLTWH(
            center.dx + px,
            center.dy + py,
            pixelSize,
            pixelSize,
          );

          // Draw main pixel
          canvas.drawRect(rect, paint);

          // Shading (Bottom Right)
          if (px > radius * 0.1 || py > radius * 0.1) {
            canvas.drawRect(rect, shadowPaint);
          }

          // Highlight (Top Left)
          if (px < -radius * 0.3 && py < -radius * 0.3) {
            canvas.drawRect(rect, highlightPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelSpacePainter oldDelegate) => true;
}
