import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/quiz/knowledge_assessment_selection_view.dart';
import '../shared/quiz_orbit_artwork.dart';

/// The dashboard entry is deliberately independent of config and bank loading.
class DashboardQuizSection extends StatelessWidget {
  const DashboardQuizSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    final radius = BorderRadius.circular(AppRadius.xl);
    return Semantics(
      button: true,
      label: l10n.quizAssessmentTitle,
      child: Material(
        color: const Color(0xFF342A79),
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF303E87), Color(0xFF683CB2), Color(0xFF9652AB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: radius,
          ),
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              AppPageRoute<void>(
                builder: (_) => const KnowledgeAssessmentSelectionView(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const QuizOrbitArtwork(size: 72),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quizAssessmentTitle,
                          style: text.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightExtraBold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.quizDashboardSubtitle,
                          style: text.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: .8),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.quizDashboardAction,
                                style: text.labelSmall.copyWith(
                                  color: AppThemeColors.light.cyan,
                                  fontWeight: AppTheme.weightBold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ],
                        ),
                      ],
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
}
