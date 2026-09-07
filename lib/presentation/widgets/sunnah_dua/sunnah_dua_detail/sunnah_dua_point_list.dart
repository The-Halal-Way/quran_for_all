import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class SunnahDuaPointList extends StatelessWidget {
  const SunnahDuaPointList({super.key, required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (var index = 0; index < points.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == points.length - 1 ? 0 : 9,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: text.labelSmall.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: AppTheme.weightBlack,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    points[index],
                    style: text.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.78),
                      height: 1.45,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
