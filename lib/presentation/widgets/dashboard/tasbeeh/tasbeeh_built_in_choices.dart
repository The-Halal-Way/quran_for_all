import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import 'tasbeeh_phrase_localizer.dart';

class TasbeehBuiltInChoices extends StatelessWidget {
  const TasbeehBuiltInChoices({
    super.key,
    required this.phrases,
    required this.onSelected,
  });

  final List<TasbeehPhrase> phrases;
  final ValueChanged<TasbeehPhrase> onSelected;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.tasbeehBuiltIn,
          style: text.titleSmall.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(context.l10n.tasbeehBuiltInAddHint, style: text.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final phrase in phrases)
              ActionChip(
                avatar: const Icon(Icons.add_rounded, size: 18),
                label: Text(phrase.label(context.l10n)),
                onPressed: () => onSelected(phrase),
              ),
          ],
        ),
      ],
    );
  }
}
