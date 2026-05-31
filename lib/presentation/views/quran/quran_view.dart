import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/quran/quran_hub_models.dart';
import '../../viewmodels/learn_quran_viewmodel.dart';
import '../../viewmodels/quran/quran_viewmodel.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/quran/quran_hadith_card.dart';
import '../../widgets/quran/quran_hub_hero.dart';
import '../../widgets/quran/quran_path_card.dart';
import '../learn_quran/learn_quran_view.dart';
import '../read_quran/read_quran_view.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final readViewModel = context.read<ReadQuranViewModel>();
      if (readViewModel.surahs.isEmpty && !readViewModel.isLoading) {
        unawaited(readViewModel.load(showLoading: false));
      }

      final learnViewModel = context.read<LearnQuranViewModel>();
      if (learnViewModel.isLoading) {
        unawaited(learnViewModel.initialize());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final readViewModel = context.watch<ReadQuranViewModel>();
    final learnViewModel = context.watch<LearnQuranViewModel>();
    final content = context.read<QuranViewModel>().content(
      l10n: l10n,
      readViewModel: readViewModel,
      learnViewModel: learnViewModel,
    );

    return Scaffold(
      body: SafeArea(
        child: AppGradientBackground(
          child: RefreshIndicator(
            color: MyColors.secondary,
            onRefresh: _refresh,
            child: AppPageScrollbar(
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.sm + 2,
                  responsive.padding,
                  AppSpacing.lg,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxReadingContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuranHubHero(
                          title: l10n.quranHubTitle,
                          eyebrow: l10n.quranHubHeroEyebrow,
                          arabicTitle: l10n.quranHubHeroArabic,
                          body: l10n.quranHubHeroBody,
                          stats: content.stats,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(
                          title: l10n.quranHubSectionChooseTitle,
                          subtitle: l10n.quranHubSectionChooseSubtitle,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _PathCards(
                          actions: content.actions,
                          onSelected: _openDestination,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(
                          title: l10n.quranHubHadithTitle,
                          subtitle: l10n.quranHubHadithSubtitle,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        for (final hadith in content.hadiths)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: QuranHadithCard(hadith: hadith),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<ReadQuranViewModel>().load(showLoading: false),
      context.read<LearnQuranViewModel>().initialize(),
    ]);
  }

  void _openDestination(QuranHubDestination destination) {
    final page = switch (destination) {
      QuranHubDestination.read => const ReadQuranView(),
      QuranHubDestination.learn => const LearnQuranView(),
    };

    Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));
  }
}

class _PathCards extends StatelessWidget {
  const _PathCards({required this.actions, required this.onSelected});

  final List<QuranHubAction> actions;
  final ValueChanged<QuranHubDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                QuranPathCard(
                  action: actions[index],
                  onTap: () => onSelected(actions[index].destination),
                ),
                if (index < actions.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              Expanded(
                child: QuranPathCard(
                  action: actions[index],
                  onTap: () => onSelected(actions[index].destination),
                ),
              ),
              if (index < actions.length - 1)
                const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}
