import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard/need_amal_progress_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_explore.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_hero.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_progress_summary.dart';
import 'need_amal.dart';
import 'need_amals.dart';

class WhenYouHaveANeedView extends StatefulWidget {
  const WhenYouHaveANeedView({super.key, this.initialCategory});

  final NeedCategory? initialCategory;

  @override
  State<WhenYouHaveANeedView> createState() => _WhenYouHaveANeedViewState();
}

class _WhenYouHaveANeedViewState extends State<WhenYouHaveANeedView> {
  late final NeedAmalProgressViewModel _progress;

  @override
  void initState() {
    super.initState();
    _progress = NeedAmalProgressViewModel()..load();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: _progress,
    child: Builder(builder: _buildPage),
  );

  Widget _buildPage(BuildContext context) {
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    final responsive = AppResponsive.of(context);
    final scheme = Theme.of(context).colorScheme;

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
                      NeedHero(isBangla: bn),
                      const SizedBox(height: AppSpacing.xxl),
                      NeedProgressSummary(
                        isBangla: bn,
                        total: needAmals.length,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      NeedExplore(
                        isBangla: bn,
                        progress: _progress,
                        initialCategory: widget.initialCategory,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        bn
                            ? 'এই আমলগুলো আল্লাহর কাছে চাওয়ার উপায়। নির্দিষ্ট দুনিয়াবি ফলের নিশ্চয়তা নয়। মতভেদপূর্ণ বর্ণনা স্পষ্টভাবে চিহ্নিত।'
                            : 'These are ways to ask Allah, not guarantees of a specific worldly result. Disputed reports are labeled clearly.',
                        textAlign: TextAlign.center,
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
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
