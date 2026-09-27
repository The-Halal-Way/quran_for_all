import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/repositories/tasbeeh_repository_impl.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'legacy counts and selection restore without a custom phrase list',
    () async {
      SharedPreferences.setMockInitialValues({
        'tasbeeh_state_v1': jsonEncode({
          'counts': {'subhanAllah': 14, 'allahuAkbar': 25},
          'targets': {'allahuAkbar': 99},
          'selectedPhrase': 'allahuAkbar',
        }),
      });
      final model = TasbeehViewModel(repository: TasbeehRepositoryImpl());
      await model.load();
      expect(model.count, 25);
      expect(model.target, 99);
      expect(model.totalCount, 39);
      expect(model.phrases, hasLength(4));
    },
  );

  test(
    'custom phrases, edits and rapid counts survive a new app session',
    () async {
      final original = TasbeehViewModel(repository: TasbeehRepositoryImpl());
      await original.load();
      final id = original.addPhrase(
        name: 'Istighfar',
        arabic: 'أَسْتَغْفِرُ الله',
        target: 7,
      )!;
      for (var index = 0; index < 80; index++) {
        original.increment();
      }
      original.decrement();
      original.editPhrase(
        id: id,
        name: 'Daily istighfar',
        arabic: 'أَسْتَغْفِرُ الله',
        target: 70,
      );
      await original.pendingSave;
      final restored = TasbeehViewModel(repository: TasbeehRepositoryImpl());
      await restored.load();
      expect(restored.selectedPhraseId, id);
      expect(restored.selectedPhrase.name, 'Daily istighfar');
      expect(restored.count, 79);
      expect(restored.target, 70);
      expect(restored.phrases, hasLength(5));
      restored.deletePhrase(id);
      await restored.pendingSave;
      final afterDelete = TasbeehViewModel(repository: TasbeehRepositoryImpl());
      await afterDelete.load();
      expect(afterDelete.phrases, hasLength(4));
      expect(afterDelete.totalCount, 0);
      expect(afterDelete.selectedPhraseId, 'subhanAllah');
    },
  );

  test(
    'malformed custom entries cannot override built-ins or pollute totals',
    () async {
      SharedPreferences.setMockInitialValues({
        'tasbeeh_state_v1': jsonEncode({
          'counts': {'subhanAllah': 12, 'custom_valid': -3, 'orphan': 100},
          'targets': {'subhanAllah': 0, 'custom_valid': -1},
          'selectedPhrase': 'orphan',
          'customPhrases': [
            {'id': 'subhanAllah', 'name': 'Overwrite', 'arabic': 'wrong'},
            {'id': 'custom_valid', 'name': 'A dhikr', 'arabic': ''},
            {'id': 'custom_valid', 'name': 'Duplicate', 'arabic': ''},
            {'id': 'custom_empty', 'name': ''},
            {'id': 'custom_invalid', 'name': 42},
            'not a phrase',
          ],
        }),
      });
      final model = TasbeehViewModel(repository: TasbeehRepositoryImpl());
      await model.load();
      expect(model.phrases, hasLength(5));
      expect(model.phrases.first.arabic, 'سُبْحَانَ الله');
      expect(model.totalCount, 12);
      expect(model.countFor('custom_valid'), 0);
      expect(model.targetFor('custom_valid'), 33);
      expect(model.selectedPhraseId, 'subhanAllah');
    },
  );
}
