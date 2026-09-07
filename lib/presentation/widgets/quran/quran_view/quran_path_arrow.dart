import 'package:flutter/material.dart';

import '../../../../core/theme/my_colors.dart';

class QuranPathArrow extends StatelessWidget {
  const QuranPathArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.north_east_rounded,
        color: MyColors.primary,
        size: 18,
      ),
    );
  }
}
