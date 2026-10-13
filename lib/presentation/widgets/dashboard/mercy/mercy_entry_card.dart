import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/mercy/mercy_collection.dart';
import 'mercy_entry_sheet.dart';

class MercyEntryCard extends StatelessWidget {
  const MercyEntryCard({
    super.key,
    required this.collection,
    required this.entry,
    required this.index,
  });

  final MercyCollection collection;
  final MercyEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final accent = collection.kind == MercyCollectionKind.hadith
        ? colors.coral
        : colors.violet;
    final secondary = collection.kind == MercyCollectionKind.hadith
        ? colors.violet
        : colors.cyan;
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final source = entry.localizedSourceTitle(locale);
    final kindLabel = collection.kind == MercyCollectionKind.hadith
        ? context.l10n.dashboardMercyHadithTitle
        : context.l10n.dashboardMercyStoriesTitle;

    return Semantics(
      button: true,
      onTap: () => showMercyEntrySheet(context, collection, entry),
      excludeSemantics: true,
      label: entry.localizedTitle(locale),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: scheme.surface,
            gradient: LinearGradient(
              colors: [
                Color.alphaBlend(
                  accent.withValues(alpha: 0.07),
                  scheme.surface,
                ),
                Color.alphaBlend(
                  secondary.withValues(alpha: 0.035),
                  scheme.surface,
                ),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: accent.withValues(alpha: 0.19)),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => showMercyEntrySheet(context, collection, entry),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  _EntryNumber(
                    number: index + 1,
                    accent: accent,
                    secondary: secondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              kindLabel.toUpperCase(),
                              style: AppTheme.text(context).labelSmall.copyWith(
                                color: accent,
                                fontWeight: AppTheme.weightExtraBold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Divider(
                                color: accent.withValues(alpha: 0.16),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          entry.localizedTitle(locale),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).titleSmall.copyWith(
                            fontWeight: AppTheme.weightExtraBold,
                            height: 1.18,
                          ),
                        ),
                        if (source.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            source,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.text(context).bodySmall.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryNumber extends StatelessWidget {
  const _EntryNumber({
    required this.number,
    required this.accent,
    required this.secondary,
  });

  final int number;
  final Color accent;
  final Color secondary;

  @override
  Widget build(BuildContext context) => Container(
    width: 50,
    height: 58,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [accent, Color.lerp(secondary, accent, 0.25)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.md),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Text(
        number.toString().padLeft(2, '0'),
        style: AppTheme.text(context).titleMedium.copyWith(
          color: Colors.white,
          fontWeight: AppTheme.weightExtraBold,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );
}
