class DbConstants {
  const DbConstants._();

  static const String databaseName = 'quran_for_all.db';
  static const int databaseVersion = 1;

  static const String tableSurahs = 'surahs';
  static const String tableAyahs = 'ayahs';
  static const String tableAyahFts = 'ayah_fts';
  static const String tableLastRead = 'last_read';
}
