class HadithBook {
  final String title;
  final HadithIntro introduction;
  final List<Hadith> hadiths;

  const HadithBook({
    required this.title,
    required this.introduction,
    required this.hadiths,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) => HadithBook(
    title: json['title'] as String,
    introduction: HadithIntro.fromJson(
      json['introduction'] as Map<String, dynamic>,
    ),
    hadiths: (json['hadiths'] as List)
        .map((e) => Hadith.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class HadithIntro {
  final String english;
  final String bangla;
  const HadithIntro({required this.english, required this.bangla});
  factory HadithIntro.fromJson(Map<String, dynamic> json) => HadithIntro(
    english: json['english'] as String,
    bangla: json['bangla'] as String,
  );
}

class Hadith {
  final int id;
  final String arabic;
  final String bangla;
  final String english;
  const Hadith({
    required this.id,
    required this.arabic,
    required this.bangla,
    required this.english,
  });
  factory Hadith.fromJson(Map<String, dynamic> json) => Hadith(
    id: json['id'] as int,
    arabic: json['arabic'] as String,
    bangla: json['bangla'] as String,
    english: json['english'] as String,
  );
}
