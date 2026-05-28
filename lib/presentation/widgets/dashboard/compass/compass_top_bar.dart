import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassTopBar extends StatelessWidget {
  const CompassTopBar({
    super.key,
    required this.isDark,
    required this.directionLabel,
  });

  final bool isDark;
  final String directionLabel;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final textPrimary = isDark
        ? const Color(0xFFEDE7F6)
        : const Color(0xFF120B24);
    final textSecondary = isDark
        ? const Color(0xFF7E57C2)
        : const Color(0xFF4C425C);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back_ios_new, color: textPrimary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.compassTitle,
                  style: text.compassTitle.copyWith(color: textPrimary),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        directionLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.compassSubtitle.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
