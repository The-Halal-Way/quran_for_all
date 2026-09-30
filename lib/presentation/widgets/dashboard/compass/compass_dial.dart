import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

/// The rose pointer marks the top of the phone; the cyan ray marks Qibla.
class CompassDial extends StatelessWidget {
  const CompassDial({
    super.key,
    required this.heading,
    required this.qiblaDegrees,
    required this.facingMecca,
    required this.isLive,
  });

  final double heading;
  final double qiblaDegrees;
  final bool facingMecca;
  final bool isLive;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: CustomPaint(
      painter: _CompassDialPainter(
        heading: isLive ? heading : 0,
        bearing: qiblaDegrees,
        facingMecca: facingMecca,
        cardinalStyle: AppTheme.text(context).compassDialNorth,
        ordinalStyle: AppTheme.text(context).compassDialOrdinal,
      ),
    ),
  );
}

class _CompassDialPainter extends CustomPainter {
  const _CompassDialPainter({
    required this.heading,
    required this.bearing,
    required this.facingMecca,
    required this.cardinalStyle,
    required this.ordinalStyle,
  });

  final double heading;
  final double bearing;
  final bool facingMecca;
  final TextStyle cardinalStyle;
  final TextStyle ordinalStyle;

  static const _cyan = Color(0xFF65E4E5);
  static const _rose = Color(0xFFFF90B2);
  static const _gold = Color(0xFFF1D394);

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    canvas.save();
    canvas.translate((size.width - side) / 2, (size.height - side) / 2);
    canvas.scale(side / 320);
    const center = Offset(160, 160);

    canvas.drawCircle(
      center,
      154,
      Paint()..color = Colors.white.withValues(alpha: 0.055),
    );
    canvas.drawCircle(
      center,
      144,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF222D65), Color(0xFF111943)],
        ).createShader(const Rect.fromLTWH(16, 16, 288, 288)),
    );
    for (final radius in [144.0, 127.0, 93.0]) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white.withValues(alpha: radius == 144 ? 0.25 : 0.11)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    canvas.save();
    canvas.translate(160, 160);
    canvas.rotate(-heading * math.pi / 180);
    canvas.translate(-160, -160);
    _drawTicks(canvas);
    _drawLabels(canvas);
    _drawQibla(canvas);
    canvas.restore();

    final pointer = Path()
      ..moveTo(160, 11)
      ..lineTo(151, 32)
      ..lineTo(169, 32)
      ..close();
    canvas.drawPath(pointer, Paint()..color = _rose);

    canvas.drawCircle(
      center,
      58,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF373780), Color(0xFF1B2453)],
        ).createShader(const Rect.fromLTWH(102, 102, 116, 116)),
    );
    canvas.drawCircle(
      center,
      58,
      Paint()
        ..color = _gold.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    _drawKaaba(canvas);
    canvas.restore();
  }

  void _drawTicks(Canvas canvas) {
    for (var degree = 0; degree < 360; degree += 5) {
      final angle = (degree - 90) * math.pi / 180;
      final major = degree % 30 == 0;
      canvas.drawLine(
        Offset(
          160 + (major ? 129 : 136) * math.cos(angle),
          160 + (major ? 129 : 136) * math.sin(angle),
        ),
        Offset(160 + 141 * math.cos(angle), 160 + 141 * math.sin(angle)),
        Paint()
          ..color = Colors.white.withValues(alpha: major ? 0.72 : 0.25)
          ..strokeWidth = major ? 2 : 1
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawLabels(Canvas canvas) {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    for (var index = 0; index < labels.length; index++) {
      final angle = (index * 45 - 90) * math.pi / 180;
      final anchor = Offset(
        160 + 110 * math.cos(angle),
        160 + 110 * math.sin(angle),
      );
      final painter = TextPainter(
        text: TextSpan(
          text: labels[index],
          style: (index.isEven ? cardinalStyle : ordinalStyle).copyWith(
            color: index == 0 ? _rose : Colors.white.withValues(alpha: 0.78),
            fontSize: index.isEven ? 16 : 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        anchor - Offset(painter.width / 2, painter.height / 2),
      );
    }
  }

  void _drawQibla(Canvas canvas) {
    final angle = (bearing - 90) * math.pi / 180;
    final end = Offset(160 + 82 * math.cos(angle), 160 + 82 * math.sin(angle));
    for (final stroke in [18.0, 3.0]) {
      canvas.drawLine(
        const Offset(160, 160),
        end,
        Paint()
          ..color = stroke == 18 ? _cyan.withValues(alpha: 0.32) : _cyan
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.save();
    canvas.translate(end.dx, end.dy);
    canvas.rotate(angle + math.pi / 2);
    final tip = Path()
      ..moveTo(0, -19)
      ..lineTo(-12, 10)
      ..lineTo(0, 4)
      ..lineTo(12, 10)
      ..close();
    canvas.drawPath(tip, Paint()..color = facingMecca ? _gold : _cyan);
    canvas.restore();
  }

  void _drawKaaba(Canvas canvas) {
    final kaaba = RRect.fromRectAndRadius(
      const Rect.fromLTWH(139, 140, 42, 39),
      const Radius.circular(5),
    );
    canvas.drawRRect(kaaba, Paint()..color = const Color(0xFF0C1533));
    canvas.drawRRect(
      kaaba,
      Paint()
        ..color = _gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawRect(
      const Rect.fromLTWH(139, 149, 42, 5),
      Paint()..color = _gold,
    );
    canvas.drawRect(
      const Rect.fromLTWH(157, 160, 6, 19),
      Paint()..color = _gold.withValues(alpha: 0.65),
    );
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.heading != heading ||
      oldDelegate.bearing != bearing ||
      oldDelegate.facingMecca != facingMecca ||
      oldDelegate.cardinalStyle != cardinalStyle ||
      oldDelegate.ordinalStyle != ordinalStyle;
}
