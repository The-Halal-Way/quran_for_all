import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/zakat/zakat_calculator.dart';
import '../../../../core/zakat/zakat_currency.dart';
import 'zakat_amount_field.dart';
import 'zakat_section.dart';

class ZakatNisabSection extends StatelessWidget {
  const ZakatNisabSection({
    super.key,
    required this.basis,
    required this.currency,
    required this.priceController,
    required this.threshold,
    required this.onBasisChanged,
    required this.onChanged,
  });

  final ZakatNisabBasis basis;
  final ZakatCurrency currency;
  final TextEditingController priceController;
  final int? threshold;
  final ValueChanged<ZakatNisabBasis> onBasisChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ZakatSection(
      title: l10n.zakatNisabTitle,
      subtitle: l10n.zakatNisabHint,
      icon: Icons.balance_rounded,
      accent: scheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                avatar: const Icon(CupertinoIcons.circle_grid_3x3, size: 16),
                label: Text(l10n.zakatSilver),
                selected: basis == ZakatNisabBasis.silver,
                onSelected: (_) => onBasisChanged(ZakatNisabBasis.silver),
                selectedColor: scheme.secondary.withValues(alpha: 0.2),
                backgroundColor: scheme.surfaceContainerLow,
                side: BorderSide(
                  color: basis == ZakatNisabBasis.silver
                      ? scheme.secondary
                      : scheme.outlineVariant,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              ChoiceChip(
                avatar: const Icon(CupertinoIcons.star, size: 16),
                label: Text(l10n.zakatGold),
                selected: basis == ZakatNisabBasis.gold,
                onSelected: (_) => onBasisChanged(ZakatNisabBasis.gold),
                selectedColor: scheme.secondary.withValues(alpha: 0.2),
                backgroundColor: scheme.surfaceContainerLow,
                side: BorderSide(
                  color: basis == ZakatNisabBasis.gold
                      ? scheme.secondary
                      : scheme.outlineVariant,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ZakatAmountField(
            label: basis == ZakatNisabBasis.silver
                ? l10n.zakatSilverPrice
                : l10n.zakatGoldPrice,
            icon: CupertinoIcons.money_dollar_circle,
            symbol: currency.symbol,
            controller: priceController,
            onChanged: onChanged,
            hint: l10n.zakatPriceHint,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: scheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: scheme.secondary.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.secondary.withValues(alpha: 0.16),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: scheme.secondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.zakatNisabValue,
                        style: AppTheme.text(
                          context,
                        ).labelMedium.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        threshold == null
                            ? '—'
                            : currency.format(threshold!, l10n.localeName),
                        style: AppTheme.text(context).titleMedium.copyWith(
                          color: scheme.onSurface,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
