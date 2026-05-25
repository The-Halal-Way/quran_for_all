import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import 'daily_duah_data.dart';

class DuahCard extends StatefulWidget {
  const DuahCard({super.key, required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  State<DuahCard> createState() => DuahCardState();
}

class DuahCardState extends State<DuahCard> {
  bool _expanded = false;
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(
      ClipboardData(
        text:
            '${widget.item.arabic}\n${widget.item.localizedPronunciation(context)}\n${widget.item.localizedTranslation(context)}',
      ),
    );
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = widget.isDark;
    final item = widget.item;

    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final hasExtra = item.subItems.isNotEmpty || item.note != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.localizedTitle(context),
                        style: text.duahCardLabel.copyWith(
                          color: isDark
                              ? const Color(0xFF7E57C2)
                              : const Color(0xFF4C425C),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF00BFA5).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                          size: 16,
                          color: _copied
                              ? const Color(0xFF00BFA5)
                              : (isDark
                                    ? const Color(0xFF7E57C2)
                                    : const Color(0xFF7A7288)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.40 : 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(
                        0xFF4B30A1,
                      ).withValues(alpha: isDark ? 0.20 : 0.10),
                    ),
                  ),
                  child: Text(
                    item.arabic,
                    textAlign: TextAlign.right,
                    textDirection: ui.TextDirection.rtl,
                    style: text.duahCardArabic.copyWith(
                      color: isDark
                          ? const Color(0xFFEDE7F6)
                          : const Color(0xFF120B24),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B30A1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.localizedPronunciation(context),
                        style: text.duahCardBodyItalic.copyWith(
                          color: isDark
                              ? const Color(0xFFB39DDB)
                              : const Color(0xFF4C425C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.localizedTranslation(context),
                        style: text.duahCardBody.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF00BFA5).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFF00BFA5),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.note!,
                            style: text.bodySmall.copyWith(
                              color: isDark
                                  ? const Color(0xFF64FFDA)
                                  : const Color(0xFF00897B),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasExtra) ...[
            Divider(height: 1, color: borderC),
            InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF4C425C),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _expanded
                          ? context.l10n.duahHideVariants
                          : context.l10n.duahShowVariants,
                      style: text.duahVariantToggle.copyWith(
                        color: isDark
                            ? const Color(0xFF7E57C2)
                            : const Color(0xFF4C425C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              ...item.subItems.map(
                (sub) => SubItemTile(item: sub, isDark: isDark),
              ),
          ],
        ],
      ),
    );
  }
}

class SubItemTile extends StatelessWidget {
  const SubItemTile({super.key, required this.item, required this.isDark});

  final DuahItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD50057).withValues(alpha: isDark ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD50057).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.localizedTitle(context),
            style: text.duahSubItemTitle.copyWith(
              color: const Color(0xFFD50057),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.arabic,
            textAlign: TextAlign.right,
            textDirection: ui.TextDirection.rtl,
            style: text.duahSubItemArabic.copyWith(
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.localizedPronunciation(context),
            style: text.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.localizedTranslation(context),
            style: text.bodySmall.copyWith(
              color: isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24),
            ),
          ),
        ],
      ),
    );
  }
}
