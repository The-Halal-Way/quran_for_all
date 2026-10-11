import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/prophecies/prophecy_book.dart';

Future<void> showProphecyEntryDialog(BuildContext context, ProphecyItem item) =>
    showDialog<void>(
      context: context,
      builder: (_) => _ProphecyEntryDialog(item: item),
    );

class _ProphecyEntryDialog extends StatelessWidget {
  const _ProphecyEntryDialog({required this.item});
  final ProphecyItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final details = item.detailsPage;
    final content = item.localizedContent(locale).trim();
    return AlertDialog(
      scrollable: true,
      title: Text(item.localizedTitle(locale)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details != null) ...[
            _ComingSoonBanner(route: details.route),
            const SizedBox(height: AppSpacing.md),
          ],
          if (content.isNotEmpty)
            Text(content, style: AppTheme.text(context).bodyMedium),
          if (item.usesEnglishFallback(locale)) ...[
            const SizedBox(height: AppSpacing.md),
            _EnglishFallbackNote(),
          ],
          if (content.isEmpty && details == null)
            Text(
              context.l10n.propheciesContentComingSoon,
              style: AppTheme.text(context).bodyMedium,
            ),
          if (item.references.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.propheciesReferences,
              style: AppTheme.text(context).titleSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final reference in item.references)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  '• ${reference.text}',
                  style: AppTheme.text(context).bodySmall,
                ),
              ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.propheciesClose),
        ),
      ],
    );
  }
}

class _EnglishFallbackNote extends StatelessWidget {
  const _EnglishFallbackNote();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.translate_rounded, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.propheciesEnglishFallbackNote,
                style: AppTheme.text(context).bodySmall.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner({required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome_rounded, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '${context.l10n.propheciesDetailsComingSoon}\n$route',
                style: AppTheme.text(context).bodySmall.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
