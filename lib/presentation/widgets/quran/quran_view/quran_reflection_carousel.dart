import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/quran/quran_hub_models.dart';
import 'quran_reflection_card.dart';

class QuranReflectionCarousel extends StatelessWidget {
  const QuranReflectionCarousel({super.key, required this.hadiths});

  final List<QuranHubHadith> hadiths;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = MediaQuery.sizeOf(context).width;
        final availableWidth = constraints.maxWidth;
        final cardWidth = availableWidth >= 760
            ? (availableWidth - AppSpacing.md) / 2
            : availableWidth * (viewportWidth < 360 ? 0.96 : 0.9);

        return SizedBox(
          height: 188,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hadiths.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: QuranReflectionCard(hadith: hadiths[index]),
            ),
          ),
        );
      },
    );
  }
}
