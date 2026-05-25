import 'dart:convert';

NintyNineNames nintyNineNamesFromJson(String str) =>
    NintyNineNames.fromJson(json.decode(str));

String nintyNineNamesToJson(NintyNineNames data) => json.encode(data.toJson());

class NintyNineNames {
  Metadata metadata;
  List<Name> names;

  NintyNineNames({required this.metadata, required this.names});

  factory NintyNineNames.fromJson(Map<String, dynamic> json) => NintyNineNames(
    metadata: Metadata.fromJson(json["metadata"]),
    names: List<Name>.from(json["names"].map((x) => Name.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "metadata": metadata.toJson(),
    "names": List<dynamic>.from(names.map((x) => x.toJson())),
  };
}

class Metadata {
  String banglaTitle;
  String title;
  int totalNames;
  QuranVerse quranVerse;
  String benefit;
  String banglaBenefit;
  String conclusion;
  String banglaConclusion;

  Metadata({
    required this.banglaTitle,
    required this.title,
    required this.totalNames,
    required this.quranVerse,
    required this.benefit,
    required this.banglaBenefit,
    required this.conclusion,
    required this.banglaConclusion,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    banglaTitle: json["bangla_title"],
    title: json["title"],
    totalNames: json["total_names"],
    quranVerse: QuranVerse.fromJson(json["quran_verse"]),
    benefit: json["benefit"],
    banglaBenefit: json["bangla_benefit"],
    conclusion: json["conclusion"],
    banglaConclusion: json["bangla_conclusion"],
  );

  Map<String, dynamic> toJson() => {
    "bangla_title": banglaTitle,
    "title": title,
    "total_names": totalNames,
    "quran_verse": quranVerse.toJson(),
    "benefit": benefit,
    "bangla_benefit": banglaBenefit,
    "conclusion": conclusion,
    "bangla_conclusion": banglaConclusion,
  };
}

class QuranVerse {
  String surah;
  String banglaSurah;
  int verse;
  String text;
  String banglaText;

  QuranVerse({
    required this.surah,
    required this.banglaSurah,
    required this.verse,
    required this.text,
    required this.banglaText,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) => QuranVerse(
    surah: json["surah"],
    banglaSurah: json["bangla_surah"],
    verse: json["verse"],
    text: json["text"],
    banglaText: json["bangla_text"],
  );

  Map<String, dynamic> toJson() => {
    "surah": surah,
    "bangla_surah": banglaSurah,
    "verse": verse,
    "text": text,
    "bangla_text": banglaText,
  };
}

class Name {
  int id;
  String arabic;
  String transliteration;
  String transliterationSimple;
  String meaningEnglish;
  String banglaTransliteration;
  String banglaMeaning;
  String category;
  String audioUrl;

  Name({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.transliterationSimple,
    required this.meaningEnglish,
    required this.banglaTransliteration,
    required this.banglaMeaning,
    required this.category,
    required this.audioUrl,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    id: json["id"],
    arabic: json["arabic"],
    transliteration: json["transliteration"],
    transliterationSimple: json["transliteration_simple"],
    meaningEnglish: json["meaning_english"],
    banglaTransliteration: json["bangla_transliteration"],
    banglaMeaning: json["bangla_meaning"],
    category: json["category"],
    audioUrl: json["audio_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "arabic": arabic,
    "transliteration": transliteration,
    "transliteration_simple": transliterationSimple,
    "meaning_english": meaningEnglish,
    "bangla_transliteration": banglaTransliteration,
    "bangla_meaning": banglaMeaning,
    "category": category,
    "audio_url": audioUrl,
  };
}
