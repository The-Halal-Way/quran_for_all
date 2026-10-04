import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_detail_background.dart';

/// Shared page shell for the prayer guide screens.
class PrayerDetailScaffold extends StatelessWidget {
  const PrayerDetailScaffold({
    super.key,
    required this.title,
    required this.accent,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final Color accent;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: actions,
      ),
      body: PrayerDetailBackground(
        accent: accent,
        child: AppPageScrollbar(
          builder: (context, controller) => SingleChildScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
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
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
