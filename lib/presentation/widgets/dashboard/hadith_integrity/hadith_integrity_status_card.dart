import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/hadith_integrity/hadith_integrity_library.dart';

class HadithIntegrityStatusCard extends StatelessWidget {
  const HadithIntegrityStatusCard({
    super.key,
    required this.collection,
    required this.accent,
  });

  final HadithIntegrityCollection collection;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: .24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Icon(Icons.label_important_outline, color: accent),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    collection.localizedTitle(locale),
                    style: AppTheme.text(
                      context,
                    ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
                  ),
                ),
              ],
            ),
          ),
          for (final group in collection.statusGroups)
            _StatusGroup(group: group, accent: accent),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({required this.group, required this.accent});

  final HadithIntegrityStatusGroup group;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      childrenPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      leading: Icon(Icons.layers_outlined, color: accent, size: 21),
      title: Text(
        group.title.localized(locale),
        style: AppTheme.text(
          context,
        ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
      ),
      subtitle: Text(
        context.l10n.hadithIntegrityItemCount('${group.items.length}'),
        style: AppTheme.text(
          context,
        ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
      ),
      iconColor: accent,
      collapsedIconColor: accent,
      children: [
        for (final item in group.items) _StatusItem(item: item, accent: accent),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.item, required this.accent});

  final HadithIntegrityStatusItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final title = item.title.localized(locale);
    final meaning = item.meaning.localized(locale);
    final note = item.importantNote?.localized(locale) ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: accent.withValues(alpha: .15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((item.arabic ?? '').isNotEmpty) ...[
                  Text(
                    item.arabic!,
                    textDirection: TextDirection.rtl,
                    style: AppTheme.amiri(context, fontSize: 19),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.text(
                      context,
                    ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
                  ),
                ),
              ],
            ),
            if (meaning.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                meaning,
                style: AppTheme.text(context).bodySmall.copyWith(height: 1.45),
              ),
            ],
            if (note.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                note,
                style: AppTheme.text(context).bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
