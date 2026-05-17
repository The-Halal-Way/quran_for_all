import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/services/permission_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Replace with real Qibla calculation using user's lat/lng.
// Packages: `adhan`, `flutter_qibla`, or compute manually.
// 293° is a placeholder for Dhaka → Mecca.
// ─────────────────────────────────────────────────────────────────────────────
const double _kQiblaDegrees = 293.0;

// How close to Qibla (in degrees) to show the "on target" state
const double _kQiblaSnapZone = 5.0;

class CompassView extends StatefulWidget {
  const CompassView({super.key});

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  double _rawHeading = 0.0;     // latest value from sensor
  double _smoothHeading = 0.0;  // animated display value
  String _directionLabel = 'North';
  bool _isListening = false;

  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();

    // Drives the smooth-heading interpolation each frame
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(days: 999), // runs indefinitely
    )..addListener(_onTick)..forward();

    _initCompass();
  }

  void _onTick() {
    double diff = _rawHeading - _smoothHeading;
    // Shortest-path wrap
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    final next = _smoothHeading + diff * 0.10;
    if (mounted) {
      setState(() {
        _smoothHeading = (next + 360) % 360;
      });
    }
  }

  Future<void> _initCompass() async {
    await PermissionHelper().startCompassWithPermission(
      onHeadingChanged: (heading) {
        _rawHeading = (heading + 360) % 360;
      },
      onDirectionChanged: (direction) {
        if (mounted) setState(() => _directionLabel = direction);
      },
    );
    if (mounted) setState(() => _isListening = true);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  double get _qiblaOffset =>
      (_kQiblaDegrees - _smoothHeading + 360) % 360;

  bool get _facingMecca => _qiblaOffset < _kQiblaSnapZone ||
      _qiblaOffset > 360 - _kQiblaSnapZone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_isListening) {
      return Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF060118) : const Color(0xFFF5F2FF),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: isDark
                    ? const Color(0xFF4B30A1)
                    : const Color(0xFF1E0A3C),
              ),
              const SizedBox(height: 16),
              Text(
                'Initializing compass…',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  color: isDark
                      ? const Color(0xFFB39DDB)
                      : const Color(0xFF4C425C),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF060118) : const Color(0xFFF5F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(isDark: isDark, directionLabel: _directionLabel),
            const SizedBox(height: 8),
            _HeadingDisplay(
              heading: _smoothHeading,
              isDark: isDark,
              facingMecca: _facingMecca,
            ),
            const SizedBox(height: 4),
            _DirectionPill(label: _directionLabel, isDark: isDark),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _CompassDial(
                  heading: _smoothHeading,
                  qiblaDegrees: _kQiblaDegrees,
                  facingMecca: _facingMecca,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _InfoRow(
              heading: _smoothHeading,
              qiblaOffset: _qiblaOffset,
              facingMecca: _facingMecca,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark, required this.directionLabel});
  final bool isDark;
  final String directionLabel;

  @override
  Widget build(BuildContext context) {
    final cardBg =
        isDark ? const Color(0xFF1D1238) : const Color(0xFFFFFFFF);
    final borderC =
        isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final textPrimary =
        isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24);
    final textSecondary =
        isDark ? const Color(0xFF7E57C2) : const Color(0xFF4C425C);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compass',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00BFA5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Qibla direction active',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderC),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: isDark
                  ? const Color(0xFFB39DDB)
                  : const Color(0xFF4C425C),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADING NUMBER DISPLAY
// ─────────────────────────────────────────────────────────────────────────────
class _HeadingDisplay extends StatelessWidget {
  const _HeadingDisplay({
    required this.heading,
    required this.isDark,
    required this.facingMecca,
  });
  final double heading;
  final bool isDark;
  final bool facingMecca;

  @override
  Widget build(BuildContext context) {
    final numColor = facingMecca
        ? const Color(0xFF00BFA5)
        : (isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24));

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toStringAsFixed(0),
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: numColor,
              letterSpacing: -3,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '°',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF7E57C2)
                    : const Color(0xFF7A7288),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIRECTION PILL
