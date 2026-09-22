import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../../../l10n/app_localizations.dart';
import 'sunnah_collection_content_bn.dart';
import 'sunnah_collection_content_en.dart';

List<SunnahDuaContent> sunnahCollectionContent(AppLocalizations l10n) {
  final language = l10n.localeName.toLowerCase().split(RegExp(r'[-_]')).first;
  return language == 'bn'
      ? sunnahCollectionContentBn
      : sunnahCollectionContentEn;
}
