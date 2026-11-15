import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../presentation/widgets/prayer/prayer_rules/prayer_rules_content.dart';
import '../../../../presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';

enum PrayerRuleTopic { beforePrayer, wuduBreaks, prayerBreaks }

class PrayerRulesView extends StatefulWidget {
  const PrayerRulesView({super.key, this.initialTopic});

  final PrayerRuleTopic? initialTopic;

  @override
  State<PrayerRulesView> createState() => _PrayerRulesViewState();
}

class _PrayerRulesViewState extends State<PrayerRulesView> {
  final _beforePrayerKey = GlobalKey();
  final _wuduBreaksKey = GlobalKey();
  final _prayerBreaksKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialTopic != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = switch (widget.initialTopic!) {
          PrayerRuleTopic.beforePrayer => _beforePrayerKey,
          PrayerRuleTopic.wuduBreaks => _wuduBreaksKey,
          PrayerRuleTopic.prayerBreaks => _prayerBreaksKey,
        };
        final targetContext = target.currentContext;
        if (targetContext != null) {
          Scrollable.ensureVisible(
            targetContext,
            alignment: 0.06,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => PrayerDetailScaffold(
    title: context.l10n.prayerRulesTitle,
    accent: MyColors.primaryLight,
    child: PrayerRulesContent(
      beforePrayerKey: _beforePrayerKey,
      wuduBreaksKey: _wuduBreaksKey,
      prayerBreaksKey: _prayerBreaksKey,
    ),
  );
}
