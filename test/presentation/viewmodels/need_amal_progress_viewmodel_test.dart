import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/need_amal_progress_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/need_amal.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/need_amals.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('all twelve practices have structured, referenced guidance', () {
    expect(needAmals, hasLength(12));
    expect(needAmals.map((amal) => amal.id).toSet(), hasLength(12));
    expect(
      needAmals.map((amal) => amal.category).toSet(),
      NeedCategory.values.toSet(),
    );
    for (final amal in needAmals) {
      expect(amal.title.en, isNotEmpty);
      expect(amal.title.bn, isNotEmpty);
      expect(amal.description.en, isNotEmpty);
      expect(amal.description.bn, isNotEmpty);
      expect(amal.steps, isNotEmpty);
      expect(amal.authenticity.en, isNotEmpty);
      expect(amal.evidenceNote.en, isNotEmpty);
      expect(amal.timing.en, isNotEmpty);
      expect(amal.references, isNotEmpty);
      expect(
        amal.references.every((ref) => Uri.parse(ref.url).hasScheme),
        isTrue,
      );
      if (amal.arabic != null) {
        expect(amal.transliteration, isNotEmpty);
        expect(amal.meaning?.en, isNotEmpty);
        expect(amal.meaning?.bn, isNotEmpty);
      } else {
        expect(amal.duaNote, isNotNull);
      }
    }
    final hajah = needAmals.singleWhere((amal) => amal.id == 'salatul_hajah');
    expect(hajah.authenticity.en.toLowerCase(), contains('weak'));
    final yunus = needAmals.singleWhere((amal) => amal.id == 'yunus_dua');
    expect(yunus.evidenceNote.en, contains('not a prescribed number'));
  });

  test('personal progress persists and daily values reset next day', () async {
    var currentDay = DateTime(2026, 9, 28, 10);
    final first = NeedAmalProgressViewModel(now: () => currentDay);
    await first.load();
    await first.changeJuz(3);
    await first.changeYunusCount(7);
    await first.toggleComplete('tahajjud');
    first.dispose();

    final sameDay = NeedAmalProgressViewModel(now: () => currentDay);
    await sameDay.load();
    expect(sameDay.juz, 3);
    expect(sameDay.yunusCount, 7);
    expect(sameDay.isCompleted('tahajjud'), isTrue);
    sameDay.dispose();

    currentDay = DateTime(2026, 9, 29, 10);
    final nextDay = NeedAmalProgressViewModel(now: () => currentDay);
    await nextDay.load();
    expect(nextDay.juz, 3);
    expect(nextDay.yunusCount, 0);
    expect(nextDay.isCompleted('tahajjud'), isFalse);
    nextDay.dispose();
  });
}
