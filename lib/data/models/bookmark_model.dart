enum BookmarkType { surah, ayah }

extension BookmarkTypeX on BookmarkType {
  String get dbValue {
    switch (this) {
      case BookmarkType.surah:
        return 'surah';
      case BookmarkType.ayah:
        return 'ayah';
    }
  }

  static BookmarkType fromDbValue(String value) {
    switch (value) {
      case 'ayah':
        return BookmarkType.ayah;
      case 'surah':
      default:
        return BookmarkType.surah;
    }
  }
}

class BookmarkModel {
  const BookmarkModel({
    required this.type,
    required this.surahId,
    required this.ayahNumber,
    required this.createdAt,
  });

  factory BookmarkModel.surah({required int surahId, DateTime? createdAt}) {
    return BookmarkModel(
      type: BookmarkType.surah,
      surahId: surahId,
      ayahNumber: null,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory BookmarkModel.ayah({
    required int surahId,
    required int ayahNumber,
    DateTime? createdAt,
  }) {
    return BookmarkModel(
      type: BookmarkType.ayah,
      surahId: surahId,
      ayahNumber: ayahNumber,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  final BookmarkType type;
  final int surahId;
  final int? ayahNumber;
  final DateTime createdAt;

  factory BookmarkModel.fromMap(Map<String, Object?> map) {
    final type = BookmarkTypeX.fromDbValue((map['type'] as String?) ?? 'surah');
    final rawAyahNumber = _toInt(map['ayah_number']);

    return BookmarkModel(
      type: type,
      surahId: _toInt(map['surah_id']),
      ayahNumber: type == BookmarkType.ayah ? rawAyahNumber : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(_toInt(map['created_at'])),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'type': type.dbValue,
      'surah_id': surahId,
      'ayah_number': type == BookmarkType.ayah ? (ayahNumber ?? 0) : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
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
