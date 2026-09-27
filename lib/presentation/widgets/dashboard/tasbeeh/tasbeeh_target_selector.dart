import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_target_sheet.dart';

class TasbeehTargetSelector extends StatelessWidget {
  const TasbeehTargetSelector({
    super.key,
    required this.targets,
    required this.selectedTarget,
    required this.onSelected,
  });
  final List<int> targets;
  final int selectedTarget;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final options = {...targets, selectedTarget};
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.scope, color: colors.tertiary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.tasbeehTarget,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final target in options)
                ChoiceChip(
                  label: Text('$target'),
                  selected: target == selectedTarget,
                  onSelected: (_) => onSelected(target),
                ),
              ActionChip(
                key: const ValueKey('tasbeeh_custom_target'),
                avatar: const Icon(Icons.tune_rounded, size: 16),
                label: Text(context.l10n.tasbeehCustomTarget),
                onPressed: () async {
                  final target = await showTasbeehTargetSheet(
                    context,
                    selectedTarget,
                  );
                  if (target != null) onSelected(target);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
