import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../domain/usecases/sunnah_dua/search_sunnah_content.dart';
import '../../../widgets/common/app_destination_header.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/common/app_premium_section_title.dart';
import '../../../widgets/sunnah_dua/duah/common/duah_language_menu.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_count_badge.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_data.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_detail_sheet.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_filter_bar.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_grid.dart';
import '../../../widgets/sunnah_dua/duah/powerful_duah/powerful_duah_note.dart';
import '../../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_empty_state.dart';
import '../../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_section_search.dart';

class PowerfulDuahView extends StatefulWidget {
  const PowerfulDuahView({super.key});

  @override
  State<PowerfulDuahView> createState() => _PowerfulDuahViewState();
}

class _PowerfulDuahViewState extends State<PowerfulDuahView>
    with SingleTickerProviderStateMixin {
  DuahSituation _selected = DuahSituation.all;
  bool _featuredOnly = false;
  String _query = '';
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

  List<PowerfulDuah> get _filtered {
    Iterable<PowerfulDuah> filtered = PowerfulDuahData.filtered(_selected);
    if (_featuredOnly) {
      filtered = filtered.where((item) => item.isFeatured);
    }
    if (_query.trim().isNotEmpty) {
      filtered = filtered.where(
        (item) => SearchSunnahContent.matches(_searchableText(item), _query),
      );
    }
    return filtered.toList(growable: false);
  }

  String _searchableText(PowerfulDuah item) => [
    item.title,
    item.titleBn,
    item.arabic,
    item.pronunciation,
    item.pronunciationBn,
    item.translation,
    item.translationBn,
    item.source,
  ].whereType<String>().join(' ');

  Future<void> _switchSituation(DuahSituation situation) async {
    if (_selected == situation) return;
    await _fadeController.reverse();
    if (!mounted) return;
    setState(() => _selected = situation);
    _fadeController.forward();
  }

  void _toggleFeatured() {
    setState(() => _featuredOnly = !_featuredOnly);
  }

  void _search(String query) {
    if (_query == query) return;
    setState(() => _query = query);
  }

  void _showDuah(PowerfulDuah duah) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: MyColors.primaryDark.withValues(alpha: 0.58),
      builder: (_) => PowerfulDuahDetailSheet(duah: duah),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final items = _filtered;

    return Scaffold(
      body: SafeArea(
        child: AppPremiumPageBackground(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.md,
                responsive.padding,
                AppSpacing.huge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxReadingContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDestinationHeader(
                        eyebrow: context.l10n.dashboardSectionDua,
                        title: context.l10n.duahPowerfulTitle,
                        artworkLabel: 'رَبَّنَا',
                        icon: Icons.bolt_rounded,
                        accent: MyColors.secondary,
                        onBack: () => Navigator.maybePop(context),
                        trailing: const DuahLanguageMenu(
                          accent: MyColors.secondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const PowerfulDuahNote(),
                      const SizedBox(height: AppSpacing.lg),
                      SunnahDuaSectionSearch(
                        key: const ValueKey('powerful-duah-search'),
                        hint: context.l10n.duahPowerfulSearchHint,
                        query: _query,
                        onChanged: _search,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PowerfulDuahFilterBar(
                        selected: _selected,
                        featuredOnly: _featuredOnly,
                        onSituationChanged: _switchSituation,
                        onFeaturedToggled: _toggleFeatured,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      AppPremiumSectionTitle(
                        title: _selected.label(context),
                        trailing: PowerfulDuahCountBadge(count: items.length),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (items.isEmpty)
                        SunnahDuaEmptyState(onClear: () => _search(''))
                      else
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: PowerfulDuahGrid(
                            items: items,
                            onItemTap: _showDuah,
                          ),
                        ),
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
