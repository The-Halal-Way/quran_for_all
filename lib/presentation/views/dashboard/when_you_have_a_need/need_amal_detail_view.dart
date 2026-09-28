import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_completion_button.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_dua_panel.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_evidence_panel.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_progress_control.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_references_list.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_steps.dart';
import '../../../widgets/dashboard/when_you_have_a_need/need_tracker_action.dart';
import 'need_amal.dart';

enum NeedDetailFocus { method, dua }

class NeedAmalDetailView extends StatefulWidget {
  const NeedAmalDetailView({
    super.key,
    required this.amal,
    this.initialFocus = NeedDetailFocus.method,
  });

  final NeedAmal amal;
  final NeedDetailFocus initialFocus;

  @override
  State<NeedAmalDetailView> createState() => _NeedAmalDetailViewState();
}

class _NeedAmalDetailViewState extends State<NeedAmalDetailView> {
  final _methodKey = GlobalKey();
  final _duaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = widget.initialFocus == NeedDetailFocus.dua
          ? _duaKey.currentContext
          : _methodKey.currentContext;
      if (mounted && target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    final scheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final amal = widget.amal;

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.lg,
                responsive.padding,
                AppSpacing.huge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          icon: const Icon(CupertinoIcons.chevron_back),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Icon(
                        amal.category.icon,
                        color: scheme.tertiary,
                        size: 35,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        amal.category.title.of(bn),
                        style: AppTheme.text(context).labelMedium.copyWith(
                          color: scheme.tertiary,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        amal.title.of(bn),
                        style: AppTheme.text(context).headlineMedium.copyWith(
                          fontWeight: AppTheme.weightBlack,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        amal.description.of(bn),
                        style: AppTheme.text(context).bodyLarge.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      NeedEvidencePanel(amal: amal, isBangla: bn),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        bn ? 'উপযুক্ত সময়' : 'Recommended timing',
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: scheme.secondary,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        amal.timing.of(bn),
                        style: AppTheme.text(context).bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      NeedSteps(key: _methodKey, amal: amal, isBangla: bn),
                      const SizedBox(height: AppSpacing.xxl),
                      NeedDuaPanel(key: _duaKey, amal: amal, isBangla: bn),
                      const SizedBox(height: AppSpacing.xxl),
                      NeedReferencesList(amal: amal, isBangla: bn),
                      const SizedBox(height: AppSpacing.xxl),
                      if (amal.progressKind != NeedProgressKind.daily) ...[
                        NeedProgressControl(
                          kind: amal.progressKind,
                          isBangla: bn,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          NeedCompletionButton(amalId: amal.id, isBangla: bn),
                          NeedTrackerAction(amal: amal, isBangla: bn),
                        ],
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
