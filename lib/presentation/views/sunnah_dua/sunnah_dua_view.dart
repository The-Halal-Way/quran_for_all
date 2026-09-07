import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/repositories/sunnah_dua_repository_impl.dart';
import '../../models/sunnah_dua_content_presenter.dart';
import '../../models/sunnah_dua_shortcut.dart';
import '../../models/sunnah_dua_shortcuts_presenter.dart';
import '../../viewmodels/sunnah_dua_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/sunnah_dua/sunnah_dua_detail/sunnah_dua_detail_launcher.dart';
import '../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_collections_section.dart';
import '../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_hero.dart';
import '../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_routine_section.dart';
import 'duah/daily_duah_view.dart';
import 'duah/duah_ninty_nine_view.dart';
import 'duah/powerful_duah_view.dart';

class SunnahDuaView extends StatefulWidget {
  const SunnahDuaView({super.key, this.showBackButton = false});
  final bool showBackButton;

  @override
  State<SunnahDuaView> createState() => _SunnahDuaViewState();
}

class _SunnahDuaViewState extends State<SunnahDuaView> {
  SunnahDuaViewModel? _viewModel;
  String? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locale == context.l10n.localeName) return;
    _locale = context.l10n.localeName;
    final repository = SunnahDuaRepositoryImpl(context.l10n);
    if (_viewModel == null) {
      _viewModel = SunnahDuaViewModel(repository);
    } else {
      _viewModel!.updateRepository(repository);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final model = _viewModel!;
    return Scaffold(
      body: SafeArea(
        child: AppPremiumPageBackground(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
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
                      SunnahDuaHero(
                        onBack: widget.showBackButton
                            ? () => Navigator.maybePop(context)
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ListenableBuilder(
                        listenable: model,
                        builder: (context, _) => SunnahDuaCollectionsSection(
                          items: presentSunnahShortcuts(
                            context.l10n,
                            model.collections,
                            model.collectionQuery,
                          ),
                          query: model.collectionQuery,
                          onSearch: model.searchCollections,
                          onSelected: _openShortcut,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ListenableBuilder(
                        listenable: model,
                        builder: (context, _) => SunnahDuaRoutineSection(
                          items: model.practices
                              .map(presentSunnahContent)
                              .toList(),
                          query: model.routineQuery,
                          onSearch: model.searchRoutine,
                          onItemTap: (item) =>
                              showSunnahDuaDetails(context, item),
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

  void _openShortcut(SunnahDuaShortcut shortcut) {
    if (shortcut.destination == SunnahDuaDestination.detail) {
      showSunnahDuaDetails(context, shortcut.detail!);
      return;
    }
    FocusScope.of(context).unfocus();
    final page = switch (shortcut.destination) {
      SunnahDuaDestination.dailyDua => const DailyDuahView(),
      SunnahDuaDestination.powerfulDua => const PowerfulDuahView(),
      SunnahDuaDestination.names => const DuahNintyNineView(),
      SunnahDuaDestination.detail => throw StateError('Detail handled above'),
    };
    Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));
  }
}
