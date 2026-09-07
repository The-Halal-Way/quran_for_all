import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../widgets/common/app_destination_header.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/sunnah_dua/duah/common/duah_language_menu.dart';
import '../../../widgets/sunnah_dua/duah/daily_duah/daily_duah_category_section.dart';
import '../../../widgets/sunnah_dua/duah/daily_duah/daily_duah_data.dart';
import '../../../widgets/sunnah_dua/duah/daily_duah/daily_duah_detail_sheet.dart';
import '../../../widgets/sunnah_dua/duah/daily_duah/daily_duah_level_banner.dart';
import '../../../widgets/sunnah_dua/duah/daily_duah/daily_duah_level_selector.dart';

class DailyDuahView extends StatefulWidget {
  const DailyDuahView({super.key});

  @override
  State<DailyDuahView> createState() => _DailyDuahViewState();
}

class _DailyDuahViewState extends State<DailyDuahView>
    with SingleTickerProviderStateMixin {
  DuahLevel _selectedLevel = DuahLevel.beginner;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _switchLevel(DuahLevel level) async {
    if (_selectedLevel == level) return;
    await _fadeController.reverse();
    if (!mounted) return;
    setState(() => _selectedLevel = level);
    _fadeController.forward();
  }

  void _showDuah(DuahItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
      builder: (_) => DailyDuahDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = DuahData.forLevel(_selectedLevel);
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: AppPremiumPageBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = responsive.maxReadingContentWidth;
              final horizontal = constraints.maxWidth > maxWidth
                  ? (constraints.maxWidth - maxWidth) / 2
                  : responsive.padding;

              return AppPageScrollbar(
                builder: (context, controller) => CustomScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        AppSpacing.md,
                        horizontal,
                        AppSpacing.huge,
                      ),
                      sliver: SliverList.list(
                        children: [
                          AppDestinationHeader(
                            eyebrow: context.l10n.dashboardSectionDua,
                            title: context.l10n.duahDailyTitle,
                            subtitle: context.l10n.duahDailySubtitle,
                            artworkLabel: 'دعاء',
                            icon: Icons.wb_twilight_rounded,
                            accent: MyColors.tertiary,
                            onBack: () => Navigator.maybePop(context),
                            trailing: const DuahLanguageMenu(
                              accent: MyColors.tertiary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          DailyDuahLevelSelector(
                            selectedLevel: _selectedLevel,
                            onLevelChanged: _switchLevel,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          LevelBanner(level: _selectedLevel, isDark: isDark),
                          const SizedBox(height: AppSpacing.md),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                for (
                                  var index = 0;
                                  index < categories.length;
                                  index++
                                )
                                  CategorySection(
                                    category: categories[index],
                                    isDark: isDark,
                                    isLast: index == categories.length - 1,
                                    onItemTap: _showDuah,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
