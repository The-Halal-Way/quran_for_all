import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_nafal_prayers_card.dart';

class NafalPrayersView extends StatelessWidget {
  const NafalPrayersView({super.key, required this.items});

  final List<PrayerNafalPrayerItem> items;

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.prayerNafalTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppGradients.darkPageBg
                    : AppGradients.pageBg,
              ),
            ),
          ),
          AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.sm + 2,
                responsive.padding,
                AppSpacing.huge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxReadingContentWidth,
                  ),
                  child: PrayerNafalPrayersCard(items: items),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
