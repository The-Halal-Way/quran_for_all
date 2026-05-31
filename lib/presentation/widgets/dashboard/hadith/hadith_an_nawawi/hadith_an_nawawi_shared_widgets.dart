part of '../../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';

class _PillToggle extends StatelessWidget {
  final String leftLabel, rightLabel;
  final bool isRight, isDark;
  final ValueChanged<bool> onChanged;

  const _PillToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.isRight,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isRight),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? MyColors.darkCard.withOpacity(0.9)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PillOption(label: leftLabel, active: !isRight),
              _PillOption(label: rightLabel, active: isRight),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String label;
  final bool active;
  const _PillOption({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(0.9) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: text.hadithPillOption.copyWith(
          color: active ? MyColors.primary : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}

/// Glass-like card with optional accent bar
class _GlassCard extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color? accentColor;
  final Widget child;

  const _GlassCard({
    required this.isDark,
    required this.cardBg,
    this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : MyColors.divider.withOpacity(0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(isDark ? 0.15 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Stat chip
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final bool isDark;
  final Color cardBg, textMain, textHint;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : MyColors.divider.withOpacity(0.7),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.1 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: MyColors.secondary),
            const SizedBox(height: 6),
            Text(value, style: text.hadithStatValue.copyWith(color: textMain)),
            Text(label, style: text.hadithStatLabel.copyWith(color: textHint)),
          ],
        ),
      ),
    );
  }
}

/// Navigation button
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled, isDark;
  final bool isRight;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.isDark,
    this.isRight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final color = enabled
        ? MyColors.secondary
        : (isDark ? MyColors.darkTextTertiary : MyColors.textTertiary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isRight) Icon(icon, color: color, size: 16),
          if (!isRight) const SizedBox(width: 6),
          Text(label, style: text.hadithBottomNavLabel.copyWith(color: color)),
          if (isRight) const SizedBox(width: 6),
          if (isRight) Icon(icon, color: color, size: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORATIVE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Geometric Islamic-style ornament (pure CustomPaint, no image needed)
class _ArabicOrnament extends StatelessWidget {
  final Color color;
  final double size;
  const _ArabicOrnament({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _OrnamentPainter(color: color),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  final Color color;
  const _OrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Outer octagon
    _drawPolygon(canvas, paint, center, r * 0.95, 8, -math.pi / 8);
    // Inner octagon (rotated)
    _drawPolygon(canvas, paint, center, r * 0.65, 8, math.pi / 8);
    // Star lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) - math.pi / 8;
      final p1 = Offset(
        center.dx + math.cos(angle) * r * 0.65,
        center.dy + math.sin(angle) * r * 0.65,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * r * 0.95,
        center.dy + math.sin(angle) * r * 0.95,
      );
      canvas.drawLine(p1, p2, paint);
    }
    // Center circle
    canvas.drawCircle(center, r * 0.18, paint);
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
    for (int i = 0; i <= sides; i++) {
      final angle = startAngle + (i * math.pi * 2 / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0)
        path.moveTo(point.dx, point.dy);
      else
        path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OrnamentPainter old) => old.color != color;
}

/// Subtle animated background mesh
class _BackgroundMesh extends StatelessWidget {
  final bool isDark;
  const _BackgroundMesh({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _MeshPainter(isDark: isDark)),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final bool isDark;
  const _MeshPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()
    //   ..color = (isDark ? MyColors.primaryLight : MyColors.primary).withOpacity(
    //     isDark ? 0.04 : 0.03,
    //   )
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.5;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        final ornPaint = Paint()
          ..color = (isDark ? MyColors.secondary : MyColors.primaryLight)
              .withOpacity(isDark ? 0.04 : 0.025)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4;
        final center = Offset(x, y);
        _drawOctagon(canvas, ornPaint, center, 16);
      }
    }
  }

  void _drawOctagon(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path();
    for (int i = 0; i <= 8; i++) {
      final angle = (i * math.pi * 2 / 8) - math.pi / 8;
      final point = Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      );
      if (i == 0)
        path.moveTo(point.dx, point.dy);
      else
        path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) => old.isDark != isDark;
}
