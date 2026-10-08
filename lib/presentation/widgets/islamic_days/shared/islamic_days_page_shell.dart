import 'package:flutter/material.dart';

import '../../../../core/utils/app_responsive.dart';
import '../../common/app_page_scrollbar.dart';
import '../../common/app_premium_page_background.dart';

class IslamicDaysPageShell extends StatelessWidget {
  const IslamicDaysPageShell({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      toolbarHeight:
          56 *
          (MediaQuery.textScalerOf(context).scale(16) / 16).clamp(1.0, 1.7),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    ),
    body: AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: AppPageScrollbar(
          builder: (context, controller) => SingleChildScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppResponsive.of(context).padding,
              12,
              AppResponsive.of(context).padding,
              40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
