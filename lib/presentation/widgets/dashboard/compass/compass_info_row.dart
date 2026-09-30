import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_info_tile.dart';

class CompassInfoRow extends StatelessWidget {
  const CompassInfoRow({
    super.key,
    required this.heading,
    required this.qiblaDegrees,
    required this.isLive,
    required this.isApiBearing,
  });

  final double heading;
  final double qiblaDegrees;
  final bool isLive;
  final bool isApiBearing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: CompassInfoTile(
            icon: Icons.place_rounded,
            label: l10n.compassQiblaBearingLabel,
            value: '${qiblaDegrees.toStringAsFixed(0)}°',
            detail: isApiBearing
                ? l10n.compassApiBearingSource
                : l10n.compassCalculatedBearingSource,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CompassInfoTile(
            icon: isLive ? Icons.explore_rounded : Icons.explore_off_rounded,
            label: l10n.compassHeadingLabel,
            value: isLive
                ? '${heading.toStringAsFixed(0)}°'
                : l10n.compassNotAvailableShort,
            detail: isLive ? l10n.compassLiveMode : l10n.compassNorthUpMode,
          ),
        ),
      ],
    );
  }
}
