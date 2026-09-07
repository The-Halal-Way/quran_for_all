import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'prayer_reference_card.dart';
import 'prayer_reference_item.dart';

class PrayerReferenceCarousel extends StatelessWidget {
  const PrayerReferenceCarousel({
    super.key,
    required this.onMovementGuideTap,
    required this.onForbiddenTimesTap,
    required this.onNafalPrayersTap,
    required this.onJanazaPrayerTap,
    required this.onSalatulTasbeehTap,
  });

  final VoidCallback onMovementGuideTap;
  final VoidCallback onForbiddenTimesTap;
  final VoidCallback onNafalPrayersTap;
  final VoidCallback onJanazaPrayerTap;
  final VoidCallback onSalatulTasbeehTap;

  @override
  Widget build(BuildContext context) {
    final items = _items(context);

    return SizedBox(
      height: 126,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => SizedBox(
          width: 146,
          child: PrayerReferenceCard(item: items[index]),
        ),
      ),
    );
  }

  List<PrayerReferenceItem> _items(BuildContext context) {
    final l10n = context.l10n;
    return [
      PrayerReferenceItem(
        title: l10n.prayerReferenceMovementsActionTitle,
        semanticDescription: l10n.prayerReferenceMovementsActionSubtitle,
        icon: Icons.self_improvement_rounded,
        color: MyColors.primaryLight,
        onTap: onMovementGuideTap,
      ),
      PrayerReferenceItem(
        title: l10n.prayerReferenceForbiddenActionTitle,
        semanticDescription: l10n.prayerReferenceForbiddenActionSubtitle,
        icon: Icons.block_rounded,
        color: MyColors.secondary,
        onTap: onForbiddenTimesTap,
      ),
      PrayerReferenceItem(
        title: l10n.prayerReferenceNafalActionTitle,
        semanticDescription: l10n.prayerReferenceNafalActionSubtitle,
        icon: Icons.auto_awesome_rounded,
        color: MyColors.tertiary,
        onTap: onNafalPrayersTap,
      ),
      PrayerReferenceItem(
        title: l10n.prayerReferenceJanazaActionTitle,
        semanticDescription: l10n.prayerReferenceJanazaActionSubtitle,
        icon: Icons.volunteer_activism_rounded,
        color: MyColors.info,
        onTap: onJanazaPrayerTap,
      ),
      PrayerReferenceItem(
        title: l10n.prayerReferenceTasbeehActionTitle,
        semanticDescription: l10n.prayerReferenceTasbeehActionSubtitle,
        icon: Icons.brightness_5_rounded,
        color: MyColors.secondaryLight,
        onTap: onSalatulTasbeehTap,
      ),
    ];
  }
}
