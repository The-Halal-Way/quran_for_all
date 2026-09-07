import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';
import 'daily_duah_data.dart';
import 'daily_duah_detail_block.dart';
import 'daily_duah_sub_item_card.dart';

class DailyDuahDetailSheet extends StatefulWidget {
  const DailyDuahDetailSheet({super.key, required this.item});

  final DuahItem item;

  @override
  State<DailyDuahDetailSheet> createState() => _DailyDuahDetailSheetState();
}

class _DailyDuahDetailSheetState extends State<DailyDuahDetailSheet> {
  bool _copied = false;

  Future<void> _copy() async {
    final item = widget.item;
    await Clipboard.setData(
      ClipboardData(
        text:
            '${item.arabic}\n${item.localizedPronunciation(context)}\n${item.localizedTranslation(context)}',
      ),
    );
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.76,
      minChildSize: 0.42,
      maxChildSize: 0.94,
      builder: (context, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.localizedTitle(context),
                    style: text.titleLarge.copyWith(
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                  onPressed: _copy,
                  icon: Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 19,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: MyColors.primary.withValues(alpha: 0.055),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: MyColors.primaryLight.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                item.arabic,
                textAlign: TextAlign.right,
                textDirection: ui.TextDirection.rtl,
                style: text.headlineMedium.copyWith(height: 1.8),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            DailyDuahDetailBlock(
              color: MyColors.primaryLight,
              text: item.localizedPronunciation(context),
              italic: true,
            ),
            const SizedBox(height: AppSpacing.md),
            DailyDuahDetailBlock(
              color: MyColors.tertiary,
              text: item.localizedTranslation(context),
            ),
            if (item.note != null) ...[
              const SizedBox(height: AppSpacing.lg),
              DailyDuahDetailBlock(
                color: MyColors.secondary,
                text: item.note!,
                icon: Icons.info_outline_rounded,
              ),
            ],
            for (final subItem in item.subItems) ...[
              const SizedBox(height: AppSpacing.lg),
              DailyDuahSubItemCard(item: subItem),
            ],
          ],
        ),
      ),
    );
  }
}
