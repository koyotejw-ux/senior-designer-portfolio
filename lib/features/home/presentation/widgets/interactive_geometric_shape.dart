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
  double _rotationX = 0.3; // Slight tilt
  double _rotationY = 0.5;
  double _autoRotationSpeed = 0.005;

  // Hover/Tilt state
  double _targetHoverX = 0;
  double _targetHoverY = 0;
  double _currentHoverX = 0;
  double _currentHoverY = 0;

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
      duration: const Duration(seconds: 5),
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

    // Spawn packets/particles on drag
    _spawnParticles(details.localPosition, delta);

    setState(() {
      _rotationY += delta.dx * 0.008;
      _rotationX -= delta.dy * 0.008;
      _lastPanPos = details.localPosition;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _lastPanPos = null;
    setState(() {
      _autoRotationSpeed = 0.005; // Resume auto rotation
    });
  }

  void _handleHover(PointerEvent event) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final localPos = event.localPosition;
    
    setState(() {
      _targetHoverY = ((localPos.dx - center.dx) / center.dx).clamp(-1.0, 1.0) * 0.5;
      _targetHoverX = -((localPos.dy - center.dy) / center.dy).clamp(-1.0, 1.0) * 0.5;
    });

    if (_random.nextDouble() < 0.2) {
      _spawnParticles(
        localPos,
        Offset((_random.nextDouble() - 0.5) * 3, (_random.nextDouble() - 0.5) * 3),
      );
    }
  }

  void _handleHoverExit(PointerEvent event) {
    setState(() {
      _targetHoverX = 0;
      _targetHoverY = 0;
    });
  }

  void _spawnParticles(Offset position, Offset velocity) {
    for (int i = 0; i < 3; i++) {
      _particles.add(
        _Particle(
          position: position,
          velocity: Offset(
            velocity.dx * 0.2 + (_random.nextDouble() - 0.5) * 2,
            velocity.dy * 0.2 + (_random.nextDouble() - 0.5) * 2,
          ),
          color: [
            AppColors.primaryBlue,
            AppColors.highlightGreen,
            AppColors.accentCyan,
            const Color(0xFFFF007F),
          ][_random.nextInt(4)],
          size: _random.nextDouble() * 4 + 2,
          life: 1.0,
        ),
      );
    }
  }

  void _updateParticles() {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.position += p.velocity;
      p.life -= 0.018;
      p.velocity *= 0.95;
      p.size *= 0.96;

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _handleHover,
      onExit: _handleHoverExit,
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            _rotationY += _autoRotationSpeed;
            _rotationX += _autoRotationSpeed * 0.3;

            _currentHoverX = _currentHoverX + (_targetHoverX - _currentHoverX) * 0.08;
            _currentHoverY = _currentHoverY + (_targetHoverY - _currentHoverY) * 0.08;

            _updateParticles();

            final pulseScale = 1.0 + 0.03 * math.sin(_controller.value * 2 * math.pi);

            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _Rectilinear3DBoxPainter(
                rotationX: _rotationX + _currentHoverX,
                rotationY: _rotationY + _currentHoverY,
                particles: _particles,
                pulseScale: pulseScale,
                pulsePhase: _controller.value,
              ),
            );
          },
        ),
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

