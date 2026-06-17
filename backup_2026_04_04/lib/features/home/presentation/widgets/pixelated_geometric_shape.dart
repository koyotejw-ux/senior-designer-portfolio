import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PixelatedGeometricShape extends StatefulWidget {
  final double size;

  const PixelatedGeometricShape({super.key, this.size = 400});

  @override
  State<PixelatedGeometricShape> createState() =>
      _PixelatedGeometricShapeState();
}

class _PixelatedGeometricShapeState extends State<PixelatedGeometricShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  // Icosahedron Vertices (Golden Ratio)
  static const double t = 1.61803398875; // (1 + sqrt(5)) / 2
  final List<List<double>> _vertices = [
    [-1, t, 0],
    [1, t, 0],
    [-1, -t, 0],
    [1, -t, 0],
    [0, -1, t],
    [0, 1, t],
    [0, -1, -t],
    [0, 1, -t],
    [t, 0, -1],
    [t, 0, 1],
    [-t, 0, -1],
    [-t, 0, 1],
  ];

  // Icosahedron Faces (Indices of vertices)
  final List<List<int>> _faces = [
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _rotationX = _controller.value * 2 * math.pi;
        _rotationY = _controller.value * 2 * math.pi;
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
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _VoxelPolyhedronPainter(
        rotationX: _rotationX,
        rotationY: _rotationY,
        vertices: _vertices,
        faces: _faces,
      ),
    );
  }
}

class _VoxelPolyhedronPainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final List<List<double>> vertices;
  final List<List<int>> faces;

  _VoxelPolyhedronPainter({
    required this.rotationX,
    required this.rotationY,
    required this.vertices,
    required this.faces,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 5;
    final voxelSize = 6.0; // Size of each dot

    // Rotate Vertices
    final List<_ProjectedVertex> projectedVertices = [];
    for (int i = 0; i < vertices.length; i++) {
      final v = vertices[i];
      var x = v[0];
      var y = v[1];
      var z = v[2];

      // Rotate Y
      final cosY = math.cos(rotationY);
      final sinY = math.sin(rotationY);
      final x1 = x * cosY - z * sinY;
      final z1 = x * sinY + z * cosY;
      x = x1;
      z = z1;

      // Rotate X
      final cosX = math.cos(rotationX);
      final sinX = math.sin(rotationX);
      final y2 = y * cosX - z * sinX;
      final z2 = y * sinX + z * cosX;
      y = y2;
      z = z2;

      projectedVertices.add(_ProjectedVertex(i, x, y, z));
    }

    // Sort Faces by Depth (Z)
    final List<_ProjectedFace> projectedFaces = [];
    for (final face in faces) {
      final v1 = projectedVertices[face[0]];
      final v2 = projectedVertices[face[1]];
      final v3 = projectedVertices[face[2]];

      final avgZ = (v1.z + v2.z + v3.z) / 3;
      projectedFaces.add(_ProjectedFace(face, avgZ));
    }
    projectedFaces.sort((a, b) => a.z.compareTo(b.z));

    // Paints
    final facePaint = Paint()
      ..color = const Color(
        0xFF05101A,
      ).withValues(alpha: 0.9); // Dark solid face
    final edgePaint = Paint()
      ..color = AppColors.primaryBlue.withValues(
        alpha: 0.4,
      ); // Subtle Blue Edge
    final vertexPaint = Paint()..color = AppColors.accentCyan; // Cyan Vertices
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);

    // Draw Faces (Back to Front)
    for (final pFace in projectedFaces) {
      final v1 = projectedVertices[pFace.indices[0]];
      final v2 = projectedVertices[pFace.indices[1]];
      final v3 = projectedVertices[pFace.indices[2]];

      // Back-face culling (simple normal check)
      final normalZ =
          (v2.x - v1.x) * (v3.y - v1.y) - (v2.y - v1.y) * (v3.x - v1.x);

      if (normalZ > 0) {
        // Draw Face (Voxel Grid Fill)
        _drawVoxelFace(canvas, center, v1, v2, v3, scale, voxelSize, facePaint);

        // Draw Edges (Voxel Line)
        _drawVoxelLine(canvas, center, v1, v2, scale, voxelSize, edgePaint);
        _drawVoxelLine(canvas, center, v2, v3, scale, voxelSize, edgePaint);
        _drawVoxelLine(canvas, center, v3, v1, scale, voxelSize, edgePaint);
      }
    }

    // Draw Vertices (Glowing Dots)
    for (final v in projectedVertices) {
      if (v.z > -0.5) {
        // Only draw front-ish vertices
        final px = center.dx + v.x * scale;
        final py = center.dy + v.y * scale;

        // Glow
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(px, py),
            width: voxelSize * 3,
            height: voxelSize * 3,
          ),
          Paint()..color = AppColors.accentCyan.withValues(alpha: 0.3),
        );

        // Core
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(px, py),
            width: voxelSize * 1.5,
            height: voxelSize * 1.5,
          ),
          vertexPaint,
        );

        // Highlight
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(px, py),
            width: voxelSize * 0.8,
            height: voxelSize * 0.8,
          ),
          highlightPaint,
        );
      }
    }
  }

  void _drawVoxelLine(
    Canvas canvas,
    Offset center,
    _ProjectedVertex v1,
    _ProjectedVertex v2,
    double scale,
    double voxelSize,
    Paint paint,
  ) {
    final p1 = Offset(center.dx + v1.x * scale, center.dy + v1.y * scale);
    final p2 = Offset(center.dx + v2.x * scale, center.dy + v2.y * scale);

    final dist = (p2 - p1).distance;
    final steps = (dist / (voxelSize * 0.8)).ceil();

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final pos = Offset.lerp(p1, p2, t)!;
      canvas.drawRect(
        Rect.fromCenter(center: pos, width: voxelSize, height: voxelSize),
        paint,
      );
    }
  }

  void _drawVoxelFace(
    Canvas canvas,
    Offset center,
    _ProjectedVertex v1,
    _ProjectedVertex v2,
    _ProjectedVertex v3,
    double scale,
    double voxelSize,
    Paint paint,
  ) {
    // Simple scanline or grid fill for the triangle would be expensive in pure Dart for voxels.
    // Instead, we'll draw a solid path but with a "pixelated" shader or just a solid color for now to ensure performance,
    // as drawing thousands of rects for faces might lag.
    // To keep the "Voxel" look, we can use a pattern.

    final path = Path()
      ..moveTo(center.dx + v1.x * scale, center.dy + v1.y * scale)
      ..lineTo(center.dx + v2.x * scale, center.dy + v2.y * scale)
      ..lineTo(center.dx + v3.x * scale, center.dy + v3.y * scale)
      ..close();

    canvas.drawPath(path, paint);

    // Overlay a grid pattern to simulate voxels on the face
    // (Optional optimization: only draw if needed)
  }

  @override
  bool shouldRepaint(covariant _VoxelPolyhedronPainter oldDelegate) => true;
}

class _ProjectedVertex {
  final int index;
  final double x;
  final double y;
  final double z;

  _ProjectedVertex(this.index, this.x, this.y, this.z);
}

class _ProjectedFace {
  final List<int> indices;
  final double z;

  _ProjectedFace(this.indices, this.z);
}
