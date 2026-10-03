import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/splash_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/splash/splash_backdrop.dart';
import '../../widgets/splash/splash_branding.dart';
import '../../widgets/splash/splash_status_panel.dart';
import '../home/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, this.destination = const HomeView()});

  final Widget destination;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_initialize());
      }
    });
  }

  Future<void> _initialize() async {
    final viewModel = context.read<SplashViewModel>();
    await viewModel.initialize();

    if (!mounted) {
      return;
    }

    await Navigator.of(
      context,
    ).pushReplacement(AppPageRoute<void>(builder: (_) => widget.destination));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SplashViewModel>();
    final responsive = AppResponsive.of(context);
    final verticalPadding = responsive.pick(
      mobile: AppSpacing.xl,
      tablet: AppSpacing.xxl,
      desktop: AppSpacing.xxxl,
    );

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: SplashBackdrop()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => AppPageScrollbar(
                builder: (context, controller) => SingleChildScrollView(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.padding + 4,
                    vertical: verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - verticalPadding * 2,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 540),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SplashBranding(),
                            const SizedBox(height: AppSpacing.xxl),
                            SplashStatusPanel(
                              isLoading:
                                  viewModel.isLoading ||
                                  (!viewModel.hasQuranData &&
                                      viewModel.isDownloading),
                              status: viewModel.status,
                              hasQuranData: viewModel.hasQuranData,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
