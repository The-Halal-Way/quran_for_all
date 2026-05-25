import 'package:flutter/foundation.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';

class PrayerViewModel extends ChangeNotifier {
  static const List<PrayerKey> _order = [
    PrayerKey.fajr,
    PrayerKey.sunrise,
    PrayerKey.dhuhr,
    PrayerKey.asr,
    PrayerKey.maghrib,
    PrayerKey.isha,
  ];

  Map<String, String> _prayerTimes = const <String, String>{};
  Map<String, String> _prayerTimeRanges = const <String, String>{};
  String? _nextPrayerKey;

  Map<String, String> get prayerTimes => _prayerTimes;
  Map<String, String> get prayerTimeRanges => _prayerTimeRanges;
  String? get nextPrayerKey => _nextPrayerKey;
  bool get hasTimes => _prayerTimes.isNotEmpty;

  PrayerKey? get nextPrayer => _fromScheduleKey(_nextPrayerKey);

  PrayerKey get focusPrayer {
    if (!hasTimes) {
      return _fallbackPrayerForNow();
    }

    final next = nextPrayer;
    if (next == null) {
      return PrayerKey.isha;
    }
    if (next == PrayerKey.sunrise) {
      return PrayerKey.fajr;
    }
    return next;
  }

  void sync({
    required Map<String, String>? prayerTimes,
    required Map<String, String>? prayerTimeRanges,
    required String? nextPrayerKey,
    bool notify = true,
  }) {
    final nextTimes = Map<String, String>.unmodifiable(
      prayerTimes ?? const <String, String>{},
    );
    final nextTimeRanges = Map<String, String>.unmodifiable(
      prayerTimeRanges ?? const <String, String>{},
    );

    if (mapEquals(_prayerTimes, nextTimes) &&
        mapEquals(_prayerTimeRanges, nextTimeRanges) &&
        _nextPrayerKey == nextPrayerKey) {
      return;
    }

    _prayerTimes = nextTimes;
    _prayerTimeRanges = nextTimeRanges;
    _nextPrayerKey = nextPrayerKey;

    if (notify) {
      notifyListeners();
    }
  }

  String focusTime(AppLocalizations l10n) {
    return _prayerTimeRanges[focusPrayer.scheduleKey] ??
        _prayerTimes[focusPrayer.scheduleKey] ??
        l10n.prayerViewNoTime;
  }

  List<PrayerTimelineItem> timeline(AppLocalizations l10n) {
    final next = nextPrayer;
    final focus = focusPrayer;
    final nextIndex = next == null ? -1 : _order.indexOf(next);

    return _order.map((prayer) {
      final index = _order.indexOf(prayer);
      final isNext = prayer == next;
      final isFocus = prayer == focus;
      final isPassed = nextIndex == -1 ? hasTimes : index < nextIndex;

      return PrayerTimelineItem(
        prayer: prayer,
        name: localizedPrayerName(l10n, prayer),
        time:
            _prayerTimeRanges[prayer.scheduleKey] ??
            _prayerTimes[prayer.scheduleKey] ??
            l10n.prayerViewNoTime,
        isNext: isNext,
        isFocus: isFocus,
        isPassed: isPassed && !isFocus,
      );
    }).toList();
  }

  PrayerFocusContent focusContent(AppLocalizations l10n) {
    final prayer = focusPrayer;

    return PrayerFocusContent(
      prayer: prayer,
      title: _focusTitle(l10n, prayer),
      subtitle: _focusSubtitle(l10n, prayer),
      now: PrayerGuidanceItem(
        title: _nowTitle(l10n, prayer),
        body: _nowBody(l10n, prayer),
      ),
      suggestions: _splitRaw(_suggestionsRaw(l10n, prayer)),
      bestPractices: _splitRaw(_bestPracticesRaw(l10n, prayer)),
    );
  }

  List<PrayerGuidanceItem> howToPraySteps(AppLocalizations l10n) {
    return [
      PrayerGuidanceItem(
        title: l10n.prayerHowIntentionTitle,
        body: l10n.prayerHowIntentionBody,
      ),
      PrayerGuidanceItem(
        title: l10n.prayerHowQiyamTitle,
        body: l10n.prayerHowQiyamBody,
      ),
      PrayerGuidanceItem(
        title: l10n.prayerHowRukuTitle,
        body: l10n.prayerHowRukuBody,
      ),
      PrayerGuidanceItem(
        title: l10n.prayerHowSujoodTitle,
        body: l10n.prayerHowSujoodBody,
      ),
      PrayerGuidanceItem(
        title: l10n.prayerHowTashahhudTitle,
        body: l10n.prayerHowTashahhudBody,
      ),
      PrayerGuidanceItem(
        title: l10n.prayerHowSalamTitle,
        body: l10n.prayerHowSalamBody,
      ),
    ];
  }

