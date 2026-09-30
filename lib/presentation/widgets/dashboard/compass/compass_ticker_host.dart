import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/compass/compass_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_content.dart';

/// Smooths sensor updates only while a live heading is being received.
class CompassTickerHost extends StatefulWidget {
  const CompassTickerHost({super.key});

  @override
  State<CompassTickerHost> createState() => _CompassTickerHostState();
}

class _CompassTickerHostState extends State<CompassTickerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  CompassViewModel? _model;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(days: 999),
    )..addListener(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = context.read<CompassViewModel>();
    if (identical(model, _model)) return;
    _model?.removeListener(_syncTicker);
    _model = model;
    model.addListener(_syncTicker);
    _syncTicker();
  }

  void _syncTicker() {
    final active = _model?.isListening ?? false;
    if (active && !_ticker.isAnimating) _ticker.forward();
    if (!active && _ticker.isAnimating) _ticker.stop();
  }

  void _onTick() => _model?.updateSmoothHeading();

  @override
  void dispose() {
    _model?.removeListener(_syncTicker);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const CompassContent();
}
