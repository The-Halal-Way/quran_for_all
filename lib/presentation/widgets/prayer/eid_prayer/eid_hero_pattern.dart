import 'package:flutter/material.dart';

class EidHeroPattern extends CustomPainter {
  const EidHeroPattern({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final center = Offset(size.width + 20, 14);
    for (final radius in [92.0, 150.0, 220.0]) {
      canvas.drawCircle(center, radius, line);
    }
    for (var x = 28.0; x < size.width; x += 67) {
      canvas.drawCircle(
        Offset(x, size.height - 17),
        1.8,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EidHeroPattern oldDelegate) =>
      oldDelegate.color != color;
}
