import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/quiz/shared/quiz_labels.dart';
import '../../../widgets/quiz/shared/quiz_language.dart';
import '../../../widgets/quiz/shared/quiz_notice.dart';
import '../../../widgets/quiz/assessment/overview/quiz_overview_body.dart';
import '../../../widgets/quiz/assessment/questions/quiz_questions_body.dart';
import '../../../widgets/quiz/assessment/results/quiz_results_body.dart';
import '../../../widgets/quiz/assessment/results/quiz_review_body.dart';
import '../../../widgets/quiz/assessment/shared/quiz_top_bar.dart';

class KnowledgeAssessmentView extends StatefulWidget {
  const KnowledgeAssessmentView({super.key, required this.assessment});
  final QuizAssessmentDefinition assessment;
  @override
  State<KnowledgeAssessmentView> createState() =>
      _KnowledgeAssessmentViewState();
}

class _KnowledgeAssessmentViewState extends State<KnowledgeAssessmentView> {
  late final _model = QuizViewModel(assessment: widget.assessment);
  bool _started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final language = Localizations.localeOf(context).languageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_model.load(language));
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _model,
    builder: (context, _) => Localizations.override(
      context: context,
      locale: QuizLanguage.uiLocale(_model.language),
      child: Builder(builder: (context) => _page(context)),
    ),
  );

  void _back(BuildContext context) {
    if (_model.busy) return;
    if (_model.screen == QuizScreen.overview) {
      Navigator.of(context).maybePop();
    } else {
      _model.back();
    }
  }

  Widget _page(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_model.busy && _model.screen == QuizScreen.overview,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back(context);
      },
      child: Scaffold(
        body: AppPremiumPageBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  children: [
                    QuizTopBar(model: _model, onBack: () => _back(context)),
                    if (_model.error case final failure?)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * .25,
                          ),
                          child: SingleChildScrollView(
                            child: QuizNotice(
                              message: QuizLabels.failure(l10n, failure.code),
                              color: Theme.of(context).colorScheme.error,
                              icon: Icons.info_outline_rounded,
                              action: TextButton(
                                onPressed: _model.busy
                                    ? null
                                    : () {
                                        if (_model.screen ==
                                            QuizScreen.overview) {
                                          _model.load(_model.language);
                                        } else {
                                          _model.clearError();
                                        }
                                      },
                                child: Text(
                                  _model.screen == QuizScreen.overview
                                      ? l10n.quizRetry
                                      : MaterialLocalizations.of(
                                          context,
                                        ).closeButtonLabel,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _model.loading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(l10n.quizLoading),
                                ],
                              ),
                            )
                          : switch (_model.screen) {
                              QuizScreen.overview => QuizOverviewBody(
                                model: _model,
                              ),
                              QuizScreen.questions => QuizQuestionsBody(
                                model: _model,
                              ),
                              QuizScreen.results => QuizResultsBody(
                                model: _model,
                              ),
                              QuizScreen.review => QuizReviewBody(
                                model: _model,
                              ),
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
