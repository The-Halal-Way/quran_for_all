import '../dua/dua_text.dart';

class SunnahSourceCollection {
  SunnahSourceCollection(DuaJson json)
    : collection = DuaText(json['collection']),
      number = duaString(json['number']),
      url = duaString(json['url']);

  final DuaText collection;
  final String number, url;
}

class SunnahHadith {
  SunnahHadith(DuaJson json)
    : collection = DuaText(json['collection']),
      number = duaString(json['number']),
      url = duaString(json['url']),
      summary = DuaText(json['summary']),
      relation = duaString(json['relation']),
      gradingStatus = duaString(duaMap(json['grading'])['status']),
      grading = DuaText(duaMap(json['grading'])['label']),
      gradedBy = DuaText(duaMap(json['grading'])['by']),
      sourceCollections = List.unmodifiable(
        duaObjects(json['sourceCollections']).map(SunnahSourceCollection.new),
      );

  final DuaText collection, summary, grading, gradedBy;
  final String number, url, relation, gradingStatus;
  final List<SunnahSourceCollection> sourceCollections;
}

class SunnahQuranReference {
  SunnahQuranReference(DuaJson json)
    : surah = _positiveInt(json['surah']),
      ayah = _positiveInt(json['ayah']),
      endAyah = json['endAyah'] == null ? null : _positiveInt(json['endAyah']),
      repetitions = json['repetitions'] == null
          ? null
          : _positiveInt(json['repetitions']),
      url = duaString(json['url']),
      relation = duaString(json['relation']),
      featureId = duaString(json['featureId']) {
    if (surah > 114 || (endAyah != null && endAyah! < ayah)) {
      throw const FormatException('Invalid Sunnah Quran reference');
    }
  }

  final int surah, ayah;
  final int? endAyah, repetitions;
  final String url, relation, featureId;

  static int _positiveInt(Object? value) {
    if (value is! int || value < 1) {
      throw const FormatException('Expected a positive reference number');
    }
    return value;
  }
}
