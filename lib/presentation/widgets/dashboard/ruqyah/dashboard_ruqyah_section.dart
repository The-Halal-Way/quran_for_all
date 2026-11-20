import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/ruqyah/ruqyah_view.dart';
import '../../ruqyah/shared/ruqyah_style.dart';
import '../dashboard_view/dashboard_feature_card.dart';
import '../dashboard_view/dashboard_feature_mark.dart';

/// No content or audio is loaded until this destination is opened.
class DashboardRuqyahSection extends StatelessWidget {
  const DashboardRuqyahSection({super.key});
  @override
  Widget build(BuildContext context) => DashboardFeatureCard(
    title: context.l10n.ruqyahTitle,
    subtitle: context.l10n.ruqyahSubtitle,
    accent: RuqyahStyle.teal,
    leading: const DashboardFeatureMark(
      start: RuqyahStyle.deep,
      end: RuqyahStyle.teal,
      child: Icon(Icons.spa_rounded, color: Colors.white, size: 26),
    ),
    onTap: () => Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => const RuqyahView())),
  );
}
