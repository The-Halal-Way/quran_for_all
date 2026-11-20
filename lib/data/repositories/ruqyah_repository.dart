import '../datasources/local/ruqyah/ruqyah_asset_loader.dart';
import '../datasources/local/ruqyah/ruqyah_local_store.dart';

/// Feature-scoped: created only when a Ruqyah destination is opened.
class RuqyahRepository {
  RuqyahRepository({RuqyahAssetLoader? assets, RuqyahLocalStore? store})
    : assets = assets ?? RuqyahAssetLoader(),
      store = store ?? RuqyahLocalStore();
  final RuqyahAssetLoader assets;
  final RuqyahLocalStore store;
}
