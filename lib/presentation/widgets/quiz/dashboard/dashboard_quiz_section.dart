import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/quiz/knowledge_assessment_selection_view.dart';
import '../../dashboard/dashboard_view/dashboard_feature_card.dart';
import '../../dashboard/dashboard_view/dashboard_feature_mark.dart';
import '../shared/quiz_orbit_artwork.dart';

/// The dashboard entry is deliberately independent of config and bank loading.
class DashboardQuizSection extends StatelessWidget {
  const DashboardQuizSection({super.key});

  @override
  Widget build(BuildContext context) => DashboardFeatureCard(
    title: context.l10n.quizAssessmentTitle,
    subtitle: context.l10n.quizDashboardAction,
    accent: AppThemeColors.light.violet,
    leading: DashboardFeatureMark(
      start: AppThemeColors.light.brand,
      end: AppThemeColors.light.violet,
      child: const QuizOrbitArtwork(size: 44),
    ),
    onTap: () => Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => const KnowledgeAssessmentSelectionView(),
      ),
    ),
  );
}
