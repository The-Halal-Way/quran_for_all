import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/hadith_integrity/hadith_integrity_library.dart';
import 'hadith_integrity_entry_card.dart';

class HadithIntegrityCollectionCard extends StatelessWidget {
  const HadithIntegrityCollectionCard({
    super.key,
    required this.collection,
    required this.accent,
    this.kicker,
  });

  final HadithIntegrityCollection collection;
  final Color accent;
  final String? kicker;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    final title = collection.localizedTitle(locale);
    final subtitle = collection.localizedSubtitle(locale);
    final description = collection.localizedDescription(locale);
    final summary = subtitle.isNotEmpty
        ? subtitle
        : description.isNotEmpty
        ? description
        : context.l10n.hadithIntegrityItemCount('${collection.items.length}');
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: .24)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .07),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          leading: _CollectionBadge(
            accent: accent,
            label: collection.kind.isPopularNarrations
                ? '${collection.kind.index + 1}'
                : '✦',
          ),
          title: Text(
            kicker == null ? title : '$kicker · $title',
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          subtitle: Text(
            summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(
              context,
            ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          iconColor: accent,
          collapsedIconColor: accent,
          children: collection.items.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(context.l10n.hadithIntegrityNoItems),
                  ),
                ]
              : [
                  for (var index = 0; index < collection.items.length; index++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: HadithIntegrityEntryCard(
                        collection: collection,
                        item: collection.items[index],
                        index: index,
                        accent: accent,
                      ),
                    ),
                ],
        ),
      ),
    );
  }
}

class _CollectionBadge extends StatelessWidget {
  const _CollectionBadge({required this.accent, required this.label});

  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [accent, Color.lerp(accent, AppThemeColors.light.violet, .42)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    child: SizedBox(
      width: 42,
      height: 42,
      child: Center(
        child: Text(
          label,
          style: AppTheme.text(context).labelLarge.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.weightExtraBold,
          ),
        ),
      ),
    ),
  );
}
