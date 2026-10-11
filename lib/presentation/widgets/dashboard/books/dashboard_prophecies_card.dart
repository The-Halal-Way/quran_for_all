import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/prophecies/prophecy_book.dart';
import '../../../viewmodels/prophecies_viewmodel.dart';
import '../../../views/dashboard/books/prophecies_part_view.dart';

class DashboardPropheciesCard extends StatelessWidget {
  const DashboardPropheciesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PropheciesViewModel>();
    final colors = AppThemeColors.light;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surface,
            Color.alphaBlend(
              colors.violet.withValues(alpha: 0.1),
              scheme.surface,
            ),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.violet.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PropheciesBookMark(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.propheciesBookTitle,
                      style: text.titleMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.propheciesBookDescription,
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.auto_awesome_rounded, color: colors.violet),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (model.loading)
            const LinearProgressIndicator()
          else if (model.error != null)
            _PropheciesLoadError(onRetry: () => unawaited(model.load()))
          else if (model.book != null) ...[
            _PropheciesMeta(book: model.book!),
            const SizedBox(height: AppSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final parts = model.book!.parts;
                final stacked = constraints.maxWidth < 470;
                final cards = [
                  for (final part in parts)
                    _PropheciesPartCard(
                      part: part,
                      onTap: () => _openPart(context, part),
                    ),
                ];
                return stacked
                    ? Column(
                        children: [
                          for (
                            var index = 0;
                            index < cards.length;
                            index++
                          ) ...[
                            cards[index],
                            if (index < cards.length - 1)
                              const SizedBox(height: AppSpacing.md),
                          ],
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (
                            var index = 0;
                            index < cards.length;
                            index++
                          ) ...[
                            Expanded(child: cards[index]),
                            if (index < cards.length - 1)
                              const SizedBox(width: AppSpacing.md),
                          ],
                        ],
                      );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _openPart(BuildContext context, ProphecyPart part) {
    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => PropheciesPartView(part: part)));
  }
}

class _PropheciesMeta extends StatelessWidget {
  const _PropheciesMeta({required this.book});
  final ProphecyBook book;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.md,
    runSpacing: AppSpacing.sm,
    children: [
      _MetaChip(
        icon: Icons.menu_book_rounded,
        label: context.l10n.propheciesPartsCount(book.parts.length.toString()),
      ),
      _MetaChip(
        icon: Icons.format_list_numbered_rounded,
        label: context.l10n.propheciesItemsCount(book.itemCount.toString()),
      ),
    ],
  );
}

class _PropheciesPartCard extends StatelessWidget {
  const _PropheciesPartCard({required this.part, required this.onTap});
  final ProphecyPart part;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = part.partNumber == 1
        ? AppThemeColors.light.cyan
        : AppThemeColors.light.coral;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _PartCover(number: part.partNumber, accent: accent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.propheciesPartLabel(
                        part.partNumber.toString(),
                      ),
                      style: AppTheme.text(context).labelMedium.copyWith(
                        color: accent,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      part.localizedTitle(Localizations.localeOf(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(context).titleSmall.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.propheciesPartItems(
                        part.items.length.toString(),
                      ),
                      style: AppTheme.text(context).bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 17, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartCover extends StatelessWidget {
  const _PartCover({required this.number, required this.accent});
  final int number;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    width: 58,
    height: 76,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [accent, Color.lerp(accent, MyColors.primary, 0.42)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.md),
      boxShadow: [
        BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 10),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 22),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _PropheciesBookMark extends StatelessWidget {
  const _PropheciesBookMark();

  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    height: 62,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE94D8C), Color(0xFF625BF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.base),
      boxShadow: [
        BoxShadow(
          color: AppThemeColors.light.coral.withValues(alpha: 0.24),
          blurRadius: 12,
        ),
      ],
    ),
    child: const Icon(
      Icons.auto_stories_rounded,
      color: Colors.white,
      size: 30,
    ),
  );
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: AppTheme.text(context).labelSmall),
          ],
        ),
      ),
    );
  }
}

class _PropheciesLoadError extends StatelessWidget {
  const _PropheciesLoadError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          context.l10n.propheciesLoadError,
          style: AppTheme.text(context).bodySmall,
        ),
      ),
      TextButton(onPressed: onRetry, child: Text(context.l10n.propheciesRetry)),
    ],
  );
}
