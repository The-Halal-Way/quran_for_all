import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import 'ruqyah_style.dart';

String ruqyahEvidenceText(BuildContext context, String basis) =>
    switch (basis) {
      'prophetic_practice' => context.l10n.ruqyahReportedPractice,
      'quran_context' => context.l10n.ruqyahQuranContext,
      'scholarly_guidance' => context.l10n.ruqyahScholarlyGuidance,
      _ => context.l10n.ruqyahAppGuidance,
    };

class RuqyahEvidenceLabel extends StatelessWidget {
  const RuqyahEvidenceLabel({super.key, required this.basis});
  final String basis;
  @override
  Widget build(BuildContext context) => Text(
    ruqyahEvidenceText(context, basis),
    style: AppTheme.text(context).labelSmall.copyWith(
      color: RuqyahStyle.accent(context),
      fontWeight: FontWeight.w700,
    ),
  );
}
