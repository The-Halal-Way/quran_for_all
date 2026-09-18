import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashBackdrop extends StatelessWidget {
  const SplashBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF09021D),
                  Color(0xFF251054),
                  Color(0xFF61145B),
                ],
                stops: [0, 0.54, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Positioned(
            top: -180,
            right: -160,
            child: _GlowOrb(
              size: 430,
              colors: [Color(0x8864FFDA), Color(0x0064FFDA)],
            ),
          ),
          const Positioned(
            left: -210,
            bottom: -190,
            child: _GlowOrb(
              size: 500,
              colors: [Color(0x66FF4081), Color(0x00FF4081)],
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _SplashPatternPainter()),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.05),
                    radius: 0.85,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF080118).withValues(alpha: 0.24),
                    ],
                    stops: const [0.5, 1],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: colors),
    ),
  );
}

class _SplashPatternPainter extends CustomPainter {
  const _SplashPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.055);
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.16);

    const gap = 64.0;
    for (var row = -1; row <= (size.height / gap).ceil(); row++) {
      for (var column = -1; column <= (size.width / gap).ceil(); column++) {
        final offset = row.isEven ? 0.0 : gap / 2;
        final center = Offset(column * gap + offset, row * gap);
        _drawEightPointStar(canvas, center, 8, linePaint);
        if ((row + column) % 3 == 0) {
          canvas.drawCircle(center, 1.2, dotPaint);
        }
      }
    }

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.07);
    final orbitCenter = Offset(size.width * 0.82, size.height * 0.18);
    for (final radius in [72.0, 108.0, 148.0]) {
      canvas.drawCircle(orbitCenter, radius, orbitPaint);
    }

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF64FFDA).withValues(alpha: 0.11);
    final sweepRect = Rect.fromCenter(
      center: Offset(size.width * 0.15, size.height * 0.82),
      width: size.width * 1.15,
      height: size.width * 1.15,
    );
    canvas.drawArc(
      sweepRect,
      math.pi * 1.08,
      math.pi * 0.68,
      false,
      sweepPaint,
    );
  }

  void _drawEightPointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    for (var index = 0; index < 16; index++) {
      final angle = -math.pi / 2 + index * math.pi / 8;
      final pointRadius = index.isEven ? radius : radius * 0.38;
      final point = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
