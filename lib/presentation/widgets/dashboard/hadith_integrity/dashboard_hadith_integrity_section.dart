import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/hadith_integrity/hadith_integrity_view.dart';
import '../dashboard_view/dashboard_feature_card.dart';
import '../dashboard_view/dashboard_feature_mark.dart';

/// The JSON pack is read only after the user opens [HadithIntegrityView].
class DashboardHadithIntegritySection extends StatelessWidget {
  const DashboardHadithIntegritySection({super.key});

  @override
  Widget build(BuildContext context) => DashboardFeatureCard(
    eyebrow: context.l10n.hadithIntegritySectionTitle,
    title: context.l10n.hadithIntegrityPopularLabel,
    subtitle: context.l10n.hadithIntegrityMisconceptionLabel,
    accent: AppThemeColors.light.cyan,
    leading: DashboardFeatureMark(
      start: AppThemeColors.light.cyan,
      end: AppThemeColors.light.brand,
      child: const Icon(
        Icons.fact_check_rounded,
        color: Colors.white,
        size: 25,
      ),
    ),
    onTap: () => Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => const HadithIntegrityView())),
  );
}
