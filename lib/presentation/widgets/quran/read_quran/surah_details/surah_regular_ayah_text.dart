import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/ayah_model.dart';

/// The continuous reading paragraph keeps its tap recognizers for the life of
/// the widget instead of allocating a new one for every rebuild.
class SurahRegularAyahText extends StatefulWidget {
  const SurahRegularAyahText({
    super.key,
    required this.ayahs,
    required this.ayahKeys,
    required this.playingAyahNumber,
    required this.highlightedAyahNumber,
    required this.onAyahTap,
  });

  final List<AyahModel> ayahs;
  final Map<int, GlobalKey> ayahKeys;
  final int? playingAyahNumber;
  final int? highlightedAyahNumber;
  final ValueChanged<AyahModel> onAyahTap;

  @override
  State<SurahRegularAyahText> createState() => _SurahRegularAyahTextState();
}

class _SurahRegularAyahTextState extends State<SurahRegularAyahText> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  @override
  void didUpdateWidget(covariant SurahRegularAyahText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ayahs != widget.ayahs) {
      final current = widget.ayahs.map((ayah) => ayah.ayahNumber).toSet();
      for (final number in _recognizers.keys.toList()) {
        if (!current.contains(number)) {
          _recognizers.remove(number)?.dispose();
        }
      }
    }
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeSize = MediaQuery.textScalerOf(context).scale(14) + 10;
    final spans = <InlineSpan>[];
    for (final ayah in widget.ayahs) {
      final recognizer = _recognizers.putIfAbsent(
        ayah.ayahNumber,
        TapGestureRecognizer.new,
      )..onTap = () => widget.onAyahTap(ayah);
      final isPlaying = ayah.ayahNumber == widget.playingAyahNumber;
      final isHighlighted = ayah.ayahNumber == widget.highlightedAyahNumber;

      spans.add(
        TextSpan(
          text: '${ayah.arabicText} ',
          style: isPlaying
              ? TextStyle(
                  backgroundColor: scheme.secondary.withValues(alpha: 0.28),
                )
              : isHighlighted
              ? TextStyle(
                  backgroundColor: scheme.primary.withValues(alpha: 0.14),
                )
              : null,
          recognizer: recognizer,
        ),
      );
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            width: badgeSize < 24 ? 24 : badgeSize,
            height: badgeSize < 24 ? 24 : badgeSize,
            alignment: Alignment.center,
            margin: const EdgeInsetsDirectional.only(start: AppSpacing.xs),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.14),
              border: Border.all(color: scheme.primary.withValues(alpha: 0.45)),
            ),
            child: Text(
              '${ayah.ayahNumber}',
              style: AppTheme.text(context).labelSmall.copyWith(
                fontWeight: AppTheme.weightBold,
                color: scheme.primary,
              ),
            ),
          ),
        ),
      );
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            key: widget.ayahKeys.putIfAbsent(ayah.ayahNumber, GlobalKey.new),
            width: 0,
            height: 0,
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textDirection: TextDirection.rtl,
      style: AppTheme.quranArabic(context).copyWith(height: 2.5.h),
    );
  }
}
