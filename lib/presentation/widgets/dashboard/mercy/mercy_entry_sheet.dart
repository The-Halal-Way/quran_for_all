import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/mercy/mercy_collection.dart';

Future<void> showMercyEntrySheet(
  BuildContext context,
  MercyCollection collection,
  MercyEntry entry,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  barrierColor: Colors.black.withValues(alpha: 0.48),
  builder: (_) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.82,
    minChildSize: 0.5,
    maxChildSize: 0.98,
    snap: true,
    snapSizes: const [0.82, 0.98],
    builder: (context, controller) => _MercyEntrySheet(
      collection: collection,
      entry: entry,
      controller: controller,
    ),
  ),
);

class _MercyEntrySheet extends StatelessWidget {
  const _MercyEntrySheet({
    required this.collection,
    required this.entry,
    required this.controller,
  });

  final MercyCollection collection;
  final MercyEntry entry;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final accent = collection.kind == MercyCollectionKind.hadith
        ? colors.coral
        : colors.violet;
    final secondary = collection.kind == MercyCollectionKind.hadith
        ? colors.violet
        : colors.cyan;
    final locale = Localizations.localeOf(context);
    final blocks = entry.localizedBlocks(locale);
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        child: Material(
          color: scheme.surface,
          child: Column(
            children: [
              _SheetHeader(
                title: entry.localizedTitle(locale),
                number: entry.id,
                accent: accent,
                secondary: secondary,
              ),
              Expanded(
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: ListView.separated(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                    ),
                    itemCount: blocks.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) => _MercyBlockView(
                      block: blocks[index],
                      accent: accent,
                      index: index,
                    ),
                  ),
                ),
              ),
              _SheetCloseAction(accent: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.number,
    required this.accent,
    required this.secondary,
  });

  final String title;
  final int number;
  final Color accent;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final overline = context.l10n.dashboardMercyTitle.toUpperCase();
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 166),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(accent, Colors.black, 0.14)!,
              accent,
              Color.lerp(secondary, accent, 0.35)!,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(top: -45, right: -24, child: _SheetOrb(size: 150)),
            Positioned(
              right: 15,
              bottom: -18,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 104,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.17),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              number.toString().padLeft(2, '0'),
                              style: AppTheme.text(context).titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: AppTheme.weightExtraBold,
                              ),
                            ),
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 13,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.text(context).labelSmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontWeight: AppTheme.weightExtraBold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.text(context).titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: AppTheme.weightExtraBold,
                                height: 1.12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetOrb extends StatelessWidget {
  const _SheetOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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

class _SheetCloseAction extends StatelessWidget {
  const _SheetCloseAction({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.sm,
      AppSpacing.xl,
      AppSpacing.lg,
    ),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        icon: const Icon(Icons.check_rounded),
        label: Text(MaterialLocalizations.of(context).closeButtonLabel),
      ),
    ),
  );
}

class _MercyBlockView extends StatelessWidget {
  const _MercyBlockView({
    required this.block,
    required this.accent,
    required this.index,
  });

  final MercyBlock block;
  final Color accent;
  final int index;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    switch (block.type) {
      case 'source_title':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Icon(Icons.menu_book_rounded, color: accent, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  block.text,
                  style: text.titleSmall.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'section_heading':
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            block.text,
            style: text.titleMedium.copyWith(
              color: accent,
              fontWeight: AppTheme.weightExtraBold,
              height: 1.25,
            ),
          ),
        );
      case 'quote':
      case 'verse_or_scripture':
      case 'highlight':
      case 'hadith_reference':
        return _EmphasisBlock(block: block, accent: accent);
      default:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: index.isEven
                ? accent.withValues(alpha: 0.035)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(block.text, style: text.bodyLarge.copyWith(height: 1.62)),
        );
    }
  }
}

class _EmphasisBlock extends StatelessWidget {
  const _EmphasisBlock({required this.block, required this.accent});

  final MercyBlock block;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isQuote = block.type == 'quote';
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.11),
            accent.withValues(alpha: 0.035),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                block.text,
                style: AppTheme.text(context).bodyLarge.copyWith(
                  height: 1.62,
                  fontStyle: isQuote ? FontStyle.italic : null,
                  fontWeight: block.type == 'hadith_reference'
                      ? AppTheme.weightSemiBold
                      : null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              isQuote ? Icons.format_quote_rounded : Icons.auto_awesome_rounded,
              color: accent.withValues(alpha: 0.52),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
