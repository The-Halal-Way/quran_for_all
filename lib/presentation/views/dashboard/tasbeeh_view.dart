import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_widgets.dart';

class TasbeehView extends StatelessWidget {
  const TasbeehView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TasbeehViewModel>(
      create: (_) => TasbeehViewModel(),
      child: const _TasbeehBody(),
    );
  }
}

class _TasbeehBody extends StatelessWidget {
  const _TasbeehBody();

  static const double _maxContentWidth = 760;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasbeehViewModel>();
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPhrase = vm.selectedPhrase;
    final phraseLabel = selectedPhrase.key.label(context.l10n);

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
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      16,
                      horizontal,
                      96,
                    ),
                    child: Column(
                      children: [
                        TasbeehAppBar(isDark: isDark),
                        SizedBox(height: responsive.sectionGap + 6),
                        TasbeehCounterDisplay(
                          count: vm.count,
                          target: vm.target,
                          progress: vm.progress,
                          phraseArabic: selectedPhrase.arabic,
                          phraseLabel: phraseLabel,
                          isTargetReached: vm.isTargetReached,
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            vm.increment();
                          },
                        ),
                        SizedBox(height: responsive.sectionGap + 4),
                        TasbeehPhraseSelector(
                          phrases: TasbeehViewModel.phrases,
                          selectedKey: vm.selectedPhraseKey,
                          isDark: isDark,
                          onSelected: vm.selectPhrase,
                        ),
                        SizedBox(height: responsive.sectionGap),
                        _TasbeehInfoGrid(
                          isWide: constraints.maxWidth >= 700,
                          targetSelector: TasbeehTargetSelector(
                            targets: TasbeehViewModel.targets,
                            selectedTarget: vm.target,
                            isDark: isDark,
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
                          canUndo: vm.count > 0 || vm.totalCount > 0,
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
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: MyColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () {
          HapticFeedback.lightImpact();
          vm.increment();
        },
        child: const Icon(Icons.touch_app_rounded),
      ),
    );
  }
}

class _TasbeehInfoGrid extends StatelessWidget {
  const _TasbeehInfoGrid({
    required this.isWide,
    required this.targetSelector,
    required this.statsPanel,
  });

  final bool isWide;
  final Widget targetSelector;
  final Widget statsPanel;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: [targetSelector, const SizedBox(height: 12), statsPanel],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: targetSelector),
        const SizedBox(width: 12),
        Expanded(child: statsPanel),
      ],
    );
  }
}
