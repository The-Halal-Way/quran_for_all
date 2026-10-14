import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_focus_view.dart';
import '../../common/app_page_scrollbar.dart';
import 'tasbeeh_focus_banner.dart';
import 'tasbeeh_info_grid.dart';
import 'tasbeeh_haptics.dart';
import 'tasbeeh_phrase_actions.dart';
import 'tasbeeh_phrase_picker_sheet.dart';
import 'tasbeeh_phrase_menu.dart';
import 'tasbeeh_widgets.dart';

class TasbeehBody extends StatelessWidget {
  const TasbeehBody({super.key});
  static const _maxContentWidth = 760.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasbeehViewModel>();
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionGap = responsive.isMobile ? 10.0 : responsive.sectionGap;
    if (!vm.isLoaded) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }
    final phrases = vm.phrases;
    final selectedPhraseIndex = phrases.indexWhere(
      (phrase) => phrase.id == vm.selectedPhraseId,
    );

    void selectPhraseAt(int index) {
      if (index < 0 || index >= phrases.length) return;
      TasbeehHaptics.select();
      vm.selectPhrase(phrases[index].id);
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(child: TasbeehBackground(isDark: isDark)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth > _maxContentWidth
                    ? (constraints.maxWidth - _maxContentWidth) / 2
                    : responsive.padding;
                return AppPageScrollbar(
                  builder: (context, controller) => SingleChildScrollView(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 24),
                    child: Column(
                      children: [
                        TasbeehAppBar(isDark: isDark),
                        SizedBox(height: sectionGap),
                        TasbeehCounterDisplay(
                          count: vm.count,
                          target: vm.target,
                          progress: vm.progress,
                          phraseArabic: vm.selectedPhrase.arabic,
                          phraseId: vm.selectedPhraseId,
                          phraseLabel: vm.selectedPhrase.label(context.l10n),
                          phraseMeaning: vm.selectedPhrase.localizedMeaning(
                            context.l10n,
                          ),
                          isTargetReached: vm.isTargetReached,
                          isDark: isDark,
                          onTap: () => TasbeehHaptics.count(
                            targetReached: vm.increment(),
                          ),
                          onPhraseTap: () =>
                              showTasbeehPhrasePicker(context, vm),
                          onAddPhrase: () =>
                              TasbeehPhraseActions.add(context, vm),
                          onPreviousPhrase: selectedPhraseIndex > 0
                              ? () => selectPhraseAt(selectedPhraseIndex - 1)
                              : null,
                          onNextPhrase: selectedPhraseIndex < phrases.length - 1
                              ? () => selectPhraseAt(selectedPhraseIndex + 1)
                              : null,
                          phraseMenu: vm.selectedPhrase.isBuiltIn
                              ? null
                              : TasbeehPhraseMenu(
                                  onSelected: (action) =>
                                      TasbeehPhraseActions.handle(
                                        context,
                                        vm,
                                        vm.selectedPhrase,
                                        action,
                                      ),
                                ),
                        ),
                        SizedBox(height: sectionGap),
                        TasbeehFocusBanner(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const TasbeehFocusView(),
                            ),
                          ),
                        ),
                        SizedBox(height: sectionGap),
                        TasbeehInfoGrid(
                          isWide: constraints.maxWidth >= 700,
                          targetSelector: TasbeehTargetSelector(
                            targets: TasbeehViewModel.targets,
                            selectedTarget: vm.target,
                            onSelected: vm.selectTarget,
                          ),
                          statsPanel: TasbeehStatsPanel(
                            totalCount: vm.totalCount,
                            completedRounds: vm.completedRounds,
                            currentCount: vm.count,
                            selectedPhraseLabel: vm.selectedPhrase.label(
                              context.l10n,
                            ),
                            selectedRounds: vm.currentCompletedRounds,
                            selectedTarget: vm.target,
                            selectedProgress: vm.progress,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TasbeehControls(
                          isDark: isDark,
                          canUndo: vm.count > 0,
                          canResetAll: vm.totalCount > 0,
                          onUndo: vm.decrement,
                          onResetCount: vm.resetCount,
                          onResetAll: vm.resetAll,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
