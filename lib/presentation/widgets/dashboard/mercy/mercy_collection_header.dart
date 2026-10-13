import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/mercy/mercy_collection.dart';
import 'mercy_entry_card.dart';

class MercyCollectionContent extends StatelessWidget {
  const MercyCollectionContent({super.key, required this.collection});

  final MercyCollection collection;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final accent = collection.kind == MercyCollectionKind.hadith
        ? colors.coral
        : colors.violet;
    final secondary = collection.kind == MercyCollectionKind.hadith
        ? colors.violet
        : colors.cyan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MercyCollectionHero(
          collection: collection,
          accent: accent,
          secondary: secondary,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: Text(
                collection.kind == MercyCollectionKind.hadith
                    ? context.l10n.dashboardMercyHadithTitle
                    : context.l10n.dashboardMercyStoriesTitle,
                style: AppTheme.text(
                  context,
                ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  context.l10n.mercyEntryCount(
                    collection.entries.length.toString(),
                  ),
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < collection.entries.length; index++) ...[
          MercyEntryCard(
            collection: collection,
            entry: collection.entries[index],
            index: index,
          ),
          if (index < collection.entries.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xl),
        _MercyCollectionFooter(accent: accent),
      ],
    );
  }
}

class _MercyCollectionHero extends StatelessWidget {
  const _MercyCollectionHero({
    required this.collection,
    required this.accent,
    required this.secondary,
  });

  final MercyCollection collection;
  final Color accent;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: Container(
        constraints: const BoxConstraints(minHeight: 218),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(accent, Colors.black, 0.12)!,
              accent,
              Color.lerp(secondary, accent, 0.32)!,
            ],
            stops: const [0, 0.55, 1],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.24),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(right: -28, top: -42, child: _HeroOrb(size: 170)),
            const Positioned(
              left: -46,
              bottom: -60,
              child: _HeroOrb(size: 150),
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Icon(
                collection.kind == MercyCollectionKind.hadith
                    ? Icons.favorite_rounded
                    : Icons.auto_stories_rounded,
                size: 86,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.17),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Icon(
                          collection.kind == MercyCollectionKind.hadith
                              ? Icons.favorite_rounded
                              : Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          context.l10n.dashboardMercyTitle.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).labelMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontWeight: AppTheme.weightExtraBold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            '${collection.entries.length}',
                            style: AppTheme.text(context).labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    collection.localizedTitle(locale),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text(context).headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightExtraBold,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    collection.localizedDescription(locale),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                      height: 1.45,
                    ),
                  ),
                  if (collection.localizedContentNote(locale).isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      collection.localizedContentNote(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(context).labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0),
          ],
        ),
      ),
    ),
  );
}

class _MercyCollectionFooter extends StatelessWidget {
  const _MercyCollectionFooter({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.favorite_border_rounded, size: 16, color: accent),
      const SizedBox(width: AppSpacing.sm),
      Flexible(
        child: Text(
          context.l10n.dashboardMercySubtitle,
          textAlign: TextAlign.center,
          style: AppTheme.text(context).labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: AppTheme.weightSemiBold,
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Icon(Icons.favorite_border_rounded, size: 16, color: accent),
    ],
  );
}
