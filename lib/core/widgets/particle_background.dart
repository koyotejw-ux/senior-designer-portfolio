import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double maxParticleSize;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleColor = const Color(0xFF009DDC),
    this.maxParticleSize = 4.0,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        random: Random(index),
        color: widget.particleColor,
        maxSize: widget.maxParticleSize,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (var particle in particles) {
          particle.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: ParticlePainter(particles: particles),
          size: Size.infinite,
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late double opacity;
  late double opacityDelta;
  final Color color;
  final Random random;
  final double maxSize;

  Particle({
    required this.random,
    required this.color,
    required this.maxSize,
  }) {
    reset();
  }

  void reset() {
    x = random.nextDouble();
    y = random.nextDouble();
    vx = (random.nextDouble() - 0.5) * 0.002;
    vy = (random.nextDouble() - 0.5) * 0.002;
    size = random.nextDouble() * maxSize + 1;
    opacity = random.nextDouble() * 0.5 + 0.2;
    opacityDelta = (random.nextDouble() - 0.5) * 0.01;
  }

  void update() {
    x += vx;
    y += vy;
    opacity += opacityDelta;

    // Boundary check
    if (x < 0 || x > 1 || y < 0 || y > 1) {
      reset();
    }

    // Opacity oscillation
    if (opacity <= 0.1 || opacity >= 0.7) {
      opacityDelta = -opacityDelta;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw particle with glow effect
      canvas.drawCircle(
        position,
        particle.size,
        paint,
      );

      // Draw glow
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);

      canvas.drawCircle(
        position,
        particle.size * 1.5,
        glowPaint,
      );
    }

    // Draw connecting lines between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 150) {
          final lineOpacity = (1 - distance / 150) * 0.2;
          final linePaint = Paint()
            ..color = p1.color.withValues(alpha: lineOpacity)
            ..strokeWidth = 0.5;

          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
