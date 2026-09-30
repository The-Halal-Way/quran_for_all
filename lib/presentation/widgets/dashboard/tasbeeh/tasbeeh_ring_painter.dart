import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tasbeeh_visuals.dart';

class TasbeehRingPainter extends CustomPainter {
  const TasbeehRingPainter({required this.progress, required this.onHero});

  final double progress;
  final bool onHero;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    final ring = Rect.fromCircle(center: center, radius: radius - 12);
    final trackColor = onHero
        ? Colors.white.withValues(alpha: 0.14)
        : const Color(0xFF625BF6).withValues(alpha: 0.12);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor.withValues(alpha: onHero ? 0.6 : 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawArc(
      ring,
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );

    for (var index = 0; index < 48; index++) {
      final angle = index * math.pi / 24 - math.pi / 2;
      final major = index % 4 == 0;
      final inner = radius - (major ? 3 : 1);
      final outer = radius + (major ? 4 : 2);
      canvas.drawLine(
        center + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
        center + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
        Paint()
          ..color = onHero
              ? Colors.white.withValues(alpha: major ? 0.5 : 0.2)
              : const Color(0xFF625BF6).withValues(alpha: major ? 0.45 : 0.16)
          ..strokeWidth = major ? 1.5 : 1,
      );
    }

    if (progress <= 0) return;
    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      ring,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: math.pi * 3 / 2,
          colors: [
            TasbeehVisuals.gold,
            TasbeehVisuals.mint,
            TasbeehVisuals.gold,
          ],
        ).createShader(ring)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    final angle = -math.pi / 2 + sweep;
    final tip =
        center +
        Offset(
          math.cos(angle) * (radius - 12),
          math.sin(angle) * (radius - 12),
        );
    canvas.drawCircle(tip, 6, Paint()..color = TasbeehVisuals.gold);
    canvas.drawCircle(tip, 2.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant TasbeehRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.onHero != onHero;
}
