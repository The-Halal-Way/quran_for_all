import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../tasbeeh/tasbeeh_visuals.dart';
import 'tasbeeh_focus_backdrop.dart';
import 'tasbeeh_focus_controls.dart';
import 'tasbeeh_focus_dhikr_pager.dart';
import '../tasbeeh/tasbeeh_haptics.dart';

class TasbeehFocusBody extends StatelessWidget {
  const TasbeehFocusBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TasbeehViewModel>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GestureDetector(
          key: const ValueKey('tasbeeh_focus_tap_area'),
          behavior: HitTestBehavior.opaque,
          // Child buttons win their gestures, preventing an Undo/Exit tap from counting.
          onTap: () {
            TasbeehHaptics.count(targetReached: model.increment());
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(child: TasbeehFocusBackdrop()),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: TasbeehFocusDhikrPager(
                          phrases: model.phrases,
                          selectedId: model.selectedPhraseId,
                          counts: model.counts,
                          targets: model.selectedTargets,
                          onSelected: model.selectPhrase,
                          onCount: () => TasbeehHaptics.count(
                            targetReached: model.increment(),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            size: 18,
                            color: TasbeehVisuals.mint,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Text(
                              context.l10n.tasbeehTapAnywhere,
                              textAlign: TextAlign.center,
                              style: AppTheme.text(context).labelMedium
                                  .copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TasbeehFocusControls(
                        canUndo: model.count > 0,
                        onUndo: model.decrement,
                        rounds: model.currentCompletedRounds,
                        onExit: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
