import 'ayah_model.dart';

/// An unnumbered opening, using Al-Fatiha 1:1's text and recitation.
/// This object belongs to the reader and is never stored as a Quran verse.
class SurahOpeningModel {
  const SurahOpeningModel({required this.source, required this.surahId});

  final AyahModel source;
  final int surahId;

  /// Zero identifies the opening in the audio queue only. The global ID and
  /// URL remain 1:1's, so playback also reuses its existing offline cache.
  AyahModel get playbackEntry => AyahModel(
    id: source.id,
    surahId: surahId,
    ayahNumber: 0,
    juzNumber: source.juzNumber,
    hizbQuarter: source.hizbQuarter,
    pageNumber: source.pageNumber,
    arabicText: source.arabicText,
    transliterationEn: source.transliterationEn,
    transliterationBn: source.transliterationBn,
    translationEn: source.translationEn,
    translationBn: source.translationBn,
    tafsirEn: '',
    tafsirBn: '',
    audioUrl: source.audioUrl,
  );
}
