import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassModeBadge extends StatelessWidget {
  const CompassModeBadge({super.key, required this.isLive});

  final bool isLive;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.full),
      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isLive ? Icons.sensors_rounded : Icons.map_outlined,
          size: 13,
          color: const Color(0xFF65E4E5),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            isLive
                ? context.l10n.compassLiveMode
                : context.l10n.compassNorthUpMode,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(context).labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
