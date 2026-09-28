import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedSteps extends StatelessWidget {
  const NeedSteps({super.key, required this.amal, required this.isBangla});

  final NeedAmal amal;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isBangla ? 'যেভাবে করবেন' : 'How to perform',
          style: AppTheme.text(
            context,
          ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < amal.steps.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.tertiary.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTheme.text(context).labelMedium.copyWith(
                      color: scheme.tertiary,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    amal.steps[index].of(isBangla),
                    style: AppTheme.text(
                      context,
                    ).bodyMedium.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
