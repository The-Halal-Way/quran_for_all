import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class SpecialPrayerHeroText extends StatelessWidget {
  const SpecialPrayerHeroText({
    super.key,
    required this.content,
    required this.accent,
  });

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

  IconData _iconFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => Icons.volunteer_activism_rounded,
      SpecialPrayerType.salatulTasbeeh => Icons.auto_awesome_rounded,
    };
  }
}

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
