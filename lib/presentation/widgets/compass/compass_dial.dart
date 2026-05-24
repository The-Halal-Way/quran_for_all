import 'dart:math' as math;

import 'package:flutter/material.dart';

class CompassDial extends StatelessWidget {
  const CompassDial({
    super.key,
    required this.heading,
    required this.qiblaDegrees,
    required this.facingMecca,
    required this.isDark,
  });

  final double heading;
  final double qiblaDegrees;
  final bool facingMecca;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const size = 290.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CompassPainter(
          heading: heading,
          qiblaDegrees: qiblaDegrees,
          facingMecca: facingMecca,
          isDark: isDark,
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  CompassPainter({
    required this.heading,
    required this.qiblaDegrees,
    required this.facingMecca,
    required this.isDark,
  });

  final double heading;
  final double qiblaDegrees;
  final bool facingMecca;
  final bool isDark;

  Color get _ringBg =>
      isDark ? const Color(0xFF1D1238) : const Color(0xFFEEE8FA);
  Color get _innerBg =>
      isDark ? const Color(0xFF120A2B) : const Color(0xFFF5F2FF);
  Color get _borderLight =>
      isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
  Color get _primaryColor => const Color(0xFF1E0A3C);
  Color get _primaryLight => const Color(0xFF4B30A1);
  Color get _fuchsia => const Color(0xFFD50057);
  Color get _fuchsiaLight => const Color(0xFFFF4081);
  Color get _teal => const Color(0xFF00BFA5);
  Color get _tealLight => const Color(0xFF64FFDA);
  Color get _cardinalText =>
      isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24);
  Color get _mutedText =>
      isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final dialR = outerR - 8;
    final innerR = outerR - 58;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-heading * math.pi / 180);
    canvas.translate(-cx, -cy);

    _drawOuterRings(canvas, cx, cy, outerR, dialR);
    _drawTicks(canvas, cx, cy, dialR);
    _drawCardinalLabels(canvas, cx, cy, dialR);
    _drawQiblaMarker(canvas, cx, cy, dialR, innerR);
    _drawInnerFace(canvas, cx, cy, innerR);

    canvas.restore();

    _drawNeedle(canvas, cx, cy, innerR);
    _drawCenterJewel(canvas, cx, cy);
    _drawTopPointer(canvas, cx);
  }

  void _drawOuterRings(
    Canvas c,
    double cx,
    double cy,
    double outerR,
    double dialR,
  ) {
    c.drawCircle(
      Offset(cx, cy),
      outerR,
      Paint()..color = _primaryColor.withValues(alpha: isDark ? 0.6 : 0.08),
    );
    c.drawCircle(Offset(cx, cy), dialR, Paint()..color = _ringBg);
    c.drawCircle(
      Offset(cx, cy),
      dialR,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    c.drawCircle(
      Offset(cx, cy),
      dialR - 12,
      Paint()
        ..color = _borderLight.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  void _drawTicks(Canvas c, double cx, double cy, double dialR) {
    for (var i = 0; i < 72; i++) {
      final angleDeg = i * 5.0;
      final angleRad = (angleDeg - 90) * math.pi / 180;
      final isCardinal = angleDeg % 90 == 0;
      final isOrdinal = angleDeg % 45 == 0 && !isCardinal;
      final isMid = angleDeg % 15 == 0 && !isCardinal && !isOrdinal;

      final tickOuter = dialR - 2;
      final tickInner = isCardinal
          ? dialR - 20
          : isOrdinal
          ? dialR - 15
          : isMid
          ? dialR - 11
          : dialR - 7;

      final strokeW = isCardinal
          ? 2.5
          : isOrdinal
          ? 1.8
          : isMid
          ? 1.2
          : 0.7;
      final color = isCardinal
          ? _fuchsia
          : isOrdinal
          ? _primaryLight
          : _borderLight;

      final x1 = cx + tickOuter * math.cos(angleRad);
      final y1 = cy + tickOuter * math.sin(angleRad);
      final x2 = cx + tickInner * math.cos(angleRad);
      final y2 = cy + tickInner * math.sin(angleRad);

      c.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = color
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawCardinalLabels(Canvas c, double cx, double cy, double dialR) {
    final labelR = dialR - 34;
    const cardinals = ['N', 'E', 'S', 'W'];
    const ordinals = ['NE', 'SE', 'SW', 'NW'];

    for (var i = 0; i < 4; i++) {
      final angleDeg = i * 90.0 - 90;
      final angleRad = angleDeg * math.pi / 180;
      final x = cx + labelR * math.cos(angleRad);
      final y = cy + labelR * math.sin(angleRad);

      final isNorth = i == 0;
      final tp = TextPainter(
        text: TextSpan(
          text: cardinals[i],
          style: TextStyle(
            fontFamily: 'Sora',
            fontSize: isNorth ? 17 : 14,
            fontWeight: FontWeight.w700,
            color: isNorth ? _fuchsia : _cardinalText,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(c, Offset(x - tp.width / 2, y - tp.height / 2));

      final oAngleDeg = i * 90.0 + 45 - 90;
      final oAngleRad = oAngleDeg * math.pi / 180;
      final ox = cx + (labelR - 6) * math.cos(oAngleRad);
      final oy = cy + (labelR - 6) * math.sin(oAngleRad);
      final oTp = TextPainter(
        text: TextSpan(
          text: ordinals[i],
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: _mutedText,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      oTp.paint(c, Offset(ox - oTp.width / 2, oy - oTp.height / 2));
    }
  }

  void _drawQiblaMarker(
    Canvas c,
    double cx,
    double cy,
    double dialR,
    double innerR,
  ) {
    final angleRad = (qiblaDegrees - 90) * math.pi / 180;
    final glowR = dialR - 30;
    final glowX = cx + glowR * math.cos(angleRad);
    final glowY = cy + glowR * math.sin(angleRad);

    c.drawCircle(
      Offset(glowX, glowY),
      18,
      Paint()
        ..color = _teal.withValues(alpha: facingMecca ? 0.30 : 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final lineStartX = cx + innerR * math.cos(angleRad);
    final lineStartY = cy + innerR * math.sin(angleRad);
    final lineEndX = cx + (dialR - 46) * math.cos(angleRad);
    final lineEndY = cy + (dialR - 46) * math.sin(angleRad);

    _drawDashedLine(
      c,
      Offset(lineStartX, lineStartY),
      Offset(lineEndX, lineEndY),
      Paint()
        ..color = _teal.withValues(alpha: 0.6)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
      dashLength: 4,
      gapLength: 4,
    );

    c.save();
    c.translate(glowX, glowY);
    c.rotate(angleRad + math.pi / 2);

    final arrowPaint = Paint()
      ..color = facingMecca ? _tealLight : _teal
      ..style = PaintingStyle.fill;
    final arrowPath = Path()
      ..moveTo(0, -14)
      ..lineTo(-8, 4)
      ..lineTo(0, 0)
      ..lineTo(8, 4)
      ..close();
    c.drawPath(arrowPath, arrowPaint);

    final kaabaRect = Rect.fromCenter(
      center: const Offset(0, 10),
      width: 12,
      height: 12,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(kaabaRect, const Radius.circular(2)),
      Paint()..color = facingMecca ? _tealLight : _teal,
    );
    c.drawLine(
      const Offset(0, 6),
      const Offset(0, 16),
      Paint()
        ..color = isDark ? const Color(0xFF060118) : Colors.white
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    c.restore();

    final labelR = dialR - 8;
    final labelX = cx + labelR * math.cos(angleRad);
    final labelY = cy + labelR * math.sin(angleRad);
    final meccaTp = TextPainter(
      text: TextSpan(
        text: 'Mecca',
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: _teal,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    meccaTp.paint(
      c,
      Offset(labelX - meccaTp.width / 2, labelY - meccaTp.height / 2),
    );
  }

  void _drawInnerFace(Canvas c, double cx, double cy, double innerR) {
    c.drawCircle(Offset(cx, cy), innerR, Paint()..color = _innerBg);
    final dashPaint = Paint()
      ..color = _teal.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _drawDashedCircle(
      c,
      Offset(cx, cy),
      innerR,
      dashPaint,
      dashLength: 6,
      gapLength: 8,
    );

    c.drawCircle(
      Offset(cx, cy),
      innerR,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  void _drawNeedle(Canvas c, double cx, double cy, double innerR) {
    const needleW = 7.0;
    final northLen = innerR * 0.72;
    final southLen = innerR * 0.72;

    final northPath = Path()
      ..moveTo(cx, cy - northLen)
      ..lineTo(cx - needleW, cy)
      ..lineTo(cx + needleW, cy)
      ..close();
    c.drawPath(northPath, Paint()..color = _fuchsia);

    final northShine = Path()
      ..moveTo(cx, cy - northLen)
      ..lineTo(cx - needleW * 0.4, cy)
      ..lineTo(cx, cy - northLen * 0.3)
      ..close();
    c.drawPath(
      northShine,
      Paint()..color = _fuchsiaLight.withValues(alpha: 0.4),
    );

    final southPath = Path()
      ..moveTo(cx, cy + southLen)
      ..lineTo(cx - needleW, cy)
      ..lineTo(cx + needleW, cy)
      ..close();
    c.drawPath(
      southPath,
      Paint()
        ..color = isDark ? const Color(0xFF261A45) : const Color(0xFFD9D1E8),
    );
    c.drawPath(
      southPath,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  void _drawCenterJewel(Canvas c, double cx, double cy) {
    c.drawCircle(
      Offset(cx, cy),
      13,
      Paint()
        ..color = isDark ? const Color(0xFF261A45) : const Color(0xFFEEE8FA),
    );
    c.drawCircle(
      Offset(cx, cy),
      13,
      Paint()
        ..color = _primaryLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    c.drawCircle(Offset(cx, cy), 6, Paint()..color = _fuchsia);
    c.drawCircle(
      Offset(cx - 2, cy - 2),
      2.5,
      Paint()..color = _fuchsiaLight.withValues(alpha: 0.6),
    );
  }

  void _drawTopPointer(Canvas c, double cx) {
    final path = Path()
      ..moveTo(cx, 4)
      ..lineTo(cx - 8, 20)
      ..lineTo(cx + 8, 20)
      ..close();
    c.drawPath(path, Paint()..color = _fuchsia.withValues(alpha: 0.9));
  }

  void _drawDashedLine(
    Canvas c,
    Offset start,
    Offset end,
    Paint paint, {
    double dashLength = 5,
    double gapLength = 5,
  }) {
    final total = (end - start).distance;
    final dir = (end - start) / total;
    var drawn = 0.0;
    var drawing = true;
    while (drawn < total) {
      final len = drawing ? dashLength : gapLength;
      final next = drawn + len;
      if (drawing) {
        c.drawLine(
          start + dir * drawn,
          start + dir * math.min(next, total),
          paint,
        );
      }
      drawn = next;
      drawing = !drawing;
    }
  }

  void _drawDashedCircle(
    Canvas c,
    Offset center,
    double radius,
    Paint paint, {
    double dashLength = 6,
    double gapLength = 6,
  }) {
    final circumference = 2 * math.pi * radius;
    final total = dashLength + gapLength;
    final count = (circumference / total).floor();
    final actualDash = (dashLength / total) * (2 * math.pi / count);
    final actualGap = (2 * math.pi / count) - actualDash;

    for (var i = 0; i < count; i++) {
      final startAngle = i * (actualDash + actualGap) - math.pi / 2;
      c.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        actualDash,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) {
    return oldDelegate.heading != heading ||
        oldDelegate.facingMecca != facingMecca ||
        oldDelegate.isDark != isDark ||
        oldDelegate.qiblaDegrees != qiblaDegrees;
  }
}
