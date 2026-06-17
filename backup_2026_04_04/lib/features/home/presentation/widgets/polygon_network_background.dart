import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PolygonNetworkBackground extends StatelessWidget {
  final AnimationController controller;

  const PolygonNetworkBackground({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: NetworkPainter(
            animationValue: controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class NetworkPainter extends CustomPainter {
  final double animationValue;

  NetworkPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Generate network nodes
    final nodes = _generateNodes(size);

    // Draw connections
    _drawConnections(canvas, nodes);

    // Draw nodes
    _drawNodes(canvas, nodes);

    // Draw main polygon (inspired by logo)
    _drawCentralPolygon(canvas, size);
  }

  List<Offset> _generateNodes(Size size) {
    final random = math.Random(42); // Fixed seed for consistency
    final nodes = <Offset>[];

    // Generate nodes in a grid-like pattern with some randomness
    const nodeCount = 40;
    for (int i = 0; i < nodeCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // Add subtle animation movement
      final animatedX = x + math.sin(animationValue * 2 * math.pi + i) * 20;
      final animatedY = y + math.cos(animationValue * 2 * math.pi + i) * 20;

      nodes.add(Offset(animatedX, animatedY));
    }

    return nodes;
  }

  void _drawConnections(Canvas canvas, List<Offset> nodes) {
    final linePaint = Paint()
      ..color = AppColors.networkLine
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const maxDistance = 200.0;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i] - nodes[j]).distance;

        if (distance < maxDistance) {
          // Opacity based on distance
          final opacity = (1 - distance / maxDistance) * 0.3;
          linePaint.color = AppColors.networkLine.withValues(alpha: opacity);

          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }
  }

  void _drawNodes(Canvas canvas, List<Offset> nodes) {
    final nodePaint = Paint()
      ..color = AppColors.networkNode
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.networkGlow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..style = PaintingStyle.fill;

    for (final node in nodes) {
      // Draw glow
      canvas.drawCircle(node, 8, glowPaint);

      // Draw node
      canvas.drawCircle(node, 3, nodePaint);
    }
  }

  void _drawCentralPolygon(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.7, size.height * 0.4);
    final radius = 150.0;

    // Rotate the polygon with animation
    final rotation = animationValue * 2 * math.pi * 0.1; // Slow rotation

    // Draw polygon edges
    final edgePaint = Paint()
      ..color = AppColors.primaryBlue.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final vertices = _getPolygonVertices(center, radius, 6, rotation);

    // Draw edges
    final path = Path();
    for (int i = 0; i < vertices.length; i++) {
      if (i == 0) {
        path.moveTo(vertices[i].dx, vertices[i].dy);
      } else {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
    }
    path.close();

    // Draw glow effect
    final glowPaint = Paint()
      ..color = AppColors.primaryBlue.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, edgePaint);

    // Draw internal connections
    for (int i = 0; i < vertices.length; i++) {
      for (int j = i + 2; j < vertices.length; j++) {
        final internalPaint = Paint()
          ..color = AppColors.primaryBlue.withValues(alpha: 0.15)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

        canvas.drawLine(vertices[i], vertices[j], internalPaint);
      }
    }

    // Draw vertices
    final vertexPaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;

    final vertexGlowPaint = Paint()
      ..color = AppColors.networkGlow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15)
      ..style = PaintingStyle.fill;

    for (final vertex in vertices) {
      canvas.drawCircle(vertex, 12, vertexGlowPaint);
      canvas.drawCircle(vertex, 5, vertexPaint);
    }
  }

  List<Offset> _getPolygonVertices(
    Offset center,
    double radius,
    int sides,
    double rotation,
  ) {
    final vertices = <Offset>[];
    final angleStep = (2 * math.pi) / sides;

    for (int i = 0; i < sides; i++) {
      final angle = angleStep * i + rotation;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      vertices.add(Offset(x, y));
    }

    return vertices;
  }

  @override
  bool shouldRepaint(NetworkPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
