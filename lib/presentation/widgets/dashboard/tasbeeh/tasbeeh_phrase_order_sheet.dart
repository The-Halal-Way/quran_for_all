import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_phrase_order_tile.dart';

Future<void> showTasbeehPhraseOrder(
  BuildContext context,
  TasbeehViewModel model,
) {
  final sessionId = model.selectedSessionId;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: AppResponsive.of(context).maxSheetWidth,
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .68,
      minChildSize: .4,
      maxChildSize: .92,
      builder: (context, controller) => _TasbeehPhraseOrderSheet(
        model: model,
        sessionId: sessionId,
        controller: controller,
      ),
    ),
  );
}

class _TasbeehPhraseOrderSheet extends StatelessWidget {
  const _TasbeehPhraseOrderSheet({
    required this.model,
    required this.sessionId,
    required this.controller,
  });

  final TasbeehViewModel model;
  final String sessionId;
  final ScrollController controller;

  void _reorder(int from, int to) {
    if (model.selectedSessionId == sessionId) model.reorderPhrases(from, to);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final phrases = model.selectedSessionId == sessionId
          ? model.phrases
          : const <TasbeehPhrase>[];
      final l10n = context.l10n;
      return SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tasbeehDhikrOrder,
                    style: AppTheme.text(context).titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.tasbeehReorderHint,
                    style: AppTheme.text(context).bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                scrollController: controller,
                buildDefaultDragHandles: false,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: phrases.length,
                onReorder: _reorder,
                itemBuilder: (context, index) => TasbeehPhraseOrderTile(
                  key: ValueKey('$sessionId/${phrases[index].id}'),
                  phrase: phrases[index],
                  index: index,
                  onMoveUp: index > 0 ? () => _reorder(index, index - 1) : null,
                  onMoveDown: index < phrases.length - 1
                      ? () => _reorder(index, index + 2)
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ),
          ],
        ),
      );
    },
  );
}
