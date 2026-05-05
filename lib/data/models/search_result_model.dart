import 'ayah_model.dart';
import 'surah_model.dart';

enum SearchResultType { surah, ayah }

class SearchResultModel {
  const SearchResultModel._({
    required this.type,
    required this.title,
    required this.subtitle,
    this.surah,
    this.ayah,
  });

  final SearchResultType type;
  final String title;
  final String subtitle;
  final SurahModel? surah;
  final AyahModel? ayah;

  factory SearchResultModel.fromSurah(SurahModel surah) {
    return SearchResultModel._(
      type: SearchResultType.surah,
      title: '${surah.id}. ${surah.nameEnglish}',
      subtitle: surah.nameArabic,
      surah: surah,
    );
  }

  factory SearchResultModel.fromAyah(AyahModel ayah) {
    return SearchResultModel._(
      type: SearchResultType.ayah,
      title: 'Surah ${ayah.surahId}:${ayah.ayahNumber}',
      subtitle: _truncate(ayah.translationEn),
      ayah: ayah,
    );
  }

  static String _truncate(String text) {
    const maxLength = 110;
    final compact = text.replaceAll(RegExp(r'\\s+'), ' ').trim();

    if (compact.length <= maxLength) {
      return compact;
    }

    return '${compact.substring(0, maxLength)}...';
  }
}
