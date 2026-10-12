import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/prophecies/prophecy_book.dart';
import '../../../widgets/dashboard/books/prophecy_entry_dialog.dart';

class PropheciesPartView extends StatelessWidget {
  const PropheciesPartView({super.key, required this.part});

  final ProphecyPart part;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(part.localizedTitle(locale))),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        itemCount: part.items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = part.items[index];
          final hasComingSoonDetails =
              item.detailsPage != null && item.detailsPage!.url == null;
          return Material(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showProphecyEntryDialog(context, item),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NumberBadge(
                      number: item.sourceNumbers.isNotEmpty
                          ? item.sourceNumbers.first
                          : index + 1,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.localizedTitle(locale),
                            style: AppTheme.text(context).titleSmall.copyWith(
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                          if (hasComingSoonDetails) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              context.l10n.propheciesDetailsComingSoon,
                              style: AppTheme.text(
                                context,
                              ).labelSmall.copyWith(color: scheme.tertiary),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      hasComingSoonDetails
                          ? Icons.auto_awesome_rounded
                          : Icons.chevron_right_rounded,
                      color: hasComingSoonDetails
                          ? scheme.tertiary
                          : scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$number',
        style: AppTheme.text(context).labelLarge.copyWith(
          color: color,
          fontWeight: AppTheme.weightExtraBold,
        ),
      ),
    );
  }
}
