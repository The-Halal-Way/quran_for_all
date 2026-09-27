import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_guide_style.dart';
import 'eid_hero_fact.dart';
import 'eid_hero_pattern.dart';

class EidGuideHero extends StatelessWidget {
  const EidGuideHero({super.key, required this.eid, required this.bangla});

  final EidKind eid;
  final bool bangla;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = EidGuideStyle.brightAccent(eid);
    final fitr = eid == EidKind.fitr;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: EidGuideStyle.heroGradient(eid),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.35 : 0.19),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: EidHeroPattern(color: accent.withValues(alpha: 0.18)),
              ),
            ),
            PositionedDirectional(
              top: -28,
              end: -20,
              child: Icon(
                fitr ? Icons.nightlight_round : Icons.auto_awesome_rounded,
                size: 164,
                color: accent.withValues(alpha: 0.15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: accent, size: 17),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          fitr
                              ? (bangla
                                    ? '১ শাওয়াল • ঈদুল ফিতর'
                                    : '1 SHAWWAL • EID AL-FITR')
                              : (bangla
                                    ? '১০ জিলহজ • ঈদুল আযহা'
                                    : '10 DHUL HIJJAH • EID AL-ADHA'),
                          style: AppTheme.text(context).labelMedium.copyWith(
                            color: accent,
                            fontWeight: AppTheme.weightBold,
                            letterSpacing: bangla ? 0 : 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    fitr
                        ? (bangla
                              ? 'রমজানের পর\nআনন্দ ও কৃতজ্ঞতা'
                              : 'Joy and gratitude\nafter Ramadan')
                        : (bangla
                              ? 'আনুগত্য, ত্যাগ\nও উদারতার দিন'
                              : 'A day of devotion\nand generosity'),
                    style: AppTheme.text(context).headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightExtraBold,
                      height: 1.14,
                      letterSpacing: bangla ? 0 : -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    fitr
                        ? (bangla
                              ? 'নামাজ, সদকাতুল ফিতর, সুন্নাহ প্রস্তুতি, তাকবীর ও দোয়া—সব এক জায়গায়।'
                              : 'Prayer, Sadaqat al-Fitr, Sunnah preparations, takbeer and duas in one guide.')
                        : (bangla
                              ? 'নামাজ, কুরবানি, দিনের আমল, তাকবীর ও দোয়া—সব এক জায়গায়।'
                              : 'Prayer, sacrifice, the day’s practices, takbeer and duas in one guide.'),
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.87),
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      EidHeroFact(
                        icon: Icons.self_improvement_rounded,
                        label: bangla ? '২ রাকাত' : '2 RAK\'AHS',
                        accent: accent,
                      ),
                      EidHeroFact(
                        icon: Icons.groups_rounded,
                        label: bangla ? 'জামাতে আদায়' : 'CONGREGATION',
                        accent: accent,
                      ),
                      EidHeroFact(
                        icon: Icons.record_voice_over_rounded,
                        label: bangla ? 'পরে খুতবা' : 'KHUTBAH AFTER',
                        accent: accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
