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
    final options = {...targets, selectedTarget}.toList()..sort();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$selectedTarget',
                  style: AppTheme.text(context).labelLarge.copyWith(
                    color: colors.tertiary,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('tasbeeh_custom_target'),
                tooltip: context.l10n.tasbeehCustomTarget,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colors.tertiary,
                ),
                icon: const Icon(Icons.tune_rounded, size: 18),
                onPressed: () => _openCustomTarget(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 38,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (var index = 0; index < options.length; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.xs),
                    ChoiceChip(
                      label: Text('${options[index]}'),
                      selected: options[index] == selectedTarget,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      onSelected: (_) => onSelected(options[index]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCustomTarget(BuildContext context) async {
    final target = await showTasbeehTargetSheet(context, selectedTarget);
    if (target != null) onSelected(target);
  }
}
