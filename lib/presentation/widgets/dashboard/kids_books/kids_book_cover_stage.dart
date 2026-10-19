import 'package:flutter/material.dart';

import '../books/dashboard_book_cover.dart';

/// A small storybook alcove, drawn without additional assets or animation.
class KidsBookCoverStage extends StatelessWidget {
  const KidsBookCoverStage({
    super.key,
    required this.image,
    required this.accent,
  });

  final String image;
  final Color accent;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 86,
    height: 108,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: 8,
          bottom: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: .2),
                  accent.withValues(alpha: .05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(44),
                bottom: Radius.circular(14),
              ),
            ),
          ),
        ),
        Center(
          child: Transform.rotate(
            angle: -.065,
            child: DashboardBookCover(
              imagePath: image,
              accent: accent,
              width: 64,
              height: 94,
            ),
          ),
        ),
        PositionedDirectional(
          top: 1,
          end: 0,
          child: Icon(Icons.auto_awesome_rounded, color: accent, size: 15),
        ),
        PositionedDirectional(
          start: 0,
          bottom: 7,
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  );
}
