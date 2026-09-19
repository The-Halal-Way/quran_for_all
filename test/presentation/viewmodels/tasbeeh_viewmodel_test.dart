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
    viewModel.selectPhrase(TasbeehPhraseKey.alhamdulillah);

    expect(viewModel.count, 0);
    expect(viewModel.target, 33);

    viewModel.selectTarget(99);
    viewModel.increment();
    viewModel.selectPhrase(TasbeehPhraseKey.subhanAllah);

    expect(viewModel.count, 2);
    expect(viewModel.target, 33);
    expect(viewModel.countFor(TasbeehPhraseKey.alhamdulillah), 1);
    expect(viewModel.targetFor(TasbeehPhraseKey.alhamdulillah), 99);
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

      viewModel.selectPhrase(TasbeehPhraseKey.allahuAkbar);
      viewModel.increment();
      viewModel.resetCount();
      expect(viewModel.count, 0);

      viewModel.selectPhrase(TasbeehPhraseKey.subhanAllah);
      expect(viewModel.count, 34);

      viewModel.resetAll();
      expect(viewModel.totalCount, 0);
    },
  );

  test('counts, targets and selected dhikr restore from storage', () async {
    final repository = _MemoryTasbeehRepository();
    final original = TasbeehViewModel(repository: repository);
    await original.load();

    original.selectPhrase(TasbeehPhraseKey.laIlahaIllallah);
    original.selectTarget(100);
    original.increment();
    original.increment();
    await Future<void>.delayed(Duration.zero);

    final restored = TasbeehViewModel(repository: repository);
    await restored.load();

    expect(restored.selectedPhraseKey, TasbeehPhraseKey.laIlahaIllallah);
    expect(restored.count, 2);
    expect(restored.target, 100);
  });
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
