import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/compass/compass_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_dial.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_heading.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_info_row.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_loading_state.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_top_bar.dart';

class CompassView extends StatefulWidget {
  const CompassView({super.key});

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompassViewModel()..initialize(),
      child: const _CompassTickerHost(),
    );
  }
}

class _CompassTickerHost extends StatefulWidget {
  const _CompassTickerHost();

  @override
  State<_CompassTickerHost> createState() => _CompassTickerHostState();
}

class _CompassTickerHostState extends State<_CompassTickerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _ticker =
        AnimationController(vsync: this, duration: const Duration(days: 999))
          ..addListener(_onTick)
          ..forward();
  }

  void _onTick() {
    if (!mounted) {
      return;
    }

    context.read<CompassViewModel>().updateSmoothHeading();
  }

  @override
  void dispose() {
    _ticker.removeListener(_onTick);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _CompassViewBody();
  }
}

class _CompassViewBody extends StatelessWidget {
  const _CompassViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CompassViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (vm.showLoadingState) {
      return Scaffold(
        body: CompassLoadingState(
          isDark: isDark,
          error: vm.initError,
          onRetry: () => context.read<CompassViewModel>().retry(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CompassTopBar(
              isDark: isDark,
              directionLabel: vm.isApiFallback
                  ? 'API Qibla mode (no native compass)'
                  : 'Native compass active',
            ),
            const SizedBox(height: 8),
            CompassHeadingDisplay(
              heading: vm.smoothHeading,
              isDark: isDark,
              facingMecca: vm.facingMecca,
            ),
            const SizedBox(height: 4),
            CompassDirectionPill(label: vm.directionLabel, isDark: isDark),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: CompassDial(
                  heading: vm.smoothHeading,
                  qiblaDegrees: vm.qiblaDegrees,
                  facingMecca: vm.facingMecca,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CompassInfoRow(
              heading: vm.smoothHeading,
              qiblaOffset: vm.qiblaOffset,
              facingMecca: vm.facingMecca,
              isDark: isDark,
              isApiFallback: vm.isApiFallback,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
