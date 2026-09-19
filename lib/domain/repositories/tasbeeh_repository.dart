import '../../data/models/tasbeeh_state.dart';

abstract class TasbeehRepository {
  Future<TasbeehSavedState?> loadState();

  Future<void> saveState(TasbeehSavedState state);
}
