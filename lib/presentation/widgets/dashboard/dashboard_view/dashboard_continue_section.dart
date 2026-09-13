import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/dashboard/dashboard_viewmodel.dart';
import '../../../viewmodels/learn_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../../views/quran/read_quran/read_quran_view.dart';
import 'dashboard_continue_card.dart';
import 'dashboard_navigation.dart';

class DashboardContinueSection extends StatelessWidget {
  const DashboardContinueSection({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.watch<ReadQuranViewModel>();
    final learn = context.watch<LearnQuranViewModel>();
    final info = DashboardViewModel().continueCardsInfo(
      l10n: context.l10n,
      readViewModel: read,
      learnViewModel: learn,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final singleColumn = constraints.maxWidth < 280 || scale > 1.5;
        final cards = [
          DashboardContinueCard(
            title: context.l10n.dashboardContinueReadingTitle,
            subtitle: info.reading.subtitle,
            detail: info.reading.detail,
            icon: Icons.auto_stories_rounded,
            accent: MyColors.primaryLight,
            onTap: info.reading.hasExistingProgress
                ? () => openDashboardSurah(
                    context,
                    info.reading.surah!,
                    info.reading.ayahNumber,
                  )
                : () => pushDashboardPage(context, const ReadQuranView()),
          ),
          DashboardContinueCard(
            title: context.l10n.dashboardContinueLearningTitle,
            subtitle: info.learning.subtitle,
            detail: info.learning.detail,
            icon: Icons.school_rounded,
            accent: MyColors.tertiaryDark,
            onTap: () => openDashboardLesson(context, learn),
          ),
        ];
        return singleColumn
            ? Column(
                children: [
                  cards.first,
                  const SizedBox(height: AppSpacing.md),
                  cards.last,
                ],
              )
            : Row(
                children: [
                  Expanded(child: cards.first),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: cards.last),
                ],
              );
      },
    );
  }
}
