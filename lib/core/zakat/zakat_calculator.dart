enum ZakatNisabBasis { silver, gold }

enum ZakatStatus { enterPrice, belowNisab, awaitingYear, due }

class ZakatCalculation {
  const ZakatCalculation({
    required this.assets,
    required this.liabilities,
    required this.pricePerGram,
    required this.basis,
    required this.lunarYearComplete,
  });

  /// Amounts are stored in the selected currency's smallest hundredth unit.
  final List<int> assets;
  final List<int> liabilities;
  final int pricePerGram;
  final ZakatNisabBasis basis;
  final bool lunarYearComplete;

  static const int silverGramsHundredths = 61236;
  static const int goldGramsHundredths = 8748;

  int get totalAssets => assets.fold(0, (sum, value) => sum + value);
  int get totalLiabilities => liabilities.fold(0, (sum, value) => sum + value);
  int get netAssets => (totalAssets - totalLiabilities).clamp(0, totalAssets);

  int? get nisab {
    if (pricePerGram <= 0) return null;
    final gramsHundredths = basis == ZakatNisabBasis.silver
        ? silverGramsHundredths
        : goldGramsHundredths;
    return (pricePerGram * gramsHundredths + 50) ~/ 100;
  }

  ZakatStatus get status {
    final threshold = nisab;
    if (threshold == null) return ZakatStatus.enterPrice;
    if (netAssets < threshold) return ZakatStatus.belowNisab;
    if (!lunarYearComplete) return ZakatStatus.awaitingYear;
    return ZakatStatus.due;
  }

  /// 2.5% of all net zakatable assets, rounded to the nearest hundredth.
  int get zakatDue => status == ZakatStatus.due ? (netAssets + 20) ~/ 40 : 0;

  static int parseAmount(String input) => tryParseAmount(input) ?? 0;

  static int? tryParseAmount(String input) {
    const bangla = '০১২৩৪৫৬৭৮৯';
    final normalized = input.trim().replaceAllMapped(
      RegExp('[$bangla٠١٢٣٤٥٦٧٨٩]'),
      (match) {
        final character = match.group(0)!;
        final banglaDigit = bangla.indexOf(character);
        if (banglaDigit >= 0) return '$banglaDigit';
        return '${'٠١٢٣٤٥٦٧٨٩'.indexOf(character)}';
      },
    );
    final clean = normalized.replaceAll(',', '').replaceAll(' ', '');
    if (clean.isEmpty) return 0;
    if (!RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(clean)) return null;
    final parts = clean.split('.');
    final whole = int.tryParse(parts.first);
    if (whole == null) return null;
    final fraction = parts.length == 2
        ? int.tryParse(parts.last.padRight(2, '0')) ?? 0
        : 0;
    return whole * 100 + fraction;
  }
}
