import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/zakat/zakat_calculator.dart';
import '../../../../core/zakat/zakat_currency.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_amount_field.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_guide_card.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_hero.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_nisab_section.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_result_card.dart';
import '../../../widgets/dashboard/zakat_calculator/zakat_section.dart';

class ZakatCalculatorView extends StatefulWidget {
  const ZakatCalculatorView({super.key});

  @override
  State<ZakatCalculatorView> createState() => _ZakatCalculatorViewState();
}

class _ZakatCalculatorViewState extends State<ZakatCalculatorView> {
  final _assetControllers = List.generate(8, (_) => TextEditingController());
  final _liabilityControllers = List.generate(
    2,
    (_) => TextEditingController(),
  );
  final _silverPrice = TextEditingController();
  final _goldPrice = TextEditingController();
  ZakatNisabBasis _basis = ZakatNisabBasis.silver;
  ZakatCurrency _currency = ZakatCurrency.bdt;
  int _currencyMenuRevision = 0;
  bool _lunarYearComplete = false;

  TextEditingController get _selectedPrice =>
      _basis == ZakatNisabBasis.silver ? _silverPrice : _goldPrice;

  @override
  void dispose() {
    for (final controller in [
      ..._assetControllers,
      ..._liabilityControllers,
      _silverPrice,
      _goldPrice,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _recalculate() => setState(() {});

  void _reset() {
    _clearAmounts();
    setState(() {
      _basis = ZakatNisabBasis.silver;
      _currency = ZakatCurrency.bdt;
      _currencyMenuRevision++;
      _lunarYearComplete = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearAmounts() {
    for (final controller in [
      ..._assetControllers,
      ..._liabilityControllers,
      _silverPrice,
      _goldPrice,
    ]) {
      controller.clear();
    }
  }

  Future<void> _changeCurrency(ZakatCurrency currency) async {
    if (currency == _currency) return;
    final hasValues = [
      ..._assetControllers,
      ..._liabilityControllers,
      _silverPrice,
      _goldPrice,
    ].any((controller) => controller.text.trim().isNotEmpty);
    if (hasValues) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.zakatCurrencyChangeTitle),
          content: Text(dialogContext.l10n.zakatCurrencyChangeBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(dialogContext.l10n.zakatCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(dialogContext.l10n.zakatSwitchCurrency),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (confirmed != true) {
        setState(() => _currencyMenuRevision++);
        return;
      }
      _clearAmounts();
    }
    setState(() {
      _currency = currency;
      _currencyMenuRevision++;
      _lunarYearComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final scheme = Theme.of(context).colorScheme;
    final calculation = ZakatCalculation(
      assets: _assetControllers
          .map((controller) => ZakatCalculation.parseAmount(controller.text))
          .toList(),
      liabilities: _liabilityControllers
          .map((controller) => ZakatCalculation.parseAmount(controller.text))
          .toList(),
      pricePerGram: ZakatCalculation.parseAmount(_selectedPrice.text),
      basis: _basis,
      lunarYearComplete: _lunarYearComplete,
    );
    final hasInvalidAmount =
        [..._assetControllers, ..._liabilityControllers, _selectedPrice].any(
          (controller) =>
              ZakatCalculation.tryParseAmount(controller.text) == null,
        );

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.lg,
                responsive.padding,
                AppSpacing.huge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ZakatHero(),
                      const SizedBox(height: AppSpacing.xxl),
                      _currencyPicker(context),
                      const SizedBox(height: AppSpacing.xxl),
                      ZakatNisabSection(
                        basis: _basis,
                        currency: _currency,
                        priceController: _selectedPrice,
                        threshold: calculation.nisab,
                        onBasisChanged: (basis) =>
                            setState(() => _basis = basis),
                        onChanged: _recalculate,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ZakatSection(
                        title: l10n.zakatAssetsTitle,
                        subtitle: l10n.zakatAssetsHint,
                        icon: CupertinoIcons.square_stack_3d_up,
                        accent: scheme.tertiary,
                        child: _amountGrid(context, _assetControllers, [
                          (l10n.zakatCash, CupertinoIcons.money_dollar),
                          (l10n.zakatSavings, CupertinoIcons.archivebox),
                          (l10n.zakatGoldValue, CupertinoIcons.star),
                          (
                            l10n.zakatSilverValue,
                            CupertinoIcons.circle_grid_3x3,
                          ),
                          (l10n.zakatInvestments, CupertinoIcons.chart_bar),
                          (l10n.zakatBusiness, CupertinoIcons.bag),
                          (l10n.zakatReceivables, CupertinoIcons.person_2),
                          (l10n.zakatOtherAssets, CupertinoIcons.add_circled),
                        ]),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ZakatSection(
                        title: l10n.zakatLiabilitiesTitle,
                        subtitle: l10n.zakatLiabilitiesHint,
                        icon: CupertinoIcons.arrow_down_right_circle,
                        accent: scheme.primary,
                        child: _amountGrid(context, _liabilityControllers, [
                          (l10n.zakatDebts, CupertinoIcons.creditcard),
                          (l10n.zakatBills, CupertinoIcons.doc_text),
                        ]),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Container(
                        decoration: BoxDecoration(
                          color: _lunarYearComplete
                              ? scheme.tertiary.withValues(alpha: 0.12)
                              : scheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(
                            color: _lunarYearComplete
                                ? scheme.tertiary.withValues(alpha: 0.45)
                                : scheme.outlineVariant,
                          ),
                        ),
                        child: SwitchListTile.adaptive(
                          value: _lunarYearComplete,
                          onChanged: (value) =>
                              setState(() => _lunarYearComplete = value),
                          secondary: Icon(
                            CupertinoIcons.moon_stars,
                            color: scheme.tertiary,
                          ),
                          title: Text(
                            l10n.zakatLunarYearTitle,
                            style: AppTheme.text(context).titleSmall.copyWith(
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                          subtitle: Text(
                            l10n.zakatLunarYearBody,
                            style: AppTheme.text(context).bodySmall.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ZakatResultCard(
                        calculation: calculation,
                        currency: _currency,
                        hasInvalidAmount: hasInvalidAmount,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const ZakatGuideCard(),
                      const SizedBox(height: AppSpacing.lg),
                      TextButton.icon(
                        onPressed: _reset,
                        icon: const Icon(CupertinoIcons.refresh),
                        label: Text(l10n.zakatReset),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _currencyPicker(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: scheme.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                CupertinoIcons.globe,
                color: scheme.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                context.l10n.zakatCurrency,
                style: AppTheme.text(
                  context,
                ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
              ),
            ),
            DropdownMenu<ZakatCurrency>(
              key: ValueKey(_currencyMenuRevision),
              width: constraints.maxWidth < 360 ? 132 : 170,
              initialSelection: _currency,
              onSelected: (currency) {
                if (currency != null) _changeCurrency(currency);
              },
              dropdownMenuEntries: [
                for (final currency in ZakatCurrency.values)
                  DropdownMenuEntry(
                    value: currency,
                    label: '${currency.code}  ${currency.symbol}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountGrid(
    BuildContext context,
    List<TextEditingController> controllers,
    List<(String, IconData)> fields,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns = constraints.maxWidth >= 540;
      final width = twoColumns
          ? (constraints.maxWidth - AppSpacing.md) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: AppSpacing.md,
        children: [
          for (var index = 0; index < fields.length; index++)
            SizedBox(
              width: width,
              child: ZakatAmountField(
                label: fields[index].$1,
                icon: fields[index].$2,
                symbol: _currency.symbol,
                controller: controllers[index],
                onChanged: _recalculate,
              ),
            ),
        ],
      );
    },
  );
}
