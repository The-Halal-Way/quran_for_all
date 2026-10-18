import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A cover thumbnail with a consistent paper edge and a graceful fallback.
class DashboardBookCover extends StatelessWidget {
  const DashboardBookCover({
    super.key,
    this.imagePath,
    required this.accent,
    this.width = 52,
    this.height = 74,
    this.fallbackLabel,
  });

  final String? imagePath;
  final Color accent;
  final double width;
  final double height;
  final String? fallbackLabel;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 8,
          offset: const Offset(3, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath case final image?)
            Image.asset(
              image,
              fit: BoxFit.contain,
              // Covers are displayed as thumbnails, including in the picker.
              cacheWidth: (width * MediaQuery.devicePixelRatioOf(context))
                  .ceil(),
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => _fallback(context),
            )
          else
            _fallback(context),
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _fallback(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [accent, Color.lerp(accent, const Color(0xFF272044), 0.6)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: width * .36,
          ),
          if (fallbackLabel case final label?) ...[
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: AppTheme.text(context).labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
