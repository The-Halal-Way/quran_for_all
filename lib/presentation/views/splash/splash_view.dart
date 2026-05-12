import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_gradients.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../viewmodels/splash_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/splash/splash_branding.dart';
import '../../widgets/splash/splash_status_panel.dart';
import '../home/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

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
    final success = await viewModel.initialize();

    if (!mounted || !success) {
      return;
    }

    unawaited(context.read<ReadQuranViewModel>().load());

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SplashViewModel>();
    final responsive = AppResponsive.of(context);
    final decorCircleLarge = responsive.moderate(220, tabletFactor: 1.05, desktopFactor: 1.1);
    final decorCircleSmall = responsive.moderate(190, tabletFactor: 1.04, desktopFactor: 1.08);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.splash),
            ),
          ),
          Positioned(
            top: -80,
            left: -70,
            child: Container(
              width: decorCircleLarge,
              height: decorCircleLarge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: 30,
            child: Container(
              width: decorCircleSmall,
              height: decorCircleSmall,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: AppPageScrollbar(
                builder: (context, controller) => SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.all(responsive.padding + 4),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxContentWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SplashBranding(),
                        const SizedBox(height: 26),
                        SplashStatusPanel(
                          isLoading: viewModel.isLoading,
                          status: viewModel.status,
                          errorMessage: viewModel.errorMessage,
                          onRetry: _initialize,
                        ),
                      ],
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
