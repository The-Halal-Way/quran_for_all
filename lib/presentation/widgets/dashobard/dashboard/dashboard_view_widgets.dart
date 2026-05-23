part of '../../../views/dashboard/dashboard_view.dart';
class _ContinueCard extends StatelessWidget {
  final String title, subtitle, detail, arabicSnippet;
  final List<Color> gradientColors;
  final Color glowColor;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _ContinueCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.arabicSnippet,
    required this.gradientColors,
    required this.glowColor,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Watermark Arabic text
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                arabicSnippet,
                style: GoogleFonts.amiri(
                  fontSize: 36,
                  color: Colors.white.withOpacity(0.06),
                  fontWeight: FontWeight.bold,
                ),
                textDirection: ui.TextDirection.rtl,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, size: 17, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.65),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow chip
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER ROW
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerRow extends StatelessWidget {
  final String name, time;
  final IconData icon;
  final bool isNext, isDark;
  final Color textMain, textHint, divider;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isNext
                  ? MyColors.secondary.withOpacity(0.12)
                  : (isDark
                        ? Colors.white.withOpacity(0.05)
                        : MyColors.divider.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: isNext ? MyColors.secondary : textHint,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
              color: isNext ? textMain : textHint,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: MyColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: MyColors.secondary.withOpacity(0.25),
                  width: 0.7,
                ),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: MyColors.secondary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
              color: isNext ? MyColors.secondary : textHint,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION TILE  (2-col quick actions)
// ─────────────────────────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final _ActionItem item;
  final bool isDark;
  final Color cardBg, textMain, textHint, divider;

  const _ActionTile({
    required this.item,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.color),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textMain,
                letterSpacing: -0.1,
              ),
            ),
            if (item.sublabel != null) ...[
              const SizedBox(height: 2),
              Text(
                item.sublabel!,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HADITH NAV CARD  (large, with Arabic title)
// ─────────────────────────────────────────────────────────────────────────────

class _HadithNavCard extends StatelessWidget {
  final String number, arabicTitle, englishTitle, description;
  final List<Color> accentColors;
  final Color glowColor;
  final bool isDark;
  final Color cardBg, textMain, textSub, textHint, divider;
  final VoidCallback onTap;

  const _HadithNavCard({
    required this.number,
    required this.arabicTitle,
    required this.englishTitle,
    required this.description,
    required this.accentColors,
    required this.glowColor,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.12 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left accent strip with number
            Container(
              width: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: accentColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  Text(
                    'hadith',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      color: Colors.white.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arabicTitle,
                      style: GoogleFonts.amiri(
                        fontSize: 17,
                        color: textMain,
                        height: 1.3,
                      ),
                      textDirection: ui.TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      englishTitle,
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: glowColor.withOpacity(0.2),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: glowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND PAINTER  (faint geometric tile)
// ─────────────────────────────────────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  final bool isDark;
  const _BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.primaryLight : MyColors.primary).withOpacity(
        isDark ? 0.03 : 0.025,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const step = 56.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _drawDiamond(canvas, paint, Offset(x, y), 12);
      }
    }
  }

  void _drawDiamond(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.isDark != isDark;
}
