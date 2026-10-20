import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import 'dashboard_book_kind.dart';
import 'dashboard_book_preview.dart';

/// A compact, horizontally browsable shelf. More books add width, not height.
class DashboardBooksShelf extends StatelessWidget {
  const DashboardBooksShelf({super.key});

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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const _ShelfGlow(alignment: Alignment(-1.12, -1.35)),
          const _ShelfGlow(alignment: Alignment(1.1, 1.45)),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 640 ? 3.0 : 2.15;
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final width = ((constraints.maxWidth - 16) / columns).clamp(
                scale > 1.3 ? 195.0 : 150.0,
                300.0,
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final book in DashboardBookKind.values) ...[
                      if (book != DashboardBookKind.values.first)
                        const _ShelfDivider(),
                      SizedBox(
                        width: width,
                        child: DashboardBookPreview(book: book),
                      ),
                    ],
                  ],
                ),
              );
            },
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
    return Positioned(
      left: alignment.x < 0 ? -15 : null,
      right: alignment.x > 0 ? -15 : null,
      top: -10,
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
