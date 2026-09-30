import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/datasources/local/prayer/prayer_seated_content.dart';
import 'package:quran_for_all/data/datasources/local/prayer/prayer_standing_content.dart';
import 'package:quran_for_all/data/datasources/tasbeeh_phrases_data.dart';
import 'package:quran_for_all/l10n/app_localizations_en.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/need_amals.dart';
import 'package:quran_for_all/presentation/views/prayer/eid_prayer/content/eid_remembrance_content.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_suggestions.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/daily_duah/daily_duah_data.dart';

void main() {
  test('prayer recitations retain Quranic and separated Madd', () {
    expect(
      prayerStandingSteps[1].arabic,
      'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\n'
      'ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n'
      'مَٰلِكِ يَوْمِ ٱلدِّينِ\n'
      'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n'
      'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\n'
      'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\n'
      'غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ',
    );
    expect(prayerSeatedSteps[2].arabic, contains('لَآ إِلٰهَ'));
    expect(RegExp('عَلَىٰٓ').allMatches(prayerSeatedSteps[3].arabic).length, 6);
  });

  test('need and Eid duas retain the Madd positions in their quotations', () {
    String arabic(String id) =>
        needAmals.singleWhere((amal) => amal.id == id).arabic!;

    expect(
      arabic('yunus_dua'),
      'لَآ إِلَٰهَ إِلَّآ أَنتَ سُبْحَٰنَكَ إِنِّى كُنتُ مِنَ ٱلظَّٰلِمِينَ',
    );
    expect(arabic('istighfar'), contains('أَبُوٓءُ'));
    expect(arabic('iftar_dua'), contains('إِنِّيٓ أَسْأَلُكَ'));
    expect(arabic('salatul_hajah'), contains('عَزَآئِمَ'));
    expect(eidTakbeer, contains('لَآ إِلَهَ'));
    expect(eidDuasSection.entries[0].arabic, contains('مِنَّآ إِنَّكَ'));
    expect(eidDuasSection.entries[1].arabic, contains('أَوْزِعْنِىٓ أَنْ'));
  });

  test('daily dua and tasbeeh samples cover joined and separated Madd', () {
    final daily = [
      for (final level in DuahLevel.values)
        for (final category in DuahData.forLevel(level))
          for (final item in category.items) ...[
            item.arabic,
            for (final subItem in item.subItems) subItem.arabic,
          ],
    ].join('\n');

    for (final passage in [
      'إِنِّيٓ أَعُوذُ',
      'الْخَبَآئِثِ',
      'الَّذِيٓ أَحْيَانَا',
      'مَآ أَمَاتَنَا',
      'شِفَآءَ إِلَّا شِفَآؤُكَ',
    ]) {
      expect(daily, contains(passage));
    }
    expect(builtInTasbeehPhrases.last.arabic, contains('لَآ إِلَٰهَ'));
    final suggestions = tasbeehSuggestions(AppLocalizationsEn());
    expect(
      suggestions.any(
        (suggestion) => suggestion.arabic.contains('رَبَّنَآ ءَاتِنَا'),
      ),
      isTrue,
    );
    expect(
      suggestions.any(
        (suggestion) => suggestion.arabic.contains('لِمَآ أَنزَلْتَ'),
      ),
      isTrue,
    );
  });
}
