import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/books/dashboard_books_library_view.dart';

/// A compact horizontal shelf for the dashboard.
///
/// Keep future books in [_dashboardBooks]. The full cards live on the library
/// page so the dashboard stays quick to scan.
class DashboardBooksShelf extends StatelessWidget {
  const DashboardBooksShelf({super.key});

  static const _dashboardBooks = [
    _DashboardBookKind.science,
    _DashboardBookKind.prophecies,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth * 0.78).clamp(260.0, 320.0);
        return SizedBox(
          height: 164,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            itemCount: _dashboardBooks.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: cardWidth,
                child: _DashboardBookPreview(kind: _dashboardBooks[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _DashboardBookKind { science, prophecies }

class _DashboardBookPreview extends StatelessWidget {
  const _DashboardBookPreview({required this.kind});

  final _DashboardBookKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final scheme = Theme.of(context).colorScheme;
    final isScience = kind == _DashboardBookKind.science;
    final accent = isScience ? colors.cyan : colors.coral;
    final title = isScience
        ? context.l10n.scienceInQuranTitle
        : context.l10n.propheciesBookTitle;
    final description = isScience
        ? context.l10n.scienceInQuranDescription
        : context.l10n.propheciesBookDescription;
    final metadata = isScience
        ? context.l10n.dashboardBookPdf
        : context.l10n.propheciesPartsCount('2');

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.surface,
              Color.alphaBlend(accent.withValues(alpha: 0.08), scheme.surface),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          border: Border.all(color: accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            AppPageRoute<void>(
              builder: (_) => const DashboardBooksLibraryView(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BookPreviewIcon(kind: kind, accent: accent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(context).titleSmall.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(context).bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          _PreviewChip(
                            icon: isScience
                                ? Icons.picture_as_pdf_rounded
                                : Icons.menu_book_rounded,
                            label: metadata,
                            accent: accent,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: accent,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookPreviewIcon extends StatelessWidget {
  const _BookPreviewIcon({required this.kind, required this.accent});

  final _DashboardBookKind kind;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    height: 70,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [accent, Color.lerp(accent, AppThemeColors.light.brand, 0.42)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.md),
      boxShadow: [
        BoxShadow(color: accent.withValues(alpha: 0.22), blurRadius: 10),
      ],
    ),
    child: Icon(
      kind == _DashboardBookKind.science
          ? Icons.science_rounded
          : Icons.auto_stories_rounded,
      color: Colors.white,
      size: 28,
    ),
  );
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTheme.text(context).labelSmall.copyWith(color: accent),
          ),
        ],
      ),
    ),
  );
}
