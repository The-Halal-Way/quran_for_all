import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/zakat/zakat_calculator.dart';

class ZakatAmountField extends StatelessWidget {
  const ZakatAmountField({
    super.key,
    required this.label,
    required this.icon,
    required this.symbol,
    required this.controller,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final IconData icon;
  final String symbol;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final invalid = ZakatCalculation.tryParseAmount(controller.text) == null;
    final text = AppTheme.text(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text.labelMedium.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: AppTheme.weightBold,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            style: text.bodyLarge.copyWith(
              color: scheme.onSurface,
              fontWeight: AppTheme.weightSemiBold,
            ),
            decoration: InputDecoration(
              hintText: hint ?? context.l10n.zakatAmountHint,
              errorText: invalid ? context.l10n.zakatInvalidAmount : null,
              prefixIcon: Icon(icon, color: scheme.tertiary, size: 20),
              suffixText: symbol,
              suffixStyle: text.labelLarge.copyWith(
                color: scheme.tertiary,
                fontWeight: AppTheme.weightExtraBold,
              ),
              filled: true,
              fillColor: scheme.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: scheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: scheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: scheme.tertiary, width: 1.6),
              ),
            ),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ],
      ),
    );
  }
}
