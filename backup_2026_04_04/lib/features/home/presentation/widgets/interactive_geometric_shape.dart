import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../../../../core/theme/app_colors.dart';

class InteractiveGeometricShape extends StatefulWidget {
  final double size;
  final bool isDark;

  const InteractiveGeometricShape({
    super.key,
    required this.size,
    required this.isDark,
  });

  @override
  State<InteractiveGeometricShape> createState() =>
      _InteractiveGeometricShapeState();
}

class _InteractiveGeometricShapeState extends State<InteractiveGeometricShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Rotation state
  double _rotationX = 0;
  double _rotationY = 0;
  double _autoRotationSpeed = 0.005;

  // Interaction state
  Offset? _lastPanPos;

  // Particle System
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    _lastPanPos = details.localPosition;
    setState(() {
      _autoRotationSpeed = 0; // Stop auto rotation while dragging
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_lastPanPos == null) return;

    final delta = details.localPosition - _lastPanPos!;

    // Spawn particles on drag
    _spawnParticles(details.localPosition, delta);

    setState(() {
      _rotationY += delta.dx * 0.01;
      _rotationX -= delta.dy * 0.01;
      _lastPanPos = details.localPosition;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _lastPanPos = null;
    setState(() {
      _autoRotationSpeed = 0.005; // Resume auto rotation
    });
  }

  void _spawnParticles(Offset position, Offset velocity) {
    for (int i = 0; i < 3; i++) {
      _particles.add(
        _Particle(
          position: position,
          velocity: Offset(
            velocity.dx * 0.1 + (_random.nextDouble() - 0.5) * 2,
            velocity.dy * 0.1 + (_random.nextDouble() - 0.5) * 2,
          ),
          color: [
            AppColors.primaryBlue,
            AppColors.highlightGreen,
            AppColors.accentCyan,
          ][_random.nextInt(3)],
          size: _random.nextDouble() * 6 + 2,
          life: 1.0,
        ),
      );
    }
  }

  void _updateParticles() {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.position += p.velocity;
      p.life -= 0.02;
      p.velocity *= 0.95; // Friction
      p.size *= 0.95; // Shrink

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Apply auto rotation
          _rotationY += _autoRotationSpeed;
          _rotationX += _autoRotationSpeed * 0.5;

          _updateParticles();

          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PixelIcosahedronPainter(
              rotationX: _rotationX,
              rotationY: _rotationY,
              particles: _particles,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;

  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
}

class _PixelIcosahedronPainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final List<_Particle> particles;

  _PixelIcosahedronPainter({
    required this.rotationX,
    required this.rotationY,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Define Icosahedron Vertices (Golden Ratio)
    final t = (1.0 + math.sqrt(5.0)) / 2.0;
    final List<vector.Vector3> vertices = [
      vector.Vector3(-1, t, 0),
      vector.Vector3(1, t, 0),
      vector.Vector3(-1, -t, 0),
      vector.Vector3(1, -t, 0),
      vector.Vector3(0, -1, t),
      vector.Vector3(0, 1, t),
      vector.Vector3(0, -1, -t),
      vector.Vector3(0, 1, -t),
      vector.Vector3(t, 0, -1),
      vector.Vector3(t, 0, 1),
      vector.Vector3(-t, 0, -1),
      vector.Vector3(-t, 0, 1),
    ];

    // Create Rotation Matrix
    final rotX = vector.Matrix4.rotationX(rotationX);
    final rotY = vector.Matrix4.rotationY(rotationY);
    final transform = rotX * rotY;

    // Transform Vertices
    final List<vector.Vector3> transformedVertices = vertices.map((v) {
      final v4 = vector.Vector4(v.x, v.y, v.z, 1.0);
      final transformed = transform * v4;
      return vector.Vector3(transformed.x, transformed.y, transformed.z)
        ..normalize()
        ..scale(radius);
    }).toList();

    // Sort by Z for depth
    transformedVertices.sort((a, b) => a.z.compareTo(b.z));

    // Draw Pixels (Voxels) at vertices
    for (final v in transformedVertices) {
      // Only draw if somewhat in front
      // if (v.z < -radius * 0.5) continue;

      final scale =
          (v.z + radius * 2) / (radius * 2); // Simple perspective scale
      final pixelSize = 12.0 * scale;

      final offset = Offset(center.dx + v.x, center.dy + v.y);

      // Color cycling based on position index (simulated)
      final colorIndex = (v.x.abs() + v.y.abs()).toInt() % 3;
      final color = [
        AppColors.primaryBlue,
        AppColors.highlightGreen,
        AppColors.accentCyan,
      ][colorIndex];

      // Draw Glow
      canvas.drawRect(
        Rect.fromCenter(
          center: offset,
          width: pixelSize * 2,
          height: pixelSize * 2,
        ),
        Paint()
          ..color = color.withValues(alpha: 0.3 * scale)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Draw Core Pixel
      canvas.drawRect(
        Rect.fromCenter(center: offset, width: pixelSize, height: pixelSize),
        Paint()..color = color.withValues(alpha: 0.9),
      );

      // Draw connecting lines to nearest neighbors (simple distance check for visual effect)
      // This creates the "constellation" look
      for (final other in transformedVertices) {
        if (v == other) continue;
        if (v.distanceTo(other) < radius * 1.2) {
          canvas.drawLine(
            offset,
            Offset(center.dx + other.x, center.dy + other.y),
            Paint()
              ..color = AppColors.primaryBlue.withValues(alpha: 0.2 * scale)
              ..strokeWidth = 1,
          );
        }
      }
    }

    // Draw Particles
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromCenter(center: p.position, width: p.size, height: p.size),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelIcosahedronPainter oldDelegate) => true;
}
