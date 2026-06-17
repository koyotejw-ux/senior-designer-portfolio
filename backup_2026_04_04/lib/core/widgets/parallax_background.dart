import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ParallaxBackground extends StatefulWidget {
  final ScrollController scrollController;
  final bool isDark;

  const ParallaxBackground({
    super.key,
    required this.scrollController,
    required this.isDark,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _waveController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    // Continuous animation for particles and effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Wave animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Listen to scroll for parallax effect
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base gradient background - darker for better contrast
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isDark
                  ? [
                      const Color(0xFF050810), // Much darker
                      const Color(0xFF0A0E1A),
                      const Color(0xFF0F1419),
                    ]
                  : [
                      const Color(0xFFF5F7FA),
                      const Color(0xFFFFFFFF),
                      const Color(0xFFF0F2F5),
                    ],
            ),
          ),
        ),

        // Animated grid pattern
        if (widget.isDark)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: GridPainter(
                  animationValue: _animationController.value,
                  scrollOffset: _scrollOffset,
                  isDark: widget.isDark,
                ),
              );
            },
          ),

        // Floating orbs with parallax
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              size: size,
              painter: FloatingOrbsPainter(
                animationValue: _animationController.value,
                scrollOffset: _scrollOffset,
                isDark: widget.isDark,
              ),
            );
          },
        ),

        // Wave effect
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              size: size,
              painter: WavePainter(
                animationValue: _waveController.value,
                scrollOffset: _scrollOffset,
                isDark: widget.isDark,
              ),
            );
          },
        ),

        // Particles
        if (widget.isDark)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ParticlesPainter(
                  animationValue: _animationController.value,
                  scrollOffset: _scrollOffset,
                ),
              );
            },
          ),
      ],
    );
  }
}

// Grid Pattern Painter
class GridPainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final bool isDark;

  GridPainter({
    required this.animationValue,
    required this.scrollOffset,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) return;

    final paint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    final offsetY = (scrollOffset * 0.3) % gridSize;
    final fadeAnimation = (math.sin(animationValue * 2 * math.pi) * 0.5 + 0.5);

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint
          ..color = AppColors.accentCyan.withValues(
            alpha: 0.02 + fadeAnimation * 0.01,
          ),
      );
    }

    // Horizontal lines with parallax
    for (double y = -gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y - offsetY),
        Offset(size.width, y - offsetY),
        paint
          ..color = AppColors.primaryBlue.withValues(
            alpha: 0.02 + fadeAnimation * 0.01,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}

// Floating Orbs Painter
class FloatingOrbsPainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final bool isDark;

  FloatingOrbsPainter({
    required this.animationValue,
    required this.scrollOffset,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    // Create multiple orbs with different speeds and parallax
    final orbs = [
      {
        'x': 0.2,
        'y': 0.3,
        'speed': 1.0,
        'parallax': 0.1,
        'colors': [AppColors.primaryBlue, AppColors.accentCyan],
      },
      {
        'x': 0.7,
        'y': 0.5,
        'speed': 1.5,
        'parallax': 0.15,
        'colors': [AppColors.accentCyan, AppColors.highlightGreen],
      },
      {
        'x': 0.4,
        'y': 0.7,
        'speed': 0.8,
        'parallax': 0.2,
        'colors': [AppColors.highlightGreen, AppColors.primaryBlue],
      },
    ];

    for (var orb in orbs) {
      final baseX = size.width * (orb['x'] as double);
      final baseY = size.height * (orb['y'] as double);
      final speed = orb['speed'] as double;
      final parallax = orb['parallax'] as double;
      final colors = orb['colors'] as List<Color>;

      // Floating animation
      final floatOffset = math.sin((animationValue * speed * 2 * math.pi)) * 30;

      // Parallax effect
      final parallaxOffset = scrollOffset * parallax;

      final gradient = RadialGradient(
        colors: [
          colors[0].withValues(alpha: isDark ? 0.15 : 0.08),
          colors[1].withValues(alpha: isDark ? 0.05 : 0.03),
          Colors.transparent,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(baseX, baseY + floatOffset - parallaxOffset),
          radius: 200,
        ),
      );

      canvas.drawCircle(
        Offset(baseX, baseY + floatOffset - parallaxOffset),
        200,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FloatingOrbsPainter oldDelegate) => true;
}

// Wave Painter
class WavePainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final bool isDark;

  WavePainter({
    required this.animationValue,
    required this.scrollOffset,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = (isDark ? AppColors.accentCyan : AppColors.primaryBlue)
          .withValues(alpha: isDark ? 0.1 : 0.05);

    final path = Path();
    final waveHeight = 40.0;
    final waveLength = size.width / 3;

    // Create wave with parallax
    final parallaxOffset = scrollOffset * 0.5;
    final startY = size.height * 0.6 - parallaxOffset % size.height;

    path.moveTo(0, startY);

    for (double x = 0; x <= size.width; x++) {
      final y =
          startY +
          math.sin((x / waveLength + animationValue * 2) * 2 * math.pi) *
              waveHeight;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // Second wave with different phase
    final path2 = Path();
    path2.moveTo(0, startY + 60);

    for (double x = 0; x <= size.width; x++) {
      final y =
          startY +
          60 +
          math.sin((x / waveLength + animationValue * 2 + 0.5) * 2 * math.pi) *
              waveHeight *
              0.7;
      path2.lineTo(x, y);
    }

    canvas.drawPath(
      path2,
      paint
        ..color = (isDark ? AppColors.highlightGreen : AppColors.accentCyan)
            .withValues(alpha: isDark ? 0.08 : 0.04),
    );
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

// Particles Painter
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;

  ParticlesPainter({required this.animationValue, required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.accentCyan.withValues(alpha: 0.3);

    // Create floating particles
    for (int i = 0; i < 30; i++) {
      final seed = i * 0.1;
      final x = (math.sin(seed * 10) * 0.5 + 0.5) * size.width;
      final baseY = (math.cos(seed * 7) * 0.5 + 0.5) * size.height;

      // Particle movement
      final floatY =
          baseY + math.sin((animationValue + seed) * 2 * math.pi) * 20;

      // Parallax effect
      final parallaxY = floatY - (scrollOffset * 0.05 * (i % 3));

      // Pulsing effect
      final pulseSize =
          1.5 + math.sin((animationValue + seed) * 4 * math.pi) * 0.5;

      canvas.drawCircle(
        Offset(x, parallaxY % size.height),
        pulseSize,
        paint
          ..color = AppColors.accentCyan.withValues(
            alpha: 0.2 + (i % 3) * 0.05,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
