import 'package:flutter/material.dart';

import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_content.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_refresh_indicator.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppPremiumPageBackground(
      child: SafeArea(
        child: DashboardRefreshIndicator(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: const DashboardContent(),
            ),
          ),
        ),
      ),
    ),
  );
}
