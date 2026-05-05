class LastReadModel {
  const LastReadModel({
    required this.surahId,
    required this.ayahNumber,
    required this.updatedAt,
  });

  final int surahId;
  final int ayahNumber;
  final DateTime updatedAt;

  factory LastReadModel.fromMap(Map<String, Object?> map) {
    return LastReadModel(
      surahId: _toInt(map['surah_id']),
      ayahNumber: _toInt(map['ayah_number']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(_toInt(map['updated_at'])),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': 1,
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'updated_at': updatedAt.millisecondsSinceEpoch,
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
