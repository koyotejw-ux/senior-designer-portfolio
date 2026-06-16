import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HolographicCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color accentColor;

  const HolographicCard({
    super.key,
    required this.child,
    this.title,
    this.accentColor = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TechHudBorderPainter(
        color: accentColor,
        animationValue: 0.0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF04060A).withValues(alpha: 0.75), // Deep space semi-transparent
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  // Target Node Indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title!,
                    style: TextStyle(
                      color: accentColor,
                      fontFamily: 'Courier',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  // Tech Line ticks
                  Container(
                    width: 50,
                    height: 2,
                    color: accentColor.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    color: accentColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _TechHudBorderPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _TechHudBorderPainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const padding = 1.0;

    // 1. Simple Flat Background Plane
    final bgPaint = Paint()
      ..color = const Color(0xFF050811).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Simple Rectangular Outer Border
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(
      Rect.fromLTRB(padding, padding, w - padding, h - padding),
      borderPaint,
    );

    // 3. Rectangular Point Markers (Tiny Solid Square Nodes at 4 Corners)
    final nodePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const nodeSize = 5.0;

    final corners = [
      Offset(padding, padding),
      Offset(w - padding, padding),
      Offset(w - padding, h - padding),
      Offset(padding, h - padding),
    ];

    for (final corner in corners) {
      canvas.drawRect(
        Rect.fromCenter(center: corner, width: nodeSize, height: nodeSize),
        nodePaint,
      );
    }

    // 4. Accent Corner Line Ticks (Simple Tech lines along borders)
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const tickLength = 16.0;
    // Top-left tick
    canvas.drawLine(Offset(padding, padding), Offset(padding + tickLength, padding), linePaint);
    canvas.drawLine(Offset(padding, padding), Offset(padding, padding + tickLength), linePaint);

    // Top-right tick
    canvas.drawLine(Offset(w - padding, padding), Offset(w - padding - tickLength, padding), linePaint);
    canvas.drawLine(Offset(w - padding, padding), Offset(w - padding, padding + tickLength), linePaint);

    // Bottom-right tick
    canvas.drawLine(Offset(w - padding, h - padding), Offset(w - padding - tickLength, h - padding), linePaint);
    canvas.drawLine(Offset(w - padding, h - padding), Offset(w - padding, h - padding - tickLength), linePaint);

    // Bottom-left tick
    canvas.drawLine(Offset(padding, h - padding), Offset(padding + tickLength, h - padding), linePaint);
    canvas.drawLine(Offset(padding, h - padding), Offset(padding, h - padding - tickLength), linePaint);

    // 5. Draw Sci-Fi HUD telemetry labels
    final textStyle = TextStyle(
      color: color.withValues(alpha: 0.5),
      fontFamily: 'Courier',
      fontSize: 8.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );

    // Left Telemetry Label
    final leftPainter = TextPainter(
      text: TextSpan(text: '[SYS_SEC.0x8F]', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    // Offset slightly above the bottom line, next to the tick
    leftPainter.paint(
      canvas,
      Offset(padding + 24.0, h - padding - leftPainter.height - 2.0),
    );

    // Right Telemetry Label
    final rightPainter = TextPainter(
      text: TextSpan(text: '[STATUS.ACTIVE]', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    rightPainter.paint(
      canvas,
      Offset(w - padding - 24.0 - rightPainter.width, h - padding - rightPainter.height - 2.0),
    );
  }

  @override
  bool shouldRepaint(covariant _TechHudBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
