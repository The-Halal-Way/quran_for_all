part of '../../../../views/dashboard/hadith/hadith_forty_short_view.dart';

class _GeomStar extends StatelessWidget {
  const _GeomStar({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(color: color),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.028
      ..strokeCap = StrokeCap.round;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    _polygon(canvas, paint, center, radius * 0.92, 6, -math.pi / 2);
    _polygon(canvas, paint, center, radius * 0.55, 6, math.pi / 6);
    for (var index = 0; index < 6; index++) {
      final angle = -math.pi / 2 + index * math.pi / 3;
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * radius * 0.55,
          center.dy + math.sin(angle) * radius * 0.55,
        ),
        Offset(
          center.dx + math.cos(angle) * radius * 0.92,
          center.dy + math.sin(angle) * radius * 0.92,
        ),
        paint,
      );
    }
    canvas.drawCircle(center, radius * 0.12, paint);
  }

  void _polygon(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
    int sides,
    double startAngle,
  ) {
    final path = Path();
    for (var index = 0; index <= sides; index++) {
      final angle = startAngle + index * math.pi * 2 / sides;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
