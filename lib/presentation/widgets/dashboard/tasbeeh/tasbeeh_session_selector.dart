import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_session_picker_sheet.dart';

/// Active-session selector; creating a session is also available in the picker.
class TasbeehSessionSelector extends StatelessWidget {
  const TasbeehSessionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.select(
      (TasbeehViewModel model) => (
        isDefault: model.currentSession.isDefault,
        name: model.currentSession.name,
      ),
    );
    final scheme = Theme.of(context).colorScheme;
    final name = session.isDefault
        ? context.l10n.tasbeehDefaultSession
        : session.name;
    return Tooltip(
      message: '${context.l10n.tasbeehSessions}: $name',
      child: Material(
        color: scheme.primary.withValues(alpha: .06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: scheme.primary.withValues(alpha: .15)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey('tasbeeh_session_picker'),
          onTap: () => showTasbeehSessionPicker(
            context,
            context.read<TasbeehViewModel>(),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.tasbeehSessionLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(
                            context,
                          ).labelSmall.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).labelLarge.copyWith(
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
