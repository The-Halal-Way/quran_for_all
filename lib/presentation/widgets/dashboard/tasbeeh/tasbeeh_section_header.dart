import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class TasbeehSectionHeader extends StatelessWidget {
  const TasbeehSectionHeader({super.key, required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.sparkles, size: 20, color: colors.secondary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                context.l10n.tasbeehPhraseTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(context).dashboardSectionTitle,
              ),
            ),
          ],
        ),
        TextButton.icon(
          key: const ValueKey('tasbeeh_add'),
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(context.l10n.tasbeehAddDhikr),
        ),
      ],
    );
  }
}
