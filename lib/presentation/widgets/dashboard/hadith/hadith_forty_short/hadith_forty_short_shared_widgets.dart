part of '../../../../views/dashboard/hadith/hadith_forty_short_view.dart';

class _DotRow extends StatelessWidget {
  final int total, current;
  final bool isDark;

  const _DotRow({
    required this.total,
    required this.current,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Show a sliding window of 7 dots max
    const visible = 7;
    final half = visible ~/ 2;
    int start = (current - half).clamp(0, math.max(0, total - visible));
    final end = (start + visible).clamp(0, total);
    start = (end - visible).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(end - start, (i) {
        final idx = start + i;
        final isActive = idx == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? MyColors.tertiary
                : (isDark ? Colors.white.withOpacity(0.15) : MyColors.divider),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE SMALL COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _LangToggle extends StatelessWidget {
  final bool isBangla, isDark;
  final ValueChanged<bool> onChanged;

  const _LangToggle({
    required this.isBangla,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isBangla),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.8),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangOption(label: 'EN', active: !isBangla, isDark: isDark),
            _LangOption(label: 'বাং', active: isBangla, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool active, isDark;
  const _LangOption({
    required this.label,
    required this.active,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? MyColors.tertiary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: text.hadithPillOption.copyWith(
          color: active ? Colors.white : Colors.white.withOpacity(0.82),
        ),
      ),
    );
  }
}

class _BarNavBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled, isDark, isRight;
  final Color textMain, textHint;
  final VoidCallback? onTap;

  const _BarNavBtn({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    this.isRight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final color = enabled ? MyColors.tertiary : textHint;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isRight) Icon(icon, size: 15, color: color),
          if (!isRight) const SizedBox(width: 5),
          Text(label, style: text.hadithBottomNavLabel.copyWith(color: color)),
          if (isRight) const SizedBox(width: 5),
          if (isRight) Icon(icon, size: 15, color: color),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORATIVE PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

/// 6-pointed star ornament
class _GeomStar extends StatelessWidget {
  final Color color;
  final double size;
  const _GeomStar({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size),
    painter: _StarPainter(color: color),
  );
}

class _StarPainter extends CustomPainter {
  final Color color;
  const _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.028
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer hexagon
    _polygon(canvas, paint, cx, cy, r * 0.92, 6, -math.pi / 2);
    // Inner hexagon (rotated)
    _polygon(canvas, paint, cx, cy, r * 0.55, 6, math.pi / 6);
    // Star spokes
    for (int i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      canvas.drawLine(
        Offset(cx + math.cos(a) * r * 0.55, cy + math.sin(a) * r * 0.55),
        Offset(cx + math.cos(a) * r * 0.92, cy + math.sin(a) * r * 0.92),
        paint,
      );
    }
    // Center dot
    canvas.drawCircle(Offset(cx, cy), r * 0.12, paint);
  }

  void _polygon(
    Canvas c,
    Paint p,
    double cx,
    double cy,
    double r,
    int n,
    double start,
  ) {
    final path = Path();
    for (int i = 0; i <= n; i++) {
      final a = start + i * math.pi * 2 / n;
      final pt = Offset(cx + math.cos(a) * r, cy + math.sin(a) * r);
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}

/// Subtle tiling background
class _TileBackground extends StatelessWidget {
  final bool isDark;
  const _TileBackground({required this.isDark});

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: CustomPaint(painter: _TilePainter(isDark: isDark)),
    ),
  );
}

class _TilePainter extends CustomPainter {
  final bool isDark;
  const _TilePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.tertiary : MyColors.primaryLight)
          .withOpacity(isDark ? 0.035 : 0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const step = 52.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _hexagon(canvas, paint, Offset(x, y), 14);
      }
    }
  }

  void _hexagon(Canvas c, Paint p, Offset center, double r) {
    final path = Path();
    for (int i = 0; i <= 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      final pt = Offset(
        center.dx + math.cos(a) * r,
        center.dy + math.sin(a) * r,
      );
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    c.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_TilePainter old) => old.isDark != isDark;
}
