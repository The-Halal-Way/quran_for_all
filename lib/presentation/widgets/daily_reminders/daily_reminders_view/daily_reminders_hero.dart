import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../l10n/app_localizations.dart';

class DailyRemindersHero extends StatelessWidget {
  const DailyRemindersHero({
    super.key,
    required this.l10n,
    required this.onBack,
    required this.onSettings,
  });

  final AppLocalizations l10n;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [MyColors.primaryDark, MyColors.primary, Color(0xFF501060)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          boxShadow: [
            BoxShadow(
              color: MyColors.secondary.withValues(alpha: 0.16),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(right: -28, top: -42, child: _OrbitalMark()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: onBack,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      icon: const Icon(Icons.arrow_back_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    const Spacer(),
                    IconButton.filledTonal(
                      onPressed: onSettings,
                      tooltip: l10n.dailyRemindersSettings,
                      icon: const Icon(Icons.tune_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: MyColors.tertiaryLight.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: MyColors.tertiaryLight.withValues(alpha: 0.32),
                    ),
                  ),
                  child: const Icon(
                    Icons.brightness_7_rounded,
                    color: MyColors.tertiaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.dailyRemindersTitle,
                  style: AppTheme.sora(
                    context,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.dailyRemindersSubtitle,
                  style: AppTheme.manrope(
                    context,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.74),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitalMark extends StatelessWidget {
  const _OrbitalMark();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 150,
        height: 150,
        child: CustomPaint(painter: _OrbitalPainter()),
      ),
    );
  }
}

class _OrbitalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.12);
    for (final inset in [6.0, 20.0, 35.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: size.width - inset * 2,
          height: (size.height - inset * 2) * 0.58,
        ),
        paint,
      );
    }
    canvas.drawCircle(
      center + const Offset(-35, 14),
      4,
      Paint()..color = MyColors.secondaryLight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
