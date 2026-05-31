import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';

class SunnahDuaDetailSheet extends StatelessWidget {
  const SunnahDuaDetailSheet({
    super.key,
    required this.item,
    required this.kindLabel,
    this.controller,
  });

  final SunnahDuaItem item;
  final String kindLabel;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _DetailHeader(item: item, kindLabel: kindLabel),
            const SizedBox(height: AppSpacing.lg),
            if (item.sunnahPoints.isNotEmpty)
              _DetailBlock(
                label: context.l10n.sunnahDuaSunnahPointsLabel,
                child: _SunnahPointList(points: item.sunnahPoints),
              ),
            if (item.hasRelatedDua)
              _DetailBlock(
                label: context.l10n.sunnahDuaRelatedDuaLabel,
                child: _RelatedDuaContent(item: item),
              )
            else if (item.arabic.isNotEmpty)
              _DetailBlock(
                label: context.l10n.sunnahDuaArabicLabel,
                child: Text(
                  item.arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: text.duahCardArabic.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0,
                  ),
                ),
              ),
            if (!item.hasRelatedDua && item.pronunciation.isNotEmpty)
              _DetailBlock(
                label: context.l10n.sunnahDuaPronunciationLabel,
                child: Text(
                  item.pronunciation,
                  style: text.duahCardBodyItalic.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.78),
                    letterSpacing: 0,
                  ),
                ),
              ),
            if (!item.hasRelatedDua && item.translation.isNotEmpty)
              _DetailBlock(
                label: context.l10n.sunnahDuaTranslationLabel,
                child: Text(
                  item.translation,
                  style: text.duahCardBody.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0,
                  ),
                ),
              ),
            _DetailBlock(
              label: context.l10n.sunnahDuaPracticeLabel,
              child: Text(
                item.practice,
                style: text.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.74),
                  height: 1.45,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunnahPointList extends StatelessWidget {
  const _SunnahPointList({required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (var index = 0; index < points.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == points.length - 1 ? 0 : 9,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: text.labelSmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: AppTheme.weightBlack,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    points[index],
                    style: text.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.78),
                      height: 1.45,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RelatedDuaContent extends StatelessWidget {
  const _RelatedDuaContent({required this.item});

  final SunnahDuaItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.relatedDuaTitle,
          style: text.labelMedium.copyWith(
            color: item.accent,
            fontWeight: AppTheme.weightBlack,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            item.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: text.duahCardArabic.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0,
            ),
          ),
        ),
        if (item.pronunciation.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.pronunciation,
            style: text.duahCardBodyItalic.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              letterSpacing: 0,
            ),
          ),
        ],
        if (item.translation.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.translation,
            style: text.duahCardBody.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0,
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.item, required this.kindLabel});

  final SunnahDuaItem item;
  final String kindLabel;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(item.icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kindLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontWeight: AppTheme.weightBlack,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightBlack,
                        height: 1.08,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            item.subtitle,
            style: text.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: AppTheme.weightSemiBold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Text(
              '${context.l10n.sunnahDuaSourceLabel}: ${item.source}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.weightBold,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: text.labelSmall.copyWith(
                  color: colorScheme.primary,
                  fontWeight: AppTheme.weightBlack,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
