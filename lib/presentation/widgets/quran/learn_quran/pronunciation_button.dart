import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../services/pronunciation_service.dart';

/// Extracts Arabic characters (and common diacritics) from mixed text.
///
/// Useful when a display string contains transliteration in parentheses,
/// e.g. `'قَالَ (qaala)'` → `'قَالَ'`.
String extractArabic(String text) {
  // Unicode ranges: Arabic (0600–06FF), Arabic Supplement (0750–077F),
  // Arabic Extended-A (08A0–08FF), Arabic Presentation Forms-A/B.
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if ((rune >= 0x0600 && rune <= 0x06FF) ||
        (rune >= 0x0750 && rune <= 0x077F) ||
        (rune >= 0x08A0 && rune <= 0x08FF) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF) ||
        rune == 0x20) {
      // Keep Arabic characters and spaces.
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString().trim();
}

/// Plays recorded letter names, or device speech for other Arabic exercises.
///
/// Tapping while idle starts playback; tapping while the same text is
/// playing stops it (toggle behaviour).
class PronunciationButton extends StatefulWidget {
  const PronunciationButton({
    super.key,
    required this.arabicText,
    this.size = 20,
    this.color,
  });

  /// The Arabic text to speak when tapped.
  final String arabicText;

  /// Icon size. Defaults to 20.
  final double size;

  /// Optional colour override; falls back to `colorScheme.primary`.
  final Color? color;

  @override
  State<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends State<PronunciationButton> {
  StreamSubscription<bool>? _subscription;
  bool _isActive = false;
  bool _waiting = false;
  int _tapRequest = 0;

  PronunciationService get _service => context.read<PronunciationService>();

  @override
  void initState() {
    super.initState();
    _subscription = _service.speakingStream.listen(_onSpeakingChanged);
  }

  void _onSpeakingChanged(bool speaking) {
    if (!mounted) return;
    final active = speaking && _service.currentText == widget.arabicText;
    if (active != _isActive) {
      setState(() => _isActive = active);
    }
  }

  @override
  void didUpdateWidget(covariant PronunciationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arabicText != widget.arabicText) {
      _isActive =
          _service.isSpeaking && _service.currentText == widget.arabicText;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _onTap() async {
    final request = ++_tapRequest;
    final service = _service;
    setState(() => _waiting = true);
    try {
      await service.speak(widget.arabicText);
    } on PronunciationException catch (error) {
      if (!mounted || request != _tapRequest) return;
      final missingVoice =
          error.failure == PronunciationFailure.arabicVoiceUnavailable;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            missingVoice
                ? l10n.learnPronunciationVoiceMissing
                : l10n.learnPronunciationFailed,
          ),
          action: missingVoice && service.canInstallVoice
              ? SnackBarAction(
                  label: l10n.learnPronunciationInstallVoice,
                  onPressed: () async {
                    final opened = await service.installArabicVoice();
                    if (!opened && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.learnPronunciationVoiceMissing,
                          ),
                        ),
                      );
                    }
                  },
                )
              : null,
        ),
      );
    } finally {
      if (mounted && request == _tapRequest) setState(() => _waiting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        widget.color ?? Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: context.l10n.learnPronunciationTooltip,
      child: Semantics(
        button: true,
        label: context.l10n.learnPronunciationTooltip,
        child: GestureDetector(
          onTap: _onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _waiting && !_isActive
                ? SizedBox.square(
                    dimension: widget.size,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: effectiveColor,
                    ),
                  )
                : Icon(
                    _isActive
                        ? Icons.volume_up_rounded
                        : Icons.volume_up_outlined,
                    size: widget.size,
                    color: effectiveColor,
                  ),
          ),
        ),
      ),
    );
  }
}
