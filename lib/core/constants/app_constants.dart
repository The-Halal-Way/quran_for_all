class AppConstants {
  const AppConstants._();

  static const String appName = 'Quran For All';

  static const String arabicEdition = 'quran-uthmani';
  static const String englishEdition = 'en.asad';
  static const String banglaEdition = 'bn.bengali';
  static const String transliterationEnEdition = 'en.transliteration';
  static const String transliterationBnEdition = 'bn.transliteration';
  // Use richer non-Arabic editions for tafsir view content.
  static const String tafsirEnEdition = 'en.hilali';
  static const String tafsirBnEdition = 'bn.hoque';

  static const String audioBaseUrl =
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy';

  static const int maxSearchResults = 80;
}
