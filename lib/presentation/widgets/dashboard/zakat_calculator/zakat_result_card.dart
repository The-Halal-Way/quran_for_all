import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/zakat/zakat_calculator.dart';
import '../../../../core/zakat/zakat_currency.dart';
import 'zakat_ornament.dart';

class ZakatResultCard extends StatelessWidget {
  const ZakatResultCard({
    super.key,
    required this.calculation,
    required this.currency,
    required this.hasInvalidAmount,
  });

  final ZakatCalculation calculation;
  final ZakatCurrency currency;
  final bool hasInvalidAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDue = calculation.status == ZakatStatus.due && !hasInvalidAmount;
    final statusText = hasInvalidAmount
        ? l10n.zakatStatusInvalid
        : switch (calculation.status) {
            ZakatStatus.enterPrice => l10n.zakatStatusSetPrice,
            ZakatStatus.belowNisab => l10n.zakatStatusBelow,
            ZakatStatus.awaitingYear => l10n.zakatStatusAwaiting,
            ZakatStatus.due => l10n.zakatStatusDue,
          };
    String amount(int value) => currency.format(value, l10n.localeName);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryDark.withValues(alpha: 0.2),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDue
                  ? const [MyColors.primaryDark, MyColors.tertiaryDark]
                  : const [MyColors.primaryDark, MyColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: ZakatOrnament(opacity: 0.55)),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: MyColors.secondaryLight.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            Icons.volunteer_activism_outlined,
                            color: MyColors.secondaryLight,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.zakatResultTitle,
                            style: AppTheme.text(context).titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: AppTheme.text(context).labelMedium.copyWith(
                          color: isDue ? MyColors.secondaryLight : Colors.white,
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      l10n.zakatDue,
                      style: AppTheme.text(context).bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: SizedBox(
                        key: ValueKey((
                          calculation.zakatDue,
                          currency,
                          hasInvalidAmount,
                        )),
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            amount(hasInvalidAmount ? 0 : calculation.zakatDue),
                            style: AppTheme.text(context).displaySmall.copyWith(
                              color: isDue
                                  ? MyColors.secondaryLight
                                  : Colors.white,
                              fontWeight: AppTheme.weightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.13),
                        ),
                      ),
                      child: Column(
                        children: [
                          _ResultLine(
                            label: l10n.zakatTotalAssets,
                            value: amount(calculation.totalAssets),
                          ),
                          _ResultLine(
                            label: l10n.zakatTotalLiabilities,
                            value: amount(calculation.totalLiabilities),
                          ),
                          Divider(color: Colors.white.withValues(alpha: 0.19)),
                          _ResultLine(
                            label: l10n.zakatNetAssets,
                            value: amount(calculation.netAssets),
                            emphasize: true,
                          ),
                          _ResultLine(
                            label: l10n.zakatNisabValue,
                            value: calculation.nisab == null
                                ? '—'
                                : amount(calculation.nisab!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: AppSpacing.xs,
        children: [
          Text(
            label,
            style: AppTheme.text(context).bodySmall.copyWith(
              color: emphasize
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.71),
              fontWeight: emphasize
                  ? AppTheme.weightBold
                  : AppTheme.weightRegular,
            ),
          ),
          Text(
            value,
            style: AppTheme.text(context).bodyMedium.copyWith(
              color: emphasize ? MyColors.secondaryLight : Colors.white,
              fontWeight: emphasize
                  ? AppTheme.weightExtraBold
                  : AppTheme.weightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
