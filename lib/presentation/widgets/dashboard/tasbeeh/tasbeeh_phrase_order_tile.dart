import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import 'tasbeeh_phrase_localizer.dart';

class TasbeehPhraseOrderTile extends StatelessWidget {
  const TasbeehPhraseOrderTile({
    super.key,
    required this.phrase,
    required this.index,
    this.onMoveUp,
    this.onMoveDown,
  });

  final TasbeehPhrase phrase;
  final int index;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            0,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Text(
                  NumberFormat.decimalPattern(
                    l10n.localeName,
                  ).format(index + 1),
                  style: text.labelMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phrase.label(l10n),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge,
                    ),
                    if (phrase.arabic.isNotEmpty)
                      Text(
                        phrase.arabic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.amiri(context, fontSize: 22),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onMoveUp,
                    tooltip: l10n.tasbeehMoveUp,
                    icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  ),
                  IconButton(
                    onPressed: onMoveDown,
                    tooltip: l10n.tasbeehMoveDown,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
              ReorderableDragStartListener(
                index: index,
                child: Tooltip(
                  message: l10n.tasbeehDragToReorder,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Icon(
                      Icons.drag_handle_rounded,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
