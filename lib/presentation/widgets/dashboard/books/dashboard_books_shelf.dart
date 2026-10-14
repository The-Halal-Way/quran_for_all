import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/books/dashboard_books_library_view.dart';

/// A single, compact shelf for the dashboard's reading library.
///
/// The dashboard only needs to help the user pick a book. Details, downloads,
/// and reading actions stay on [DashboardBooksLibraryView]. Keeping the two
/// previews in one shelf avoids repeating two large cards in the feed.
class DashboardBooksShelf extends StatelessWidget {
  const DashboardBooksShelf({super.key});

  static const _dashboardBooks = [
    _DashboardBookKind.science,
    _DashboardBookKind.prophecies,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;

    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(
              colors.cyan.withValues(alpha: 0.08),
              scheme.surface,
            ),
            Color.alphaBlend(
              colors.violet.withValues(alpha: 0.08),
              scheme.surface,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const _ShelfGlow(alignment: Alignment(-1.12, -1.35)),
          const _ShelfGlow(alignment: Alignment(1.1, 1.45)),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 128),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  for (
                    var index = 0;
                    index < _dashboardBooks.length;
                    index++
                  ) ...[
                    Expanded(
                      child: _DashboardBookPreview(
                        kind: _dashboardBooks[index],
                      ),
                    ),
                    if (index < _dashboardBooks.length - 1)
                      const _ShelfDivider(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelfGlow extends StatelessWidget {
  const _ShelfGlow({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final color = alignment.x < 0 ? colors.cyan : colors.violet;
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.07),
          ),
        ),
      ),
    );
  }
}

class _ShelfDivider extends StatelessWidget {
  const _ShelfDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 82,
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}

enum _DashboardBookKind { science, prophecies }

class _DashboardBookPreview extends StatelessWidget {
  const _DashboardBookPreview({required this.kind});

  final _DashboardBookKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final isScience = kind == _DashboardBookKind.science;
    final accent = isScience ? colors.cyan : colors.coral;
    final title = isScience
        ? context.l10n.scienceInQuranTitle
        : context.l10n.propheciesBookTitle;
    final metadata = isScience
        ? context.l10n.dashboardBookPdf
        : context.l10n.propheciesPartsCount('2');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          AppPageRoute<void>(builder: (_) => const DashboardBooksLibraryView()),
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // On narrow phones the two-column shelf gives each preview only
            // a small width. A horizontal preview keeps the long prophecy
            // title inside its card while retaining the compact shelf height.
            final isNarrow = constraints.maxWidth < 180;
            final info = _BookPreviewInfo(
              title: title,
              metadata: metadata,
              accent: accent,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: isNarrow
                  ? Row(
                      children: [
                        _BookPreviewIcon(
                          kind: kind,
                          accent: accent,
                          compact: true,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(child: info),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_outward_rounded,
                          color: accent,
                          size: 16,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BookPreviewIcon(kind: kind, accent: accent),
                            Icon(
                              Icons.arrow_outward_rounded,
                              color: accent,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        info,
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _BookPreviewInfo extends StatelessWidget {
  const _BookPreviewInfo({
    required this.title,
    required this.metadata,
    required this.accent,
  });

  final String title;
  final String metadata;
  final Color accent;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTheme.text(context).labelLarge.copyWith(
          fontWeight: AppTheme.weightExtraBold,
          height: 1.05,
        ),
      ),
      const SizedBox(height: 2),
      _PreviewMeta(label: metadata, accent: accent),
    ],
  );
}

class _BookPreviewIcon extends StatelessWidget {
  const _BookPreviewIcon({
    required this.kind,
    required this.accent,
    this.compact = false,
  });

  final _DashboardBookKind kind;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 34.0 : 40.0;
    final height = compact ? 42.0 : 48.0;
    final iconSize = compact ? 18.0 : 22.0;

    return Container(
      width: size,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent,
            Color.lerp(accent, AppThemeColors.light.brand, 0.42)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 8,
            right: 7,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.55),
              size: compact ? 8 : 10,
            ),
          ),
          Icon(
            kind == _DashboardBookKind.science
                ? Icons.science_rounded
                : Icons.auto_stories_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ],
      ),
    );
  }
}

class _PreviewMeta extends StatelessWidget {
  const _PreviewMeta({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTheme.text(context).labelSmall.copyWith(
          color: accent,
          fontWeight: AppTheme.weightBold,
          fontSize: 10,
        ),
      ),
    ),
  );
}
