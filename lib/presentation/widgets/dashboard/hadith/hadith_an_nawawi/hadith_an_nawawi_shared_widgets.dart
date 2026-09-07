part of '../../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.isDark,
    required this.cardBg,
    required this.child,
    this.accentColor,
  });

  final bool isDark;
  final Color cardBg;
  final Color? accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderColor = accentColor ?? MyColors.primaryLight;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardBg, Color.lerp(cardBg, borderColor, 0.055)!],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: borderColor.withValues(alpha: isDark ? 0.20 : 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: isDark ? 0.08 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ArabicOrnament extends StatelessWidget {
  const _ArabicOrnament({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _OrnamentPainter(color: color),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  const _OrnamentPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawPolygon(canvas, paint, center, radius * 0.95, 8, -math.pi / 8);
    _drawPolygon(canvas, paint, center, radius * 0.65, 8, math.pi / 8);
    for (var index = 0; index < 8; index++) {
      final angle = (index * math.pi * 2 / 8) - math.pi / 8;
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * radius * 0.65,
          center.dy + math.sin(angle) * radius * 0.65,
        ),
        Offset(
          center.dx + math.cos(angle) * radius * 0.95,
          center.dy + math.sin(angle) * radius * 0.95,
        ),
        paint,
      );
    }
    canvas.drawCircle(center, radius * 0.18, paint);
  }

  void _drawPolygon(
    Canvas canvas,
    Paint paint,
    Offset center,
    double radius,
    int sides,
    double startAngle,
  ) {
    final path = Path();
    for (var index = 0; index <= sides; index++) {
      final angle = startAngle + (index * math.pi * 2 / sides);
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
  bool shouldRepaint(covariant _OrnamentPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
