import 'package:flutter/foundation.dart';
import 'package:quran_for_all/data/datasources/local/prayer/prayer_movement_content.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/data/models/prayer/prayer_guide_variant.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import '../../models/prayer_movement_assets.dart';

class PrayerMovementGuideViewModel extends ChangeNotifier {
  PrayerGuideVariant _variant = PrayerGuideVariant.male;

  PrayerGuideVariant get variant => _variant;

  void selectVariant(PrayerGuideVariant variant) {
    if (variant == _variant) return;
    _variant = variant;
    notifyListeners();
  }

  List<PrayerMovementStep> steps(AppLocalizations l10n) {
    final isBangla = _isBangla(l10n);

    return prayerMovementSteps
        .map((step) {
          return PrayerMovementStep(
            number: step.number,
            title: _pick(isBangla, step.title, step.titleBn),
            badge: _pick(isBangla, step.badge, step.badgeBn),
            body: _pick(isBangla, step.body, step.bodyBn),
            imageAsset: PrayerMovementAssets.forVariant(
              step.imageAsset,
              _variant,
            ),
            mirrorImage: PrayerMovementAssets.mirrorForVariant(
              step.imageAsset,
              _variant,
            ),
            arabic: step.arabic,
            pronunciation: _pick(
              isBangla,
              step.pronunciation,
              step.pronunciationBn,
            ),
            translation: _pick(isBangla, step.translation, step.translationBn),
            note: _pick(isBangla, step.note, step.noteBn),
          );
        })
        .toList(growable: false);
  }

  List<PrayerHadithReference> hadiths(AppLocalizations l10n) {
    final isBangla = _isBangla(l10n);

    return prayerMovementHadiths
        .map((hadith) {
          return PrayerHadithReference(
            source: hadith.source,
            body: _pick(isBangla, hadith.body, hadith.bodyBn),
          );
        })
        .toList(growable: false);
  }

  bool _isBangla(AppLocalizations l10n) => l10n.localeName.startsWith('bn');

  String _pick(bool isBangla, String english, String bangla) {
    return isBangla ? bangla : english;
  }
}
