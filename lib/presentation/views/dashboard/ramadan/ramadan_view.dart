import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/ramadan/ramadan_guide.dart';
import '../../../widgets/dashboard/ramadan/ramadan_hero.dart';
import '../../../widgets/dashboard/ramadan/ramadan_make_up_log.dart';
import '../../../widgets/dashboard/ramadan/ramadan_quick_links.dart';
import '../../../widgets/dashboard/ramadan/ramadan_section_heading.dart';
import '../../../widgets/dashboard/ramadan/ramadan_source_note.dart';
import '../../../widgets/dashboard/ramadan/ramadan_time_card.dart';
import 'ramadan_models.dart';

class RamadanView extends StatelessWidget {
  const RamadanView({super.key});

  @override
  Widget build(BuildContext context) {
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final responsive = AppResponsive.of(context);
    final prayerTimes = context
        .watch<DashboardPrayerTimesViewModel?>()
        ?.prayerTimes;

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.lg,
                responsive.padding,
                AppSpacing.huge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RamadanHero(isBangla: isBangla),
                      const SizedBox(height: AppSpacing.xxl),
                      RamadanTimeCard(isBangla: isBangla, times: prayerTimes),
                      const SizedBox(height: AppSpacing.xxl),
                      RamadanMakeUpLog(isBangla: isBangla),
                      const SizedBox(height: AppSpacing.xxl),
                      RamadanSectionHeading(
                        icon: Icons.auto_awesome_rounded,
                        title: ramadanLabel(
                          isBangla,
                          'Continue your journey',
                          'আপনার পথচলা চালিয়ে যান',
                        ),
                        subtitle: ramadanLabel(
                          isBangla,
                          'Open the tools you already use, now in one Ramadan place.',
                          'রমজানের জন্য দরকারি অ্যাপের অন্য অংশগুলো এখান থেকে খুলুন।',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RamadanQuickLinks(isBangla: isBangla),
                      const SizedBox(height: AppSpacing.xxxl),
                      RamadanGuide(isBangla: isBangla),
                      const SizedBox(height: AppSpacing.xxl),
                      RamadanSourceNote(isBangla: isBangla),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
