class SurahModel {
  const SurahModel({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslated,
    required this.revelationType,
    required this.totalAyahs,
  });

  final int id;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslated;
  final String revelationType;
  final int totalAyahs;

  factory SurahModel.fromApi(Map<String, dynamic> json) {
    final ayahs = json['ayahs'];
    final ayahsCount = ayahs is List ? ayahs.length : 0;

    return SurahModel(
      id: _toInt(json['number']),
      nameArabic: (json['name'] as String?) ?? '',
      nameEnglish: (json['englishName'] as String?) ?? '',
      nameTranslated: (json['englishNameTranslation'] as String?) ?? '',
      revelationType: (json['revelationType'] as String?) ?? '',
      totalAyahs: _toInt(json['numberOfAyahs']) > 0
          ? _toInt(json['numberOfAyahs'])
          : ayahsCount,
    );
  }

  factory SurahModel.fromMap(Map<String, Object?> map) {
    return SurahModel(
      id: _toInt(map['id']),
      nameArabic: (map['name_arabic'] as String?) ?? '',
      nameEnglish: (map['name_english'] as String?) ?? '',
      nameTranslated: (map['name_translated'] as String?) ?? '',
      revelationType: (map['revelation_type'] as String?) ?? '',
      totalAyahs: _toInt(map['total_ayahs']),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name_arabic': nameArabic,
      'name_english': nameEnglish,
      'name_translated': nameTranslated,
      'revelation_type': revelationType,
      'total_ayahs': totalAyahs,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
