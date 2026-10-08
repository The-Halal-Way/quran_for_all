import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A crescent and geometric rosette drawn without image downloads or assets.
class IslamicDaysArtwork extends StatelessWidget {
  const IslamicDaysArtwork({super.key, this.color = Colors.white});
  final Color color;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _OccasionArt(color)));
}

class _OccasionArt extends CustomPainter {
  const _OccasionArt(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width * .7, size.height * .45);
    final radius = math.min(size.width, size.height) * .28;
    final stroke = Paint()
      ..color = color.withValues(alpha: .17)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final factor in [1.1, 1.6, 2.1]) {
      canvas.drawCircle(centre, radius * factor, stroke);
    }
    for (var turn = 0; turn < 2; turn++) {
      final rosette = Path();
      for (var point = 0; point < 8; point++) {
        final angle = point * math.pi / 4 + turn * math.pi / 8;
        final x = centre.dx + math.cos(angle) * radius * 1.8;
        final y = centre.dy + math.sin(angle) * radius * 1.8;
        if (point == 0) {
          rosette.moveTo(x, y);
        } else {
          rosette.lineTo(x, y);
        }
      }
      canvas.drawPath(rosette..close(), stroke);
    }
    final disc = Path()
      ..addOval(Rect.fromCircle(center: centre, radius: radius));
    final cut = Path()
      ..addOval(
        Rect.fromCircle(
          center: centre + Offset(radius * .48, -radius * .2),
          radius: radius * .91,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, disc, cut),
      Paint()..color = color.withValues(alpha: .8),
    );
    for (final offset in [
      const Offset(.28, .2),
      const Offset(.89, .78),
      const Offset(.42, .85),
    ]) {
      final point = Offset(size.width * offset.dx, size.height * offset.dy);
      final star = Path()
        ..moveTo(point.dx, point.dy - 5)
        ..lineTo(point.dx + 2, point.dy - 2)
        ..lineTo(point.dx + 5, point.dy)
        ..lineTo(point.dx + 2, point.dy + 2)
        ..lineTo(point.dx, point.dy + 5)
        ..lineTo(point.dx - 2, point.dy + 2)
        ..lineTo(point.dx - 5, point.dy)
        ..lineTo(point.dx - 2, point.dy - 2)
        ..close();
      canvas.drawPath(star, Paint()..color = color.withValues(alpha: .65));
    }
  }

  @override
  bool shouldRepaint(covariant _OccasionArt oldDelegate) =>
      oldDelegate.color != color;
}
