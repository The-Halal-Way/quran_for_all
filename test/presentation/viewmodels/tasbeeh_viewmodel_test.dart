import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/tasbeeh_state.dart';
import 'package:quran_for_all/domain/repositories/tasbeeh_repository.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';

void main() {
  test('each dhikr keeps its own count and target', () async {
    final repository = _MemoryTasbeehRepository();
    final viewModel = TasbeehViewModel(repository: repository);
    await viewModel.load();

    viewModel.increment();
    viewModel.increment();
    viewModel.selectPhrase(TasbeehPhraseKey.alhamdulillah.name);

    expect(viewModel.count, 0);
    expect(viewModel.target, 33);

    viewModel.selectTarget(99);
    viewModel.increment();
    viewModel.selectPhrase(TasbeehPhraseKey.subhanAllah.name);

    expect(viewModel.count, 2);
    expect(viewModel.target, 33);
    expect(viewModel.countFor(TasbeehPhraseKey.alhamdulillah.name), 1);
    expect(viewModel.targetFor(TasbeehPhraseKey.alhamdulillah.name), 99);
    expect(viewModel.totalCount, 3);
  });

  test(
    'count continues after a target and reset only affects its scope',
    () async {
      final viewModel = TasbeehViewModel(
        repository: _MemoryTasbeehRepository(),
      );
      await viewModel.load();

      for (var index = 0; index < 33; index++) {
        viewModel.increment();
      }
      expect(viewModel.count, 33);
      expect(viewModel.isTargetReached, isTrue);
      expect(viewModel.completedRounds, 1);

      viewModel.increment();
      expect(viewModel.count, 34);
      expect(viewModel.isTargetReached, isFalse);

      viewModel.selectPhrase(TasbeehPhraseKey.allahuAkbar.name);
      viewModel.increment();
      viewModel.resetCount();
      expect(viewModel.count, 0);

      viewModel.selectPhrase(TasbeehPhraseKey.subhanAllah.name);
      expect(viewModel.count, 34);

      viewModel.resetAll();
      expect(viewModel.totalCount, 0);
    },
  );

  test('counts, targets and selected dhikr restore from storage', () async {
    final repository = _MemoryTasbeehRepository();
    final original = TasbeehViewModel(repository: repository);
    await original.load();

    original.selectPhrase(TasbeehPhraseKey.laIlahaIllallah.name);
    original.selectTarget(100);
    original.increment();
    original.increment();
    await original.pendingSave;

    final restored = TasbeehViewModel(repository: repository);
    await restored.load();

    expect(restored.selectedPhraseId, TasbeehPhraseKey.laIlahaIllallah.name);
    expect(restored.count, 2);
    expect(restored.target, 100);
  });

  test(
    'built-in phrases cannot be edited or deleted through the model',
    () async {
      final model = TasbeehViewModel(repository: _MemoryTasbeehRepository());
      await model.load();
      final originals = List.of(model.phrases);
      for (final phrase in originals) {
        expect(
          model.editPhrase(
            id: phrase.id,
            name: 'Changed',
            arabic: '',
            target: 10,
          ),
          isFalse,
        );
        expect(model.deletePhrase(phrase.id), isFalse);
      }
      expect(model.phrases, originals);
    },
  );

  test(
    'custom edits retain progress and deletion falls back without resetting a built-in',
    () async {
      final model = TasbeehViewModel(repository: _MemoryTasbeehRepository());
      await model.load();
      model.increment();
      final id = model.addPhrase(name: 'Astaghfirullah', target: 2)!;
      model.increment();
      model.increment();
      expect(model.currentCompletedRounds, 1);
      expect(model.completedRounds, 1);
      expect(
        model.editPhrase(
          id: id,
          name: 'Istighfar',
          arabic: 'أَسْتَغْفِرُ الله',
          target: 7,
        ),
        isTrue,
      );
      expect(model.count, 2);
      expect(model.target, 7);
      expect(model.selectedPhrase.name, 'Istighfar');
      expect(model.deletePhrase(id), isTrue);
      expect(model.selectedPhraseId, 'subhanAllah');
      expect(model.count, 1);
      expect(model.counts.containsKey(id), isFalse);
      expect(model.selectedTargets.containsKey(id), isFalse);
    },
  );

  test(
    'invalid targets and unknown selections do not corrupt the session',
    () async {
      final model = TasbeehViewModel(repository: _MemoryTasbeehRepository());
      await model.load();
      model.selectTarget(0);
      model.selectTarget(-1);
      model.selectTarget(1000000);
      model.selectPhrase('missing');
      expect(model.target, 33);
      expect(model.selectedPhraseId, 'subhanAllah');
      expect(model.addPhrase(name: '   '), isNull);
      expect(model.addPhrase(name: 'Invalid target', target: 0), isNull);
      expect(model.phrases, hasLength(4));
    },
  );
}

class _MemoryTasbeehRepository implements TasbeehRepository {
  TasbeehSavedState? state;

  @override
  Future<TasbeehSavedState?> loadState() async => state;

  @override
  Future<void> saveState(TasbeehSavedState state) async {
    this.state = state;
  }
}
