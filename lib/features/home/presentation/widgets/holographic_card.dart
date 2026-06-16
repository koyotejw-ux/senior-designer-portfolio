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
              Text(
                title!,
                style: TextStyle(
                  color: accentColor,
                  fontFamily: 'Courier',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
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

    // 2. Simple Rectangular Outer Border (Thinner: 0.5)
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRect(
      Rect.fromLTRB(padding, padding, w - padding, h - padding),
      borderPaint,
    );

    // 3. Accent Corner Line Ticks (Thinner: 0.6)
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const tickLength = 12.0;
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
  }

  @override
  bool shouldRepaint(covariant _TechHudBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
