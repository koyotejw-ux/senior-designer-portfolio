import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GeometricNetworkBackground extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDark;

  const GeometricNetworkBackground({
    super.key,
    required this.scrollController,
    required this.isDark,
  });

  @override
  State<GeometricNetworkBackground> createState() =>
      _GeometricNetworkBackgroundState();
}

class _GeometricNetworkBackgroundState extends State<GeometricNetworkBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scrollOffset = 0;
  double _lastScrollOffset = 0;
  Offset _mousePos = Offset.zero;

  // Layers
  final List<_Star> _stars = [];
  final List<_PixelRain> _rainParticles = []; // Magical Pixel Rain

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
    final size = const Size(2000, 4000);

    // Random Color Palette (Darker/Mystical)
    final colors = [
      Colors.white.withValues(alpha: 0.8),
      AppColors.primaryBlue.withValues(alpha: 0.8),
      AppColors.highlightGreen.withValues(alpha: 0.8),
      const Color(0xFF9D00FF).withValues(alpha: 0.8), // Purple for fantasy
    ];

    // 1. Background Stars (Reduced count for cleaner look)
    for (int i = 0; i < 150; i++) {
      _stars.add(
        _Star(
          position: Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          brightness: random.nextDouble(),
          size: random.nextDouble() * 2 + 1,
          color: colors[random.nextInt(colors.length)],
        ),
      );
    }
  }

  void _onScroll() {
    final currentOffset = widget.scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;
    _lastScrollOffset = currentOffset;

    setState(() {
      _scrollOffset = currentOffset;

      // Spawn Pixel Rain based on scroll speed
      if (delta.abs() > 1.0) {
        _spawnPixelRain(delta);
      }
    });
  }

  void _spawnPixelRain(double scrollDelta) {
    final random = math.Random();
    final count = (scrollDelta.abs() / 3).clamp(1, 8).toInt();
    final size = MediaQuery.of(context).size;

    for (int i = 0; i < count; i++) {
      _rainParticles.add(
        _PixelRain(
          position: Offset(
            random.nextDouble() * size.width,
            // Spawn near bottom if scrolling down, top if up
            scrollDelta > 0 ? size.height + 20 : -20,
          ),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 1, // Gentle drift
            -scrollDelta * (0.2 + random.nextDouble() * 0.3), // Float speed
          ),
          size: random.nextDouble() * 8 + 4, // Pixel size
          color: [
            AppColors.primaryBlue,
            AppColors.highlightGreen,
            AppColors.accentCyan,
            const Color(0xFF9D00FF), // Purple
          ][random.nextInt(4)],
          life: 1.0,
        ),
      );
    }
  }

  void _updateParticles() {
    for (int i = _rainParticles.length - 1; i >= 0; i--) {
      final p = _rainParticles[i];
      p.position += p.velocity;
      p.life -= 0.015; // Slow fade out
      // p.size *= 0.99; // Keep size mostly constant for pixel look

      if (p.life <= 0) {
        _rainParticles.removeAt(i);
      }
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
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePos = event.localPosition;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateParticles(); // Update particle physics every frame

          return CustomPaint(
            painter: _MagicalRainPainter(
              scrollOffset: _scrollOffset,
              animationValue: _controller.value,
              mousePos: _mousePos,
              stars: _stars,
              rainParticles: _rainParticles,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

// --- Data Classes ---

class _Star {
  final Offset position;
  final double brightness;
  final double size;
  final Color color;

  _Star({
    required this.position,
    required this.brightness,
    required this.size,
    required this.color,
  });
}

class _PixelRain {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;

  _PixelRain({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.life,
  });
}

// --- Painter ---

class _MagicalRainPainter extends CustomPainter {
  final double scrollOffset;
  final double animationValue;
  final Offset mousePos;
  final List<_Star> stars;
  final List<_PixelRain> rainParticles;

  _MagicalRainPainter({
    required this.scrollOffset,
    required this.animationValue,
    required this.mousePos,
    required this.stars,
    required this.rainParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 0. Background - Deep Void
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF020202), // Almost Pure Black
          const Color(0xFF050508), // Very Deep Blue-Black
          const Color(0xFF020202), // Almost Pure Black
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Mouse Parallax Factors
    final mouseOffsetX = (mousePos.dx - centerX);
    final mouseOffsetY = (mousePos.dy - centerY);

    // 1. Stars (Subtle, Distant)
    for (final star in stars) {
      final parallaxX = (star.position.dx + mouseOffsetX * 0.01) % size.width;
      final parallaxY =
          (star.position.dy - scrollOffset * 0.02 + mouseOffsetY * 0.01) %
          size.height;

      // Draw Star with Glow
      final paint = Paint()
        ..color = star.color
            .withValues(alpha: star.brightness * 0.6) // Dimmer
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(parallaxX, parallaxY), star.size * 0.6, paint);

      // Occasional Twinkle
      if (math.Random().nextDouble() > 0.98) {
        canvas.drawCircle(
          Offset(parallaxX, parallaxY),
          star.size * 1.5,
          Paint()
            ..color = star.color.withValues(alpha: 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // 2. Magical Pixel Rain
    for (final p in rainParticles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life)
        ..style = PaintingStyle.fill;

      // Glow Effect
      canvas.drawRect(
        Rect.fromCenter(
          center: p.position,
          width: p.size * 1.5,
          height: p.size * 1.5,
        ),
        Paint()
          ..color = p.color.withValues(alpha: p.life * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Core Pixel Square
      canvas.drawRect(
        Rect.fromCenter(center: p.position, width: p.size, height: p.size),
        paint,
      );

      // Trail (Optional: faint line behind)
      /*
      canvas.drawLine(
        p.position,
        p.position - p.velocity * 3,
        Paint()
          ..color = p.color.withValues(alpha: p.life * 0.2)
          ..strokeWidth = 1,
      );
      */
    }
  }

  @override
  bool shouldRepaint(covariant _MagicalRainPainter oldDelegate) => true;
}
