import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class PrayerTimeCountdown extends StatefulWidget {
  const PrayerTimeCountdown({
    super.key,
    required this.endsAtUtc,
    required this.color,
    this.prominent = false,
  });

  final DateTime endsAtUtc;
  final Color color;
  final bool prominent;

  @override
  State<PrayerTimeCountdown> createState() => _PrayerTimeCountdownState();
}

class _PrayerTimeCountdownState extends State<PrayerTimeCountdown> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.endsAtUtc.difference(DateTime.now().toUtc());
    final seconds = remaining.isNegative ? 0 : remaining.inSeconds;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final leftoverSeconds = seconds % 60;
    final value =
        '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${leftoverSeconds.toString().padLeft(2, '0')}';

    if (widget.prominent) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.14),
          border: Border.all(color: widget.color.withValues(alpha: 0.55)),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 14,
                  color: widget.color,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    context.l10n.prayerTimeRemaining,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: widget.color,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                maxLines: 1,
                style: AppTheme.text(context).titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightExtraBold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Icon(Icons.hourglass_bottom_rounded, size: 14, color: widget.color),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            '${context.l10n.prayerTimeRemaining}: $value',
            style: AppTheme.text(context).labelSmall.copyWith(
              color: widget.color,
              fontWeight: AppTheme.weightSemiBold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
