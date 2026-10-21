import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../shared/quiz_language_picker.dart';
import 'quiz_history_tile.dart';
import 'quiz_intro_hero.dart';
import '../../shared/quiz_notice.dart';
import 'quiz_quota_card.dart';
import 'quiz_resume_card.dart';

class QuizOverviewBody extends StatelessWidget {
  const QuizOverviewBody({super.key, required this.model});
  final QuizViewModel model;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final padding = AppResponsive.of(context).padding;
    final config = model.config;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            padding,
            AppSpacing.sm,
            padding,
            AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (config != null) ...[
                  QuizIntroHero(config: config),
                  const SizedBox(height: AppSpacing.md),
                  if (!config.approvedStatuses.contains(
                    config.section('contentReview')['currentBankStatus'],
                  )) ...[
                    QuizNotice(
                      message: kReleaseMode
                          ? l10n.quizErrorReview
                          : l10n.quizPreviewNotice,
                      icon: Icons.edit_note_rounded,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
                if (model.active case final active?) ...[
                  QuizResumeCard(
                    attempt: active,
                    busy: model.busy,
                    onResume: model.resume,
                    onDiscard: model.discard,
                  ),
                ] else if (config != null) ...[
                  QuizLanguagePicker(
                    config: config,
                    language: model.language,
                    onChanged: model.canChooseLanguage
                        ? model.changeLanguage
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: model.canStart && !model.busy
                        ? model.start
                        : null,
                    icon: model.busy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        model.busy ? l10n.quizPreparing : l10n.quizStart,
                      ),
                    ),
                  ),
                  if (model.history.isNotEmpty && !config.retakeEnabled)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        l10n.quizRetakeDisabled,
                        style: AppTheme.text(context).bodySmall,
                      ),
                    ),
                  if (model.nextAttemptAt case final date?)
                    if (DateTime.now().toUtc().isBefore(date))
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          l10n.quizAvailableAfter(
                            DateFormat.yMMMd(
                              l10n.localeName,
                            ).add_Hm().format(date.toLocal()),
                          ),
                          style: AppTheme.text(context).bodySmall,
                        ),
                      ),
                ],
                const SizedBox(height: AppSpacing.md),
                QuizNotice(message: l10n.quizSampleNotice),
                if (config != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  QuizQuotaCard(config: config),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.quizHistory,
                  style: AppTheme.text(
                    context,
                  ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
                ),
                if (model.history.isEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.quizHistoryEmpty,
                    style: AppTheme.text(context).bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverList.builder(
            itemCount: model.history.length,
            itemBuilder: (context, index) => QuizHistoryTile(
              summary: model.history[index],
              onTap: model.busy
                  ? null
                  : () => model.openHistory(model.history[index].id),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
      ],
    );
  }
}
