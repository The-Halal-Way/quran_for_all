import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class TasbeehFocusHeader extends StatelessWidget {
  const TasbeehFocusHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Row(
      children: [
        IconButton.filledTonal(
          key: const ValueKey('tasbeeh_exit_focus'),
          tooltip: context.l10n.tasbeehExitFocus,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.tasbeehFocusMode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              Text(
                context.l10n.tasbeehFocusSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.blur_circular_rounded, color: colors.secondary),
      ],
    );
  }
}
