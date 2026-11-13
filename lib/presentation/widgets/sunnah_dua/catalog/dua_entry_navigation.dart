import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'dua_catalog_visuals.dart';

class DuaEntryNavigation extends StatelessWidget {
  const DuaEntryNavigation({
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
    final text = AppTheme.text(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: .6)),
        ),
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
                tooltip: context.l10n.duaPrevious,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        context.l10n.duaReaderPosition(
                          duaNumber(context, index + 1),
                          duaNumber(context, total),
                        ),
                        style: text.labelMedium.copyWith(
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Tooltip(
                      message: context.l10n.duaSwipeHint,
                      child: _PositionDots(index: index, total: total),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.filledTonal(
                onPressed: onNext,
                tooltip: context.l10n.duaNext,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A window of dots keeps the All category usable with hundreds of entries.
class _PositionDots extends StatelessWidget {
  const _PositionDots({required this.index, required this.total});
  final int index, total;

  @override
  Widget build(BuildContext context) {
    final count = total < 7 ? total : 7;
    final start = (index - count ~/ 2).clamp(0, total - count);
    final scheme = Theme.of(context).colorScheme;
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
                color: start + offset == index
                    ? scheme.primary
                    : scheme.primary.withValues(alpha: .22),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
        ],
      ),
    );
  }
}
