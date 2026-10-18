import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_haptics.dart';
import 'tasbeeh_session_actions.dart';
import 'tasbeeh_session_editor.dart';
import 'tasbeeh_session_menu.dart';

Future<void> showTasbeehSessionPicker(
  BuildContext context,
  TasbeehViewModel model,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => ChangeNotifierProvider.value(
    value: model,
    child: const _SessionPickerSheet(),
  ),
);

class _SessionPickerSheet extends StatelessWidget {
  const _SessionPickerSheet();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TasbeehViewModel>();
    final sessions = model.sessions;
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .65,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.tasbeehSessions,
                style: AppTheme.text(
                  context,
                ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.tasbeehSessionsDescription,
                style: AppTheme.text(
                  context,
                ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: sessions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final selected = session.id == model.selectedSessionId;
                    final count = session.progress.counts.length;
                    return Material(
                      color: selected
                          ? scheme.primaryContainer
                          : scheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        selected: selected,
                        leading: Icon(
                          session.isDefault
                              ? Icons.auto_awesome_rounded
                              : Icons.layers_rounded,
                        ),
                        title: Text(
                          session.isDefault
                              ? context.l10n.tasbeehDefaultSession
                              : session.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          context.l10n.tasbeehSessionDhikrCount(
                            NumberFormat.decimalPattern(
                              context.l10n.localeName,
                            ).format(count),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selected)
                              const Icon(Icons.check_circle_rounded),
                            if (!session.isDefault)
                              TasbeehSessionMenu(
                                key: ValueKey(
                                  'tasbeeh_session_menu_${session.id}',
                                ),
                                onSelected: (action) =>
                                    TasbeehSessionActions.handle(
                                      context,
                                      model,
                                      session,
                                      action,
                                    ),
                              ),
                          ],
                        ),
                        onTap: () {
                          TasbeehHaptics.select();
                          model.selectSession(session.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.tasbeehNewSession),
                  onPressed: () async {
                    final previousId = model.selectedSessionId;
                    await createTasbeehSession(context, model);
                    if (context.mounted &&
                        model.selectedSessionId != previousId) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
