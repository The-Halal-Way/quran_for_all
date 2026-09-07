import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/quran/quran_hub_models.dart';
import 'quran_path_card.dart';

class QuranPathGrid extends StatelessWidget {
  const QuranPathGrid({
    super.key,
    required this.actions,
    required this.onSelected,
  });

  final List<QuranHubAction> actions;
  final ValueChanged<QuranHubDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSingleColumn = constraints.maxWidth < 300;
        final cardHeight = constraints.maxWidth < 430 ? 184.0 : 190.0;

        if (useSingleColumn) {
          return Column(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                SizedBox(height: cardHeight, child: _cardFor(actions[index])),
                if (index < actions.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return SizedBox(
          height: cardHeight,
          child: Row(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                Expanded(child: _cardFor(actions[index])),
                if (index < actions.length - 1)
                  const SizedBox(width: AppSpacing.md),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _cardFor(QuranHubAction action) {
    return QuranPathCard(
      action: action,
      onTap: () => onSelected(action.destination),
    );
  }
}
