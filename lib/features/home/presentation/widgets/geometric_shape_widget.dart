import 'dart:math' as math;
import 'package:flutter/material.dart';

class GeometricShapeWidget extends StatefulWidget {
  final double size;

  const GeometricShapeWidget({super.key, this.size = 400});

  @override
  State<GeometricShapeWidget> createState() => _GeometricShapeWidgetState();
}

class _GeometricShapeWidgetState extends State<GeometricShapeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationX = 0.4;
  double _rotationY = 0.4;
  double _autoRotationX = 0.0;
  double _autoRotationY = 0.0;

  // Logo colors: Blue, Cyan, Yellow
  final List<Color> _logoColors = [
    const Color(0xFF0095DA), // Blue
    const Color(0xFF00D9FF), // Cyan
    const Color(0xFFFFE500), // Yellow
  ];

  Color _currentColor = const Color(0xFF00D9FF); // Start with Cyan

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _autoRotationX = _controller.value * 2 * math.pi * 0.1;
        _autoRotationY = _controller.value * 2 * math.pi * 0.15;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeColor() {
    setState(() {
      _currentColor = _logoColors[math.Random().nextInt(_logoColors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeColor,
      onPanUpdate: (details) {
        setState(() {
          _rotationX += details.delta.dy * 0.01;
          _rotationY += details.delta.dx * 0.01;
        });
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _PolyhedronPainter(
          rotationX: _rotationX + _autoRotationX,
          rotationY: _rotationY + _autoRotationY,
          color: _currentColor,
        ),
      ),
    );
  }
}

class _PolyhedronPainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final Color color;

  _PolyhedronPainter({
    required this.rotationX,
    required this.rotationY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;

    // Icosahedron vertices
    final t = (1.0 + math.sqrt(5.0)) / 2.0;
    final vertices = <_Vector3>[
      _Vector3(-1, t, 0),
      _Vector3(1, t, 0),
      _Vector3(-1, -t, 0),
      _Vector3(1, -t, 0),
      _Vector3(0, -1, t),
      _Vector3(0, 1, t),
      _Vector3(0, -1, -t),
      _Vector3(0, 1, -t),
      _Vector3(t, 0, -1),
      _Vector3(t, 0, 1),
      _Vector3(-t, 0, -1),
      _Vector3(-t, 0, 1),
    ];

    // Normalize
    for (var i = 0; i < vertices.length; i++) {
      final v = vertices[i];
      final length = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
      vertices[i] = _Vector3(
        v.x / length * radius,
        v.y / length * radius,
        v.z / length * radius,
      );
    }

    // Rotate
    final rotatedVertices = vertices.map((v) {
      return _rotateY(_rotateX(v, rotationX), rotationY);
    }).toList();

    // Faces
    final faces = [
      [0, 11, 5],
      [0, 5, 1],
      [0, 1, 7],
      [0, 7, 10],
      [0, 10, 11],
      [1, 5, 9],
      [5, 11, 4],
      [11, 10, 2],
      [10, 7, 6],
      [7, 1, 8],
      [3, 9, 4],
      [3, 4, 2],
      [3, 2, 6],
      [3, 6, 8],
      [3, 8, 9],
      [4, 9, 5],
      [2, 4, 11],
      [6, 2, 10],
      [8, 6, 7],
      [9, 8, 1],
    ];

    // Sort faces
    final sortedFaces = List<List<int>>.from(faces);
    sortedFaces.sort((a, b) {
      final avgZA =
          (rotatedVertices[a[0]].z +
              rotatedVertices[a[1]].z +
              rotatedVertices[a[2]].z) /
          3;
      final avgZB =
          (rotatedVertices[b[0]].z +
              rotatedVertices[b[1]].z +
              rotatedVertices[b[2]].z) /
          3;
      return avgZA.compareTo(avgZB);
    });

    // Paint definitions
    final facePaint = Paint()
      ..color = const Color(0xFF050A10)
          .withValues(alpha: 0.9) // Very dark, almost opaque faces
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw
    for (final face in sortedFaces) {
      final v1 = rotatedVertices[face[0]];
      final v2 = rotatedVertices[face[1]];
      final v3 = rotatedVertices[face[2]];

      // Normal calculation for backface culling
      final edge1X = v2.x - v1.x;
      final edge1Y = v2.y - v1.y;
      final edge2X = v3.x - v1.x;
      final edge2Y = v3.y - v1.y;
      final normalZ = edge1X * edge2Y - edge1Y * edge2X;

      if (normalZ > 0) {
        final path = Path()
          ..moveTo(center.dx + v1.x, center.dy + v1.y)
          ..lineTo(center.dx + v2.x, center.dy + v2.y)
          ..lineTo(center.dx + v3.x, center.dy + v3.y)
          ..close();

        // Draw face (dark body)
        canvas.drawPath(path, facePaint);

        // Draw subtle highlight on face based on angle
        // This gives the "solid" look
        final highlightPaint = Paint()
          ..color = color.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, highlightPaint);

        // Draw edges
        canvas.drawPath(path, edgePaint);
      }
    }

    // Draw glowing vertices
    for (final v in rotatedVertices) {
      final zScale = (v.z + radius) / (2 * radius);
      if (zScale < 0.2) continue; // Don't draw vertices that are too far back

      final opacity = 0.5 + 0.5 * zScale;
      final pos = Offset(center.dx + v.x, center.dy + v.y);

      // Glow
      canvas.drawCircle(
        pos,
        8 * zScale,
        Paint()
          ..color = color.withValues(alpha: opacity * 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );

      // Core
      canvas.drawCircle(
        pos,
        3 * zScale,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  _Vector3 _rotateX(_Vector3 v, double angle) {
    final y = v.y * math.cos(angle) - v.z * math.sin(angle);
    final z = v.y * math.sin(angle) + v.z * math.cos(angle);
    return _Vector3(v.x, y, z);
  }

  _Vector3 _rotateY(_Vector3 v, double angle) {
    final x = v.x * math.cos(angle) + v.z * math.sin(angle);
    final z = -v.x * math.sin(angle) + v.z * math.cos(angle);
    return _Vector3(x, v.y, z);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Vector3 {
  final double x, y, z;
  _Vector3(this.x, this.y, this.z);
}