  String localizedPrayerName(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.dashboardPrayerFajr;
      case PrayerKey.sunrise:
        return l10n.dashboardPrayerSunrise;
      case PrayerKey.dhuhr:
        return l10n.dashboardPrayerDhuhr;
      case PrayerKey.asr:
        return l10n.dashboardPrayerAsr;
      case PrayerKey.maghrib:
        return l10n.dashboardPrayerMaghrib;
      case PrayerKey.isha:
        return l10n.dashboardPrayerIsha;
    }
  }

  PrayerKey? _fromScheduleKey(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }

    for (final prayer in _order) {
      if (prayer.scheduleKey == key) {
        return prayer;
      }
    }

    return null;
  }

  PrayerKey _fallbackPrayerForNow() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return PrayerKey.fajr;
    }
    if (hour < 12) {
      return PrayerKey.dhuhr;
    }
    if (hour < 16) {
      return PrayerKey.asr;
    }
    if (hour < 19) {
      return PrayerKey.maghrib;
    }
    return PrayerKey.isha;
  }

  List<String> _splitRaw(String raw) {
    return raw
        .split('||')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  String _focusTitle(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerFocusFajrTitle;
      case PrayerKey.sunrise:
        return l10n.prayerFocusSunriseTitle;
      case PrayerKey.dhuhr:
        return l10n.prayerFocusDhuhrTitle;
      case PrayerKey.asr:
        return l10n.prayerFocusAsrTitle;
      case PrayerKey.maghrib:
        return l10n.prayerFocusMaghribTitle;
      case PrayerKey.isha:
        return l10n.prayerFocusIshaTitle;
    }
  }

  String _focusSubtitle(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerFocusFajrSubtitle;
      case PrayerKey.sunrise:
        return l10n.prayerFocusSunriseSubtitle;
      case PrayerKey.dhuhr:
        return l10n.prayerFocusDhuhrSubtitle;
      case PrayerKey.asr:
        return l10n.prayerFocusAsrSubtitle;
      case PrayerKey.maghrib:
        return l10n.prayerFocusMaghribSubtitle;
      case PrayerKey.isha:
        return l10n.prayerFocusIshaSubtitle;
    }
  }

  String _nowTitle(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerNowFajrTitle;
      case PrayerKey.sunrise:
        return l10n.prayerNowSunriseTitle;
      case PrayerKey.dhuhr:
        return l10n.prayerNowDhuhrTitle;
      case PrayerKey.asr:
        return l10n.prayerNowAsrTitle;
      case PrayerKey.maghrib:
        return l10n.prayerNowMaghribTitle;
      case PrayerKey.isha:
        return l10n.prayerNowIshaTitle;
    }
  }

  String _nowBody(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerNowFajrBody;
      case PrayerKey.sunrise:
        return l10n.prayerNowSunriseBody;
      case PrayerKey.dhuhr:
        return l10n.prayerNowDhuhrBody;
      case PrayerKey.asr:
        return l10n.prayerNowAsrBody;
      case PrayerKey.maghrib:
        return l10n.prayerNowMaghribBody;
      case PrayerKey.isha:
        return l10n.prayerNowIshaBody;
    }
  }

  String _suggestionsRaw(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerSuggestionsFajrRaw;
      case PrayerKey.sunrise:
        return l10n.prayerSuggestionsSunriseRaw;
      case PrayerKey.dhuhr:
        return l10n.prayerSuggestionsDhuhrRaw;
      case PrayerKey.asr:
        return l10n.prayerSuggestionsAsrRaw;
      case PrayerKey.maghrib:
        return l10n.prayerSuggestionsMaghribRaw;
      case PrayerKey.isha:
        return l10n.prayerSuggestionsIshaRaw;
    }
  }

  String _bestPracticesRaw(AppLocalizations l10n, PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return l10n.prayerBestPracticesFajrRaw;
      case PrayerKey.sunrise:
        return l10n.prayerBestPracticesSunriseRaw;
      case PrayerKey.dhuhr:
        return l10n.prayerBestPracticesDhuhrRaw;
      case PrayerKey.asr:
        return l10n.prayerBestPracticesAsrRaw;
      case PrayerKey.maghrib:
        return l10n.prayerBestPracticesMaghribRaw;
      case PrayerKey.isha:
        return l10n.prayerBestPracticesIshaRaw;
    }
  }
}
