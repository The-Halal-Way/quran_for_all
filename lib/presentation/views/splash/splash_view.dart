import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B6B5A), Color(0xFFBC5B40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: 30,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: AppPageScrollbar(
                builder: (context, controller) => SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
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
