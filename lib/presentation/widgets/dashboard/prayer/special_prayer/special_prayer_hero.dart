import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

// MARK: Prayer - Special Prayer Hero
class SpecialPrayerHero extends StatelessWidget {
  const SpecialPrayerHero({super.key, required this.content});

  final SpecialPrayerContent content;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accentFor(content.type);
    final companion = _companionFor(content.type);

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: Colors.white.withValues(alpha: isDark ? 0.13 : 0.26),
      shadowColor: accent,
      gradient: LinearGradient(
        colors: isDark
            ? [
                MyColors.primaryDark,
                accent.withValues(alpha: 0.42),
                companion.withValues(alpha: 0.34),
              ]
            : [
                accent.withValues(alpha: 0.92),
                companion.withValues(alpha: 0.82),
                MyColors.primaryLight.withValues(alpha: 0.82),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _SpecialPrayerPatternPainter(
                  color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 680;
                  final textPanel = _HeroTextPanel(
                    content: content,
                    accent: accent,
                  );
                  final arabicPanel = _HeroArabicPanel(
                    content: content,
                    accent: accent,
                  );

                  if (!wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textPanel,
                        const SizedBox(height: AppSpacing.lg),
                        arabicPanel,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 7, child: textPanel),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(flex: 4, child: arabicPanel),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: Prayer - Special Prayer Hero Accent
  Color _accentFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.tertiaryLight,
      SpecialPrayerType.salatulTasbeeh => MyColors.secondaryLight,
    };
  }

  // MARK: Prayer - Special Prayer Hero Companion Color
  Color _companionFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.info,
      SpecialPrayerType.salatulTasbeeh => MyColors.tertiary,
    };
  }
}

// MARK: Prayer - Special Prayer Hero Text Panel
class _HeroTextPanel extends StatelessWidget {
  const _HeroTextPanel({required this.content, required this.accent});

  final SpecialPrayerContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            _HeroChip(
              label: content.heroEyebrow,
              icon: _iconFor(content.type),
              accent: accent,
            ),
            _HeroChip(
              label: content.heroBadge,
              icon: Icons.verified_rounded,
              accent: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          content.title,
          style: text.prayerHeroTitle.copyWith(
            color: Colors.white,
            height: 1.08,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          content.heroBody,
          style: text.prayerHeroSubtitle.copyWith(
            color: Colors.white.withValues(alpha: 0.90),
            height: 1.52,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  // MARK: Prayer - Special Prayer Hero Icon
  IconData _iconFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => Icons.volunteer_activism_rounded,
      SpecialPrayerType.salatulTasbeeh => Icons.auto_awesome_rounded,
    };
  }
}

// MARK: Prayer - Special Prayer Hero Chip
class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.label,
    required this.icon,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 15),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: text.prayerStatusChip.copyWith(
                color: Colors.white,
                height: 1.1,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Special Prayer Arabic Panel
class _HeroArabicPanel extends StatelessWidget {
  const _HeroArabicPanel({required this.content, required this.accent});

  final SpecialPrayerContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
            child: Icon(_iconFor(content.type), color: Colors.white, size: 27),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              content.heroArabic,
              textAlign: TextAlign.center,
              style: AppTheme.amiri(
                context,
                fontSize: 36,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 64,
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: Prayer - Special Prayer Arabic Panel Icon
  IconData _iconFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => Icons.local_florist_rounded,
      SpecialPrayerType.salatulTasbeeh => Icons.brightness_5_rounded,
    };
  }
}

// MARK: Prayer - Special Prayer Pattern Painter
class _SpecialPrayerPatternPainter extends CustomPainter {
  const _SpecialPrayerPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var index = 0; index < 5; index++) {
      final inset = 18.0 + index * 34;
      final rect = Rect.fromLTWH(
        size.width - inset - 180,
        -70 + index * 12,
        240 + index * 18,
        180 + index * 20,
      );
      canvas.drawArc(rect, 0.35, 2.8, false, paint);
    }

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final path = Path()
      ..moveTo(-20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.50,
        size.width * 0.66,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.84,
        size.width + 28,
        size.height * 0.66,
      );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SpecialPrayerPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
