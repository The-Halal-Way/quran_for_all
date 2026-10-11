import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'science_in_quran_labels.dart';

class ScienceInQuranReaderControls extends StatelessWidget {
  const ScienceInQuranReaderControls({
    super.key,
    required this.page,
    required this.pageCount,
    required this.ready,
    required this.onPrevious,
    required this.onNext,
    required this.onJump,
  });

  final int page;
  final int pageCount;
  final bool ready;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onJump;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: ready && page > 1 ? onPrevious : null,
                    tooltip: context.l10n.scienceInQuranPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextButton(
                      onPressed: ready ? onJump : null,
                      child: Text(
                        pageCount > 0
                            ? context.l10n.scienceInQuranPageCounter(
                                scienceNumber(context, page),
                                scienceNumber(context, pageCount),
                              )
                            : context.l10n.scienceInQuranTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    onPressed: ready && page < pageCount ? onNext : null,
                    tooltip: context.l10n.scienceInQuranNext,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              Text(
                context.l10n.scienceInQuranReaderHint,
                textAlign: TextAlign.center,
                style: AppTheme.text(
                  context,
                ).labelSmall.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
