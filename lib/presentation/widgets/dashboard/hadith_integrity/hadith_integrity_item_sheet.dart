import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/hadith_integrity/hadith_integrity_library.dart';

Future<void> showHadithIntegrityItemSheet(
  BuildContext context,
  HadithIntegrityCollection collection,
  HadithIntegrityItem item,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) => _HadithIntegrityItemSheet(collection: collection, item: item),
);

class _HadithIntegrityItemSheet extends StatelessWidget {
  const _HadithIntegrityItemSheet({
    required this.collection,
    required this.item,
  });

  final HadithIntegrityCollection collection;
  final HadithIntegrityItem item;

  String _title(BuildContext context) {
    final locale = Localizations.localeOf(context);
    for (final field in const ['title', 'text', 'misconception', 'content']) {
      final value = item.localized(field, locale);
      if (value.isNotEmpty) return value;
    }
    return context.l10n.hadithIntegrityNoItems;
  }

  List<String> _paragraphs(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final paragraphs = <String>[];
    for (final field in const [
      'text',
      'content',
      'misconception',
      'correction',
      'explanation',
      'lesson',
      'action',
      'user_action',
    ]) {
      final value = item.localized(field, locale);
      if (value.isNotEmpty && !paragraphs.contains(value)) {
        paragraphs.add(value);
      }
    }
    return paragraphs;
  }

  Future<void> _openSource(
    BuildContext context,
    HadithIntegritySource source,
  ) async {
    final url = source.url;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.hadithIntegritySourceUnavailable),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final source = item.source ?? _referenceSource();
    final locale = Localizations.localeOf(context);
    final arabic = item.plain('arabic');
    final paragraphs = _paragraphs(context);
    final status = item.localized('status', locale);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .78,
      minChildSize: .48,
      maxChildSize: .96,
      snap: true,
      snapSizes: const [.78, .96],
      builder: (context, controller) => Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.huge,
          ),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              collection.localizedTitle(locale),
              style: AppTheme.text(context).labelMedium.copyWith(
                color: AppThemeColors.light.cyan,
                fontWeight: AppTheme.weightExtraBold,
                letterSpacing: .6,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _title(context),
              style: AppTheme.text(context).headlineMedium.copyWith(
                fontWeight: AppTheme.weightExtraBold,
                height: 1.12,
              ),
            ),
            if (arabic.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _SheetBlock(
                child: Text(
                  arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTheme.amiri(context, fontSize: 25, height: 1.75),
                ),
              ),
            ],
            if (status.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _SheetStatus(text: status),
            ],
            for (final paragraph in paragraphs) ...[
              const SizedBox(height: AppSpacing.md),
              _SheetBlock(
                child: Text(
                  paragraph,
                  style: AppTheme.text(
                    context,
                  ).bodyLarge.copyWith(height: 1.55),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (source != null) ...[
              Text(
                context.l10n.hadithIntegritySourceLabel,
                style: AppTheme.text(context).labelMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                source.title,
                style: AppTheme.text(
                  context,
                ).bodyMedium.copyWith(fontWeight: AppTheme.weightSemiBold),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: () => _openSource(context, source),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(context.l10n.hadithIntegrityViewSource),
              ),
            ] else
              Text(
                context.l10n.hadithIntegritySourceUnavailable,
                style: AppTheme.text(
                  context,
                ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }

  HadithIntegritySource? _referenceSource() {
    final reference = item.reference;
    final url = reference?.url;
    if (url == null || url.isEmpty) return null;
    final title = [
      reference?.collection,
      reference?.hadithNumber,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' ');
    return HadithIntegritySource(
      title: title.isEmpty ? 'Reference' : title,
      url: url,
    );
  }
}

class _SheetBlock extends StatelessWidget {
  const _SheetBlock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: .52),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: child,
    );
  }
}

class _SheetStatus extends StatelessWidget {
  const _SheetStatus({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = AppThemeColors.light.coral;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: color,
                fontWeight: AppTheme.weightSemiBold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
