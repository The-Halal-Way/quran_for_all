import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../tasbeeh/tasbeeh_background.dart';
import 'tasbeeh_focus_controls.dart';
import 'tasbeeh_focus_counter.dart';
import 'tasbeeh_focus_header.dart';

class TasbeehFocusBody extends StatelessWidget {
  const TasbeehFocusBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TasbeehViewModel>();
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        key: const ValueKey('tasbeeh_focus_tap_area'),
        behavior: HitTestBehavior.opaque,
        // Child buttons win their gestures, preventing an Undo/Exit tap from counting.
        onTap: () {
          HapticFeedback.selectionClick();
          model.increment();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: TasbeehBackground(
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  children: [
                    const TasbeehFocusHeader(),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: context.l10n.tasbeehCountAction,
                        onTap: model.increment,
                        child: TasbeehFocusCounter(model: model),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.tasbeehTapAnywhere,
                      textAlign: TextAlign.center,
                      style: AppTheme.text(
                        context,
                      ).bodySmall.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    TasbeehFocusControls(
                      canUndo: model.count > 0,
                      onUndo: model.decrement,
                      rounds: model.currentCompletedRounds,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
