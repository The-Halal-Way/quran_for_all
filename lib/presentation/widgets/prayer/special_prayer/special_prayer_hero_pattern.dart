import 'package:flutter/material.dart';

class SpecialPrayerHeroPattern extends CustomPainter {
  const SpecialPrayerHeroPattern({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var index = 0; index < 5; index++) {
      final inset = 18.0 + index * 34;
      final rect = Rect.fromLTWH(
        size.width - inset - 180,
        -70 + index * 12,
        240 + index * 18,
        180 + index * 20,
      );
      canvas.drawArc(rect, 0.35, 2.8, false, paint);
    }

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    final path = Path()
      ..moveTo(-20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.50,
        size.width * 0.66,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.84,
        size.width + 28,
        size.height * 0.66,
      );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant SpecialPrayerHeroPattern oldDelegate) {
    return oldDelegate.color != color;
  }
}
