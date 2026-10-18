import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../common/app_language_action_button.dart';
import 'tasbeeh_auto_next_button.dart';
import 'tasbeeh_session_editor.dart';
import 'tasbeeh_session_selector.dart';

/// A single toolbar for navigation, the active session, and reader actions.
class TasbeehHeader extends StatelessWidget {
  const TasbeehHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final autoNext = context.select(
      (TasbeehViewModel vm) => vm.autoNextEnabled,
    );
    final model = context.read<TasbeehViewModel>();
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(CupertinoIcons.chevron_back, size: 21),
            style: IconButton.styleFrom(
              foregroundColor: scheme.onSurface,
              backgroundColor: scheme.surfaceContainerHighest.withValues(
                alpha: .8,
              ),
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Expanded(child: TasbeehSessionSelector()),
          if (constraints.maxWidth >= 460 &&
              MediaQuery.textScalerOf(context).scale(14) < 20)
            IconButton(
              key: const ValueKey('tasbeeh_new_session'),
              tooltip: context.l10n.tasbeehNewSession,
              onPressed: () => createTasbeehSession(context, model),
              icon: const Icon(Icons.add_rounded),
              color: scheme.primary,
            ),
          TasbeehAutoNextButton(
            enabled: autoNext,
            onChanged: model.setAutoNext,
            compact: true,
          ),
          const _LanguageToggleAction(),
        ],
      ),
    );
  }
}

class _LanguageToggleAction extends StatelessWidget {
  const _LanguageToggleAction();

  @override
  Widget build(BuildContext context) {
    final language = context.select(
      (SettingsViewModel vm) => vm.settings.language,
    );
    return AppLanguageActionButton(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      current: language,
      iconColor: Theme.of(context).colorScheme.onSurface,
      onSelected: context.read<SettingsViewModel>().setLanguage,
    );
  }
}
