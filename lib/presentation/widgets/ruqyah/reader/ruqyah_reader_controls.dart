import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';
import '../shared/ruqyah_style.dart';

class RuqyahReaderControls extends StatelessWidget {
  const RuqyahReaderControls({
    super.key,
    required this.model,
    required this.onPage,
  });
  final RuqyahReaderViewModel model;
  final ValueChanged<int> onPage;
  @override
  Widget build(BuildContext context) {
    final target = model.step.count;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: model.index > 0
                        ? () => onPage(model.index - 1)
                        : null,
                    tooltip: context.l10n.ruqyahPrevious,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.ruqyahPosition(
                            RuqyahStyle.number(context, model.index + 1),
                            RuqyahStyle.number(context, model.length),
                          ),
                          style: AppTheme.text(context).labelMedium,
                        ),
                        if ((model.routine?.cycles ?? 1) > 1)
                          Text(
                            context.l10n.ruqyahCycle(
                              RuqyahStyle.number(
                                context,
                                model.routine!.cycleAt(model.index),
                              ),
                              RuqyahStyle.number(
                                context,
                                model.routine!.cycles,
                              ),
                            ),
                            style: AppTheme.text(context).labelSmall.copyWith(
                              color: RuqyahStyle.accent(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: model.index + 1 < model.length
                        ? () => onPage(model.index + 1)
                        : null,
                    tooltip: context.l10n.ruqyahNext,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              if (target != null) ...[
                Row(
                  children: [
                    IconButton(
                      onPressed: model.count > 0 ? model.undo : null,
                      tooltip: context.l10n.ruqyahUndo,
                      icon: const Icon(Icons.undo_rounded),
                    ),
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: model.count < target
                            ? model.increment
                            : null,
                        child: Text(
                          '${context.l10n.ruqyahCountTap}  ${RuqyahStyle.number(context, model.count)} / ${RuqyahStyle.number(context, target)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: model.canAdvance ? model.advance : null,
                  child: Text(
                    model.index == model.length - 1
                        ? context.l10n.ruqyahFinish
                        : target == null
                        ? (model.reading == null
                              ? context.l10n.ruqyahDoneContinue
                              : context.l10n.ruqyahReadContinue)
                        : context.l10n.ruqyahNext,
                    textAlign: TextAlign.center,
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
