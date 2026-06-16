import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          color: const Color(0xFF04060A).withValues(alpha: 0.12), // Highly transparent glass overlay
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.accentCyan,
                    Color(0xFFFF007F), // Neon Pink matching the hero name
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900, // Pretendard Black
                    letterSpacing: 0.5,
                  ),
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

    // 1. Simple Flat Background Plane (Faint: 0.08)
    final bgPaint = Paint()
      ..color = const Color(0xFF050811).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. High-Tech Digital Document Bracket Borders (Straight lines with dashed endpoints: - ────────── -)
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const dashLength = 12.0;
    const gap = 6.0;

    // Top border and dashes
    canvas.drawLine(Offset(0, padding), Offset(dashLength, padding), dashPaint);
    canvas.drawLine(Offset(dashLength + gap, padding), Offset(w - dashLength - gap, padding), borderPaint);
    canvas.drawLine(Offset(w - dashLength, padding), Offset(w, padding), dashPaint);

    // Bottom border and dashes
    canvas.drawLine(Offset(0, h - padding), Offset(dashLength, h - padding), dashPaint);
    canvas.drawLine(Offset(dashLength + gap, h - padding), Offset(w - dashLength - gap, h - padding), borderPaint);
    canvas.drawLine(Offset(w - dashLength, h - padding), Offset(w, h - padding), dashPaint);
  }

  @override
  bool shouldRepaint(covariant _TechHudBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
