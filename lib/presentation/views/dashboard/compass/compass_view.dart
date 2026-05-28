import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
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
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (vm.isInitializing) {
      return _CompassStateScaffold(
        isDark: isDark,
        directionLabel: l10n.compassInitializing,
        child: CompassLoadingState(
          isDark: isDark,
          title: l10n.compassInitializing,
          isLoading: true,
        ),
      );
    }

    if (vm.initErrorType != CompassInitErrorType.none ||
        vm.initError.isNotEmpty) {
      return _CompassStateScaffold(
        isDark: isDark,
        directionLabel: _errorTitle(context, vm.initErrorType),
        child: CompassLoadingState(
          isDark: isDark,
          title: _errorTitle(context, vm.initErrorType),
          message: _errorBody(context, vm.initErrorType),
          icon: Icons.explore_off_rounded,
          actionLabel: l10n.compassRetry,
          onRetry: () => context.read<CompassViewModel>().retry(),
        ),
      );
    }

    if (vm.isApiFallback) {
      return _CompassStateScaffold(
        isDark: isDark,
        directionLabel: l10n.compassApiFallbackTitle,
        child: CompassLoadingState(
          isDark: isDark,
          title: l10n.compassApiFallbackTitle,
          message:
              '${l10n.compassApiFallbackBody}\n\n${l10n.compassApiFallbackQibla(vm.qiblaDegrees.toStringAsFixed(0))}',
          icon: Icons.explore_off_rounded,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CompassTopBar(
              isDark: isDark,
              directionLabel: l10n.compassNativeActive,
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

  String _errorTitle(BuildContext context, CompassInitErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      CompassInitErrorType.locationDenied => l10n.compassLocationDeniedTitle,
      CompassInitErrorType.locationBlocked => l10n.compassLocationBlockedTitle,
      CompassInitErrorType.locationDisabled =>
        l10n.compassLocationDisabledTitle,
      CompassInitErrorType.generic => l10n.compassGenericErrorTitle,
      CompassInitErrorType.none => l10n.compassGenericErrorTitle,
    };
  }

  String _errorBody(BuildContext context, CompassInitErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      CompassInitErrorType.locationDenied => l10n.compassLocationDeniedBody,
      CompassInitErrorType.locationBlocked => l10n.compassLocationBlockedBody,
      CompassInitErrorType.locationDisabled => l10n.compassLocationDisabledBody,
      CompassInitErrorType.generic => l10n.compassGenericErrorBody,
      CompassInitErrorType.none => l10n.compassGenericErrorBody,
    };
  }
}

class _CompassStateScaffold extends StatelessWidget {
  const _CompassStateScaffold({
    required this.isDark,
    required this.directionLabel,
    required this.child,
  });

  final bool isDark;
  final String directionLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CompassTopBar(isDark: isDark, directionLabel: directionLabel),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