// ─────────────────────────────────────────────────────────────────────────────
class _DirectionPill extends StatelessWidget {
  const _DirectionPill({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1238) : const Color(0xFFEEE8FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF382E54)
              : const Color(0xFFD9D1E8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPASS DIAL  (main visual — CustomPaint)
// ─────────────────────────────────────────────────────────────────────────────
class _CompassDial extends StatelessWidget {
  const _CompassDial({
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
        painter: _CompassPainter(
          heading: heading,
          qiblaDegrees: qiblaDegrees,
          facingMecca: facingMecca,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({
    required this.heading,
    required this.qiblaDegrees,
    required this.facingMecca,
    required this.isDark,
  });

  final double heading;
  final double qiblaDegrees;
  final bool facingMecca;
  final bool isDark;

  // ── Palette ────────────────────────────────────────────────────────────────
  Color get _bg =>
      isDark ? const Color(0xFF0D0320) : const Color(0xFFFFFFFF);
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

    // ── 1. Save & rotate the entire compass ring by -heading ────────────────
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
    // ── End rotation ─────────────────────────────────────────────────────────

    // ── 2. Static elements (don't rotate) ───────────────────────────────────
    _drawNeedle(canvas, cx, cy, innerR);
    _drawCenterJewel(canvas, cx, cy);
    _drawTopPointer(canvas, cx);
  }

  // ── Outer rings ─────────────────────────────────────────────────────────────
  void _drawOuterRings(Canvas c, double cx, double cy, double outerR, double dialR) {
    // Shadow ring
    c.drawCircle(
      Offset(cx, cy),
      outerR,
      Paint()..color = _primaryColor.withValues(alpha: isDark ? 0.6 : 0.08),
    );
    // Dial face
    c.drawCircle(
      Offset(cx, cy),
      dialR,
      Paint()..color = _ringBg,
    );
    // Outer border
    c.drawCircle(
      Offset(cx, cy),
      dialR,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    // Decorative outer ring line
    c.drawCircle(
      Offset(cx, cy),
      dialR - 12,
      Paint()
        ..color = _borderLight.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  // ── Tick marks ──────────────────────────────────────────────────────────────
  void _drawTicks(Canvas c, double cx, double cy, double dialR) {
    for (int i = 0; i < 72; i++) {
      final angleDeg = i * 5.0;
      final angleRad = (angleDeg - 90) * math.pi / 180;
      final isCardinal = angleDeg % 90 == 0;
      final isOrdinal  = angleDeg % 45 == 0 && !isCardinal;
      final isMid      = angleDeg % 15 == 0 && !isCardinal && !isOrdinal;

      final tickOuter = dialR - 2;
      final tickInner = isCardinal
          ? dialR - 20
          : isOrdinal
              ? dialR - 15
              : isMid
                  ? dialR - 11
                  : dialR - 7;

      final strokeW = isCardinal ? 2.5 : isOrdinal ? 1.8 : isMid ? 1.2 : 0.7;
      final color   = isCardinal
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

  // ── Cardinal + Ordinal Labels ─────────────────────────────────────────────
  void _drawCardinalLabels(Canvas c, double cx, double cy, double dialR) {
    final labelR = dialR - 34;
    const cardinals = ['N', 'E', 'S', 'W'];
    const ordinals   = ['NE', 'SE', 'SW', 'NW'];

    for (int i = 0; i < 4; i++) {
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

      // Ordinals (smaller, muted)
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

  // ── Qibla / Mecca Marker ─────────────────────────────────────────────────
  void _drawQiblaMarker(Canvas c, double cx, double cy, double dialR, double innerR) {
    final angleRad = (qiblaDegrees - 90) * math.pi / 180;

    // Pulsing glow arc around the marker position
    final glowR = dialR - 30;
    final glowX = cx + glowR * math.cos(angleRad);
    final glowY = cy + glowR * math.sin(angleRad);

    // Glow circle
    c.drawCircle(
      Offset(glowX, glowY),
      18,
      Paint()
        ..color = _teal.withValues(alpha: facingMecca ? 0.30 : 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Dashed teal line from inner ring to marker
    final lineStartX = cx + innerR * math.cos(angleRad);
    final lineStartY = cy + innerR * math.sin(angleRad);
    final lineEndX   = cx + (dialR - 46) * math.cos(angleRad);
    final lineEndY   = cy + (dialR - 46) * math.sin(angleRad);

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

    // Kaaba icon — drawn as a small filled square with star detail
    c.save();
    c.translate(glowX, glowY);
    c.rotate(angleRad + math.pi / 2);

    // Arrowhead pointing toward Mecca
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

    // Small kaaba square icon below arrow
    final kaabaRect = Rect.fromCenter(
      center: const Offset(0, 10),
      width: 12,
      height: 12,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(kaabaRect, const Radius.circular(2)),
      Paint()..color = facingMecca ? _tealLight : _teal,
    );
    // Door line on kaaba
    c.drawLine(
      const Offset(0, 6),
      const Offset(0, 16),
      Paint()
        ..color = isDark ? const Color(0xFF060118) : Colors.white
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    c.restore();

    // "Mecca" label
    final labelAngleRad = (qiblaDegrees - 90) * math.pi / 180;
    final labelR = dialR - 8;
    final labelX = cx + labelR * math.cos(labelAngleRad);
    final labelY = cy + labelR * math.sin(labelAngleRad);
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

  // ── Inner Face ─────────────────────────────────────────────────────────────
  void _drawInnerFace(Canvas c, double cx, double cy, double innerR) {
    // Inner fill
    c.drawCircle(
      Offset(cx, cy),
      innerR,
      Paint()..color = _innerBg,
    );
    // Inner border (teal dashed)
    final dashPaint = Paint()
      ..color = _teal.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _drawDashedCircle(c, Offset(cx, cy), innerR, dashPaint,
        dashLength: 6, gapLength: 8);

    // Solid inner border
    c.drawCircle(
      Offset(cx, cy),
      innerR,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  // ── Needle ─────────────────────────────────────────────────────────────────
  void _drawNeedle(Canvas c, double cx, double cy, double innerR) {
    const needleW = 7.0;
    final northLen = innerR * 0.72;
    final southLen = innerR * 0.72;

    // North half (fuchsia)
    final northPath = Path()
      ..moveTo(cx, cy - northLen)
      ..lineTo(cx - needleW, cy)
      ..lineTo(cx + needleW, cy)
      ..close();
    c.drawPath(northPath, Paint()..color = _fuchsia);

    // North shine
    final northShine = Path()
      ..moveTo(cx, cy - northLen)
      ..lineTo(cx - needleW * 0.4, cy)
      ..lineTo(cx, cy - northLen * 0.3)
      ..close();
    c.drawPath(
      northShine,
      Paint()..color = _fuchsiaLight.withValues(alpha: 0.4),
    );

    // South half (muted)
    final southPath = Path()
      ..moveTo(cx, cy + southLen)
      ..lineTo(cx - needleW, cy)
      ..lineTo(cx + needleW, cy)
      ..close();
    c.drawPath(
      southPath,
      Paint()
        ..color = isDark
            ? const Color(0xFF261A45)
            : const Color(0xFFD9D1E8),
    );
    c.drawPath(
      southPath,
      Paint()
        ..color = _borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  // ── Center Jewel ───────────────────────────────────────────────────────────
  void _drawCenterJewel(Canvas c, double cx, double cy) {
    // Outer ring
    c.drawCircle(
      Offset(cx, cy),
      13,
      Paint()
        ..color = isDark
            ? const Color(0xFF261A45)
            : const Color(0xFFEEE8FA),
    );
    c.drawCircle(
      Offset(cx, cy),
      13,
      Paint()
        ..color = _primaryLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Inner dot
    c.drawCircle(Offset(cx, cy), 6, Paint()..color = _fuchsia);
    // Highlight
    c.drawCircle(
      Offset(cx - 2, cy - 2),
      2.5,
      Paint()..color = _fuchsiaLight.withValues(alpha: 0.6),
    );
  }

  // ── Top Pointer Triangle ──────────────────────────────────────────────────
  void _drawTopPointer(Canvas c, double cx) {
    final path = Path()
      ..moveTo(cx, 4)
      ..lineTo(cx - 8, 20)
      ..lineTo(cx + 8, 20)
      ..close();
    c.drawPath(path, Paint()..color = _fuchsia.withValues(alpha: 0.9));
  }

  // ── Utilities ──────────────────────────────────────────────────────────────
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
    double drawn = 0;
    bool drawing = true;
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
    final actualGap  = (2 * math.pi / count) - actualDash;

    for (int i = 0; i < count; i++) {
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
  bool shouldRepaint(_CompassPainter old) =>
      old.heading != heading ||
      old.facingMecca != facingMecca ||
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.heading,
    required this.qiblaOffset,
    required this.facingMecca,
    required this.isDark,
  });
  final double heading;
  final double qiblaOffset;
  final bool facingMecca;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              label: 'Heading',
              value: '${heading.toStringAsFixed(0)}°',
              icon: Icons.explore_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _InfoCard(
              label: 'Qibla offset',
              value: '${qiblaOffset.toStringAsFixed(0)}°',
              icon: Icons.mosque_rounded,
              isDark: isDark,
              accent: true,
              isOnTarget: facingMecca,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _InfoCard(
              label: 'Accuracy',
              value: '±2°',
              icon: Icons.my_location_rounded,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    this.accent = false,
    this.isOnTarget = false,
  });
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool accent;
  final bool isOnTarget;

  @override
  Widget build(BuildContext context) {
    final cardBg   = isDark ? const Color(0xFF120A2B) : const Color(0xFFFFFFFF);
    final borderC  = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final labelC   = isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288);
    final valueC   = accent && isOnTarget
        ? const Color(0xFF00BFA5)
        : (isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24));
    final iconC    = accent
        ? (isOnTarget ? const Color(0xFF00BFA5) : const Color(0xFF4B30A1))
        : const Color(0xFF4B30A1);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent && isOnTarget
              ? const Color(0xFF00BFA5).withValues(alpha: 0.5)
              : borderC,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconC),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: valueC,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: labelC,
              letterSpacing: 0.3,
            ),
          ),
          if (accent) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 5, height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnTarget
                        ? const Color(0xFF00BFA5)
                        : const Color(0xFF4B30A1),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  isOnTarget ? 'Facing Mecca!' : 'Rotate to align',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isOnTarget
                        ? const Color(0xFF00BFA5)
                        : const Color(0xFF7E57C2),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}