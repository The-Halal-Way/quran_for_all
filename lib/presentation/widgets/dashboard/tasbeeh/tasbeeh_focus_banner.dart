import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class TasbeehFocusBanner extends StatelessWidget {
  const TasbeehFocusBanner({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        key: const ValueKey('tasbeeh_enter_focus'),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.viewfinder,
                size: 27,
                color: colors.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.tasbeehEnterFocus,
                      style: text.titleSmall.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.tasbeehTapAnywhere,
                      style: text.bodySmall.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: colors.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
