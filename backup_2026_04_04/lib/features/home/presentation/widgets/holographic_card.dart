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
      painter: _HolographicBorderPainter(color: accentColor),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(
            0xFF050508,
          ).withValues(alpha: 0.6), // Semi-transparent dark
          // No standard border, using CustomPainter for HUD look
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  // Tech Icon
                  Container(width: 8, height: 8, color: accentColor),
                  const SizedBox(width: 12),
                  Text(
                    title!,
                    style: TextStyle(
                      color: accentColor,
                      fontFamily: 'Courier',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  // Decorative Line
                  Container(
                    width: 40,
                    height: 2,
                    color: accentColor.withValues(alpha: 0.5),
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

class _HolographicBorderPainter extends CustomPainter {
  final Color color;

  _HolographicBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final w = size.width;
    final h = size.height;
    final cornerSize = 20.0;

    // Top Left Corner
    path.moveTo(0, cornerSize);
    path.lineTo(0, 0);
    path.lineTo(cornerSize, 0);

    // Top Right Corner
    path.moveTo(w - cornerSize, 0);
    path.lineTo(w, 0);
    path.lineTo(w, cornerSize);

    // Bottom Right Corner
    path.moveTo(w, h - cornerSize);
    path.lineTo(w, h);
    path.lineTo(w - cornerSize, h);

    // Bottom Left Corner
    path.moveTo(cornerSize, h);
    path.lineTo(0, h);
    path.lineTo(0, h - cornerSize);

    // Draw Glow
    canvas.drawPath(path, glowPaint);
    // Draw Sharp Line
    canvas.drawPath(path, paint);

    // Subtle Grid Lines (Optional decoration)
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Top Line
    canvas.drawLine(
      Offset(cornerSize + 10, 0),
      Offset(w - cornerSize - 10, 0),
      gridPaint,
    );
    // Bottom Line
    canvas.drawLine(
      Offset(cornerSize + 10, h),
      Offset(w - cornerSize - 10, h),
      gridPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HolographicBorderPainter oldDelegate) => false;
}
