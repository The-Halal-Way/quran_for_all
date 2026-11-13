import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../catalog/dua_catalog_visuals.dart';

class SunnahEntryNavigation extends StatelessWidget {
  const SunnahEntryNavigation({
    super.key,
    required this.index,
    required this.total,
    required this.categoryTitle,
    this.onPrevious,
    this.onNext,
  });
  final int index, total;
  final String categoryTitle;
  final VoidCallback? onPrevious, onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: onPrevious,
                tooltip: context.l10n.sunnahPrevious,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(
                        context,
                      ).labelSmall.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        context.l10n.sunnahReaderPosition(
                          duaNumber(context, index + 1),
                          duaNumber(context, total),
                        ),
                        style: AppTheme.text(
                          context,
                        ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Tooltip(
                      message: context.l10n.sunnahSwipeHint,
                      child: _Dots(index: index, total: total),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: onNext,
                tooltip: context.l10n.sunnahNext,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.index, required this.total});
  final int index, total;

  @override
  Widget build(BuildContext context) {
    final count = total < 7 ? total : 7;
    final start = (index - count ~/ 2).clamp(0, total - count);
    final color = Theme.of(context).colorScheme.primary;
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var offset = 0; offset < count; offset++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: start + offset == index ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: start + offset == index ? 1 : .22,
                ),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
        ],
      ),
    );
  }
}
