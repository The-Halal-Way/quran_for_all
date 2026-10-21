import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../data/models/quiz/quiz_result.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import 'quiz_review_card.dart';

class QuizReviewBody extends StatelessWidget {
  const QuizReviewBody({super.key, required this.model});
  final QuizViewModel model;
  @override
  Widget build(BuildContext context) {
    final attempt = model.attempt!;
    final showAll = attempt.config.reviewFlag('showUnknownAndUnanswered');
    final ids = attempt.questionOrder
        .where((id) {
          final status = attempt.responses[id]?.status;
          return showAll || status == QuizResponseStatus.answered;
        })
        .toList(growable: false);
    return ListView.builder(
      padding: EdgeInsets.all(AppResponsive.of(context).padding),
      itemCount: ids.length + 1,
      itemBuilder: (context, index) => index == ids.length
          ? const SizedBox(height: AppSpacing.xl)
          : QuizReviewCard(
              attempt: attempt,
              questionId: ids[index],
              position: attempt.questionOrder.indexOf(ids[index]) + 1,
            ),
    );
  }
}
