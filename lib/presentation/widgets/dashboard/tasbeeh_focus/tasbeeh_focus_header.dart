import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../tasbeeh/tasbeeh_visuals.dart';

class TasbeehFocusHeader extends StatelessWidget {
  const TasbeehFocusHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Row(
      children: [
        IconButton(
          key: const ValueKey('tasbeeh_exit_focus'),
          tooltip: context.l10n.tasbeehExitFocus,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.12),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          ),
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
                  color: Colors.white,
                ),
              ),
              Text(
                context.l10n.tasbeehFocusSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.auto_awesome_rounded, color: TasbeehVisuals.gold),
      ],
    );
  }
}
