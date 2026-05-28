class ShortHadithBook {
  final String titleEnglish;
  final String titleBangla;
  final String compiledByEnglish;
  final String compiledByBangla;
  final List<ShortHadith> hadiths;

  const ShortHadithBook({
    required this.titleEnglish,
    required this.titleBangla,
    required this.compiledByEnglish,
    required this.compiledByBangla,
    required this.hadiths,
  });

  factory ShortHadithBook.fromJson(Map<String, dynamic> json) =>
      ShortHadithBook(
        titleEnglish: json['title_english'] as String,
        titleBangla: json['title_bangla'] as String,
        compiledByEnglish: json['compiled_by_english'] as String,
        compiledByBangla: json['compiled_by_bangla'] as String,
        hadiths: (json['hadiths'] as List)
            .map((e) => ShortHadith.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class ShortHadith {
  final int id;
  final String title;
  final String arabic;
  final String english;
  final String bangla;

  const ShortHadith({
    required this.id,
    required this.title,
    required this.arabic,
    required this.english,
    required this.bangla,
  });

  factory ShortHadith.fromJson(Map<String, dynamic> json) => ShortHadith(
    id: json['id'] as int,
    title: json['title'] as String,
    arabic: json['arabic'] as String,
    english: json['english'] as String,
    bangla: json['bangla'] as String,
  );

  String headlineOf(bool isBangla) {
    final text = isBangla ? bangla : english;
    return text.split('\n').first.trim();
  }

  List<String> bulletsOf(bool isBangla) {
    final text = isBangla ? bangla : english;
    final lines = text.split('\n');
    return lines
        .skip(1)
        .where((l) => l.trim().isNotEmpty)
        .map((l) => l.trim())
        .toList();
  }
}
