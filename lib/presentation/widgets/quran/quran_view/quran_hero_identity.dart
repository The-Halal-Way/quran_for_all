import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class QuranHeroIdentity extends StatelessWidget {
  const QuranHeroIdentity({
    super.key,
    required this.title,
    required this.eyebrow,
  });

  final String title;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 3,
              decoration: BoxDecoration(
                color: MyColors.tertiaryLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                eyebrow.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontWeight: AppTheme.weightBold,
                  letterSpacing: 1.1,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.displaySmall.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.weightBlack,
            height: 1,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: 42,
          height: 1,
          color: MyColors.secondaryLight.withValues(alpha: 0.76),
        ),
      ],
    );
  }
}
