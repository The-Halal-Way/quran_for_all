import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../../../views/dashboard/tasbeeh/tasbeeh_focus_view.dart';
import '../../common/app_page_scrollbar.dart';
import 'tasbeeh_focus_banner.dart';
import 'tasbeeh_info_grid.dart';
import 'tasbeeh_phrase_actions.dart';
import 'tasbeeh_widgets.dart';

class TasbeehBody extends StatelessWidget {
  const TasbeehBody({super.key});
  static const _maxContentWidth = 760.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasbeehViewModel>();
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!vm.isLoaded) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
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
                    padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 48),
                    child: Column(
                      children: [
                        TasbeehAppBar(isDark: isDark),
                        SizedBox(height: responsive.sectionGap),
                        TasbeehCounterDisplay(
                          count: vm.count,
                          target: vm.target,
                          progress: vm.progress,
                          phraseArabic: vm.selectedPhrase.arabic,
                          phraseLabel: vm.selectedPhrase.label(context.l10n),
                          phraseMeaning: vm.selectedPhrase.localizedMeaning(
                            context.l10n,
                          ),
                          isTargetReached: vm.isTargetReached,
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            vm.increment();
                          },
                        ),
                        SizedBox(height: responsive.sectionGap),
                        TasbeehFocusBanner(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const TasbeehFocusView(),
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.sectionGap + 4),
                        TasbeehPhraseSelector(
                          phrases: vm.phrases,
                          selectedId: vm.selectedPhraseId,
                          counts: vm.counts,
                          targets: vm.selectedTargets,
                          onSelected: vm.selectPhrase,
                          onAdd: () => TasbeehPhraseActions.add(context, vm),
                          onAction: (phrase, action) =>
                              TasbeehPhraseActions.handle(
                                context,
                                vm,
                                phrase,
                                action,
                              ),
                        ),
                        SizedBox(height: responsive.sectionGap),
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
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(height: responsive.sectionGap),
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
