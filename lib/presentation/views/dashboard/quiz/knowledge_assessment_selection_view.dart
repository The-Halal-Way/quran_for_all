import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/quiz/selection/quiz_audience_section.dart';
import '../../../widgets/quiz/selection/quiz_coming_soon_sheet.dart';
import '../../../widgets/quiz/selection/quiz_selection_header.dart';
import 'knowledge_assessment_view.dart';

/// A static catalog: no config, banks, database, or attempt is opened here.
class KnowledgeAssessmentSelectionView extends StatelessWidget {
  const KnowledgeAssessmentSelectionView({super.key});

  void _select(BuildContext context, QuizAudience audience, QuizLevel level) {
    final assessment = QuizCatalog.find(audience, level);
    if (assessment == null) {
      showQuizComingSoon(context, audience, level);
      return;
    }
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => KnowledgeAssessmentView(assessment: assessment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppPremiumPageBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      BackButton(onPressed: () => Navigator.maybePop(context)),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          context.l10n.quizAssessmentTitle,
                          style: AppTheme.text(context).titleSmall.copyWith(
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppResponsive.of(context).padding),
                    itemCount: QuizAudience.values.length + 1,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (context, index) {
                      if (index == 0) return const QuizSelectionHeader();
                      final audience = QuizAudience.values[index - 1];
                      return QuizAudienceSection(
                        audience: audience,
                        onSelect: (level) => _select(context, audience, level),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