class _Rectilinear3DBoxPainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final List<_Particle> particles;
  final double pulseScale;
  final double pulsePhase;

  _Rectilinear3DBoxPainter({
    required this.rotationX,
    required this.rotationY,
    required this.particles,
    required this.pulseScale,
    required this.pulsePhase,
  });

  // Cube vertices (8 corners)
  static final List<vector.Vector3> cubeVertices = [
    vector.Vector3(-1, -1, -1),
    vector.Vector3(1, -1, -1),
    vector.Vector3(1, 1, -1),
    vector.Vector3(-1, 1, -1),
    vector.Vector3(-1, -1, 1),
    vector.Vector3(1, -1, 1),
    vector.Vector3(1, 1, 1),
    vector.Vector3(-1, 1, 1),
  ];

  // Cube edges connecting the 8 vertices
  static const List<List<int>> cubeEdges = [
    [0, 1], [1, 2], [2, 3], [3, 0], // Back face
    [4, 5], [5, 6], [6, 7], [7, 4], // Front face
    [0, 4], [1, 5], [2, 6], [3, 7], // Connecting edges
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (size.width * 0.32) * pulseScale;
    final innerRadius = outerRadius * 0.52;

    // Rotation Matrices
    final rotX = vector.Matrix4.rotationX(rotationX);
    final rotY = vector.Matrix4.rotationY(rotationY);
    final outerTransform = rotX * rotY;

    // Inner cube rotates in opposite direction to emphasize packet network depth
    final innerRotX = vector.Matrix4.rotationX(-rotationX * 1.3);
    final innerRotY = vector.Matrix4.rotationY(-rotationY * 1.5);
    final innerTransform = innerRotX * innerRotY;

    // Transform outer cube vertices
    final List<vector.Vector3> transOuter = cubeVertices.map((v) {
      final v4 = vector.Vector4(v.x, v.y, v.z, 1.0);
      final trans = outerTransform * v4;
      return vector.Vector3(trans.x, trans.y, trans.z)
        ..normalize()
        ..scale(outerRadius);
    }).toList();

    // Transform inner cube vertices
    final List<vector.Vector3> transInner = cubeVertices.map((v) {
      final v4 = vector.Vector4(v.x, v.y, v.z, 1.0);
      final trans = innerTransform * v4;
      return vector.Vector3(trans.x, trans.y, trans.z)
        ..normalize()
        ..scale(innerRadius);
    }).toList();

    // Draw background particles/noise first
    for (final p in particles) {
      canvas.drawRect(
        Rect.fromCenter(center: p.position, width: p.size, height: p.size),
        Paint()..color = p.color.withValues(alpha: p.life),
      );
    }

    // DRAW EDGES & DATA PACKETS (OUTER CUBE)
    final outerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final edge in cubeEdges) {
      final v1 = transOuter[edge[0]];
      final v2 = transOuter[edge[1]];
      final p1 = Offset(center.dx + v1.x, center.dy + v1.y);
      final p2 = Offset(center.dx + v2.x, center.dy + v2.y);

      final avgZ = (v1.z + v2.z) / 2;
      final depthScale = (avgZ + outerRadius * 2) / (outerRadius * 2);

      // Edge line gradient
      outerEdgePaint.color = AppColors.primaryBlue.withValues(alpha: 0.28 * depthScale);
      canvas.drawLine(p1, p2, outerEdgePaint);

      // ANIMATED PACKET: Flowing data packet sliding along the edge line
      final packetT = (pulsePhase + (edge[0] * 0.15)) % 1.0;
      final packetPos = Offset.lerp(p1, p2, packetT)!;

      // Packet node styling (glitch green / cyan glow)
      final packetColor = (edge[0] % 2 == 0) ? AppColors.accentCyan : AppColors.highlightGreen;
      canvas.drawCircle(
        packetPos,
        3.5 * depthScale,
        Paint()
          ..color = packetColor.withValues(alpha: 0.8 * depthScale)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
      canvas.drawCircle(
        packetPos,
        1.2 * depthScale,
        Paint()..color = Colors.white.withValues(alpha: 0.95),
      );
    }

    // DRAW EDGES & DATA PACKETS (INNER CUBE)
    final innerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (final edge in cubeEdges) {
      final v1 = transInner[edge[0]];
      final v2 = transInner[edge[1]];
      final p1 = Offset(center.dx + v1.x, center.dy + v1.y);
      final p2 = Offset(center.dx + v2.x, center.dy + v2.y);

      final avgZ = (v1.z + v2.z) / 2;
      final depthScale = (avgZ + innerRadius * 2) / (innerRadius * 2);

      // Inner edges color (pink/purple packet network)
      innerEdgePaint.color = const Color(0xFFFF007F).withValues(alpha: 0.22 * depthScale);
      canvas.drawLine(p1, p2, innerEdgePaint);

      // Inner animated packet
      final packetT = (pulsePhase * 1.5 + (edge[1] * 0.12)) % 1.0;
      final packetPos = Offset.lerp(p1, p2, packetT)!;

      canvas.drawCircle(
        packetPos,
        2.5 * depthScale,
        Paint()
          ..color = const Color(0xFFFF007F).withValues(alpha: 0.7 * depthScale)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }

    // INTER-CUBE TARGET CONNECTORS: Connect outer cube vertices to inner cube vertices
    // Creates a "target acquisition / packet bridge" GUI effect
    final connectorPaint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.1)
      ..strokeWidth = 0.6;
    for (int i = 0; i < 8; i++) {
      final op = Offset(center.dx + transOuter[i].x, center.dy + transOuter[i].y);
      final ip = Offset(center.dx + transInner[i].x, center.dy + transInner[i].y);
      canvas.drawLine(op, ip, connectorPaint);
    }

    // DRAW GLOWING NODES (OUTER VERTICES)
    for (int i = 0; i < transOuter.length; i++) {
      final v = transOuter[i];
      final offset = Offset(center.dx + v.x, center.dy + v.y);
      final scale = (v.z + outerRadius * 2) / (outerRadius * 2);
      final nodeSize = 10.0 * scale;

      // Assign point colors to nodes
      final nodeColor = [
        AppColors.accentCyan,
        AppColors.highlightGreen,
        const Color(0xFFFF007F),
        AppColors.primaryBlue,
      ][i % 4];

      // Draw Target Rect (Corner crosshair style for nodes)
      final rectPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.3 * scale)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRect(
        Rect.fromCenter(center: offset, width: nodeSize * 2.2, height: nodeSize * 2.2),
        rectPaint,
      );

      // Node core
      canvas.drawRect(
        Rect.fromCenter(center: offset, width: nodeSize, height: nodeSize),
        Paint()..color = nodeColor.withValues(alpha: 0.9),
      );

      // Glint white dot
      canvas.drawRect(
        Rect.fromCenter(
          center: offset - Offset(nodeSize * 0.15, nodeSize * 0.15),
          width: nodeSize * 0.3,
          height: nodeSize * 0.3,
        ),
        Paint()..color = Colors.white,
      );

      // Sci-fi Futuristic Vertex Label (Typing and fading effect)
      const vertexLabels = [
        "SYS.MES",
        "UX.STRAT",
        "AI.FLOW",
        "FIGMA.SYS",
        "B2B.ERP",
        "CROSS.INT",
        "UI.PROTO",
        "IoT.INTEG",
      ];
      final label = vertexLabels[i];
      final textPhase = (pulsePhase * 2.0 + (i * 0.25)) % 2.0;
      double opacity = 0.0;
      String visibleText = "";

      if (textPhase < 0.5) {
        final progress = textPhase / 0.5;
        final length = (label.length * progress).round();
        visibleText = label.substring(0, length);
        opacity = 0.8;
      } else if (textPhase < 1.3) {
        visibleText = label;
        opacity = 0.8;
      } else if (textPhase < 1.8) {
        final progress = (textPhase - 1.3) / 0.5;
        visibleText = label;
        opacity = (1.0 - progress) * 0.8;
      }

      if (visibleText.isNotEmpty && opacity > 0.05) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: visibleText,
            style: TextStyle(
              color: nodeColor.withValues(alpha: opacity * scale),
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, offset + const Offset(12, -10));
      }
    }

    // DRAW GLOWING NODES (INNER VERTICES)
    for (int i = 0; i < transInner.length; i++) {
      final v = transInner[i];
      final offset = Offset(center.dx + v.x, center.dy + v.y);
      final scale = (v.z + innerRadius * 2) / (innerRadius * 2);
      final nodeSize = 6.0 * scale;

      canvas.drawCircle(
        offset,
        nodeSize * 1.5,
        Paint()
          ..color = const Color(0xFFFF007F).withValues(alpha: 0.25 * scale)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(
        offset,
        nodeSize * 0.5,
        Paint()..color = Colors.white.withValues(alpha: 0.95),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Rectilinear3DBoxPainter oldDelegate) => true;
}
