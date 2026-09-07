import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';

class PowerfulDuahNote extends StatelessWidget {
  const PowerfulDuahNote({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.duahPowerfulImportantNoteTitle;
    final body = context.l10n.duahPowerfulImportantNoteBody;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '$title. $body',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () => _showNote(context, title, body),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: MyColors.primaryLight.withValues(alpha: 0.075),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: MyColors.primaryLight.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: MyColors.primaryLight,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text(
                      context,
                    ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: MyColors.primaryLight,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNote(BuildContext context, String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.text(
                context,
              ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              body,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
