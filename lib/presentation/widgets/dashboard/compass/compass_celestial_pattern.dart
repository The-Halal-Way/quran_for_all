import 'package:flutter/material.dart';

class CompassCelestialPattern extends StatelessWidget {
  const CompassCelestialPattern({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _StarsPainter());
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.16);
    for (final point in const [
      Offset(0.12, 0.18),
      Offset(0.88, 0.16),
      Offset(0.82, 0.32),
      Offset(0.15, 0.72),
      Offset(0.91, 0.81),
      Offset(0.08, 0.91),
    ]) {
      canvas.drawCircle(
        Offset(point.dx * size.width, point.dy * size.height),
        1.6,
        paint,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.08),
      size.width * 0.25,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => false;
}
