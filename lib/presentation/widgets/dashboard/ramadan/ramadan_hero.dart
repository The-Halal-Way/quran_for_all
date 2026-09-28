import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';
import 'ramadan_hero_tag.dart';
import 'ramadan_sky_painter.dart';

class RamadanHero extends StatelessWidget {
  const RamadanHero({super.key, required this.isBangla});

  final bool isBangla;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: [
        BoxShadow(
          color: MyColors.primaryDark.withValues(alpha: 0.26),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.primaryDark,
              MyColors.primary,
              MyColors.tertiaryDark,
            ],
            stops: [0, 0.55, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: RamadanSkyPainter()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.13),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        icon: const Icon(CupertinoIcons.chevron_back),
                      ),
                      const Spacer(),
                      Icon(
                        CupertinoIcons.moon_stars_fill,
                        color: MyColors.secondaryLight.withValues(alpha: 0.78),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    ramadanLabel(
                      isBangla,
                      'YOUR RAMADAN COMPANION',
                      'আপনার রমজান সহায়িকা',
                    ),
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: MyColors.secondaryLight,
                      fontWeight: AppTheme.weightExtraBold,
                      letterSpacing: isBangla ? 0 : 0.9,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'رَمَضَان',
                    textDirection: TextDirection.rtl,
                    style: AppTheme.amiri(
                      context,
                      fontSize: 42,
                      fontWeight: AppTheme.weightBold,
                      color: MyColors.secondaryLight,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    ramadanLabel(
                      isBangla,
                      'A month to return',
                      'ফিরে আসার মাস',
                    ),
                    style: AppTheme.text(context).headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightBlack,
                      height: 1.13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 48,
                    height: 2,
                    decoration: BoxDecoration(
                      color: MyColors.secondaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    ramadanLabel(
                      isBangla,
                      'From the first suhur to Eid: fasting, worship, wellbeing and guidance for every stage.',
                      'প্রথম সেহরি থেকে ঈদ পর্যন্ত: রোজা, ইবাদত, সুস্থতা ও প্রতিটি পর্যায়ের নির্দেশনা।',
                    ),
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      RamadanHeroTag(label: ramadanLabel(isBangla, 'FAST', 'রোজা')),
                      RamadanHeroTag(
                        label: ramadanLabel(
                          isBangla,
                          'REFLECT',
                          'আত্মসমালোচনা',
                        ),
                      ),
                      RamadanHeroTag(label: ramadanLabel(isBangla, 'GIVE', 'দান')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
