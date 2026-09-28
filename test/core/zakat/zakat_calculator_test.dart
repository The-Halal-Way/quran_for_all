import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/zakat/zakat_calculator.dart';

void main() {
  test('uses the selected metal threshold and the full net amount', () {
    const silver = ZakatCalculation(
      assets: [100000, 50000],
      liabilities: [10000],
      pricePerGram: 100,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: true,
    );
    expect(silver.nisab, 61236);
    expect(silver.netAssets, 140000);
    expect(silver.status, ZakatStatus.due);
    expect(silver.zakatDue, 3500);

    const gold = ZakatCalculation(
      assets: [100000, 50000],
      liabilities: [10000],
      pricePerGram: 1000,
      basis: ZakatNisabBasis.gold,
      lunarYearComplete: true,
    );
    expect(gold.nisab, 87480);
    expect(gold.status, ZakatStatus.due);
  });

  test('does not show zakat due before both conditions are met', () {
    const noPrice = ZakatCalculation(
      assets: [100000],
      liabilities: [],
      pricePerGram: 0,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: true,
    );
    expect(noPrice.status, ZakatStatus.enterPrice);
    expect(noPrice.zakatDue, 0);

    const below = ZakatCalculation(
      assets: [60000],
      liabilities: [],
      pricePerGram: 100,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: true,
    );
    expect(below.status, ZakatStatus.belowNisab);
    expect(below.zakatDue, 0);

    const waiting = ZakatCalculation(
      assets: [100000],
      liabilities: [],
      pricePerGram: 100,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: false,
    );
    expect(waiting.status, ZakatStatus.awaitingYear);
    expect(waiting.zakatDue, 0);
  });

  test('caps liabilities at total assets and rounds hundredths', () {
    const overdrawn = ZakatCalculation(
      assets: [100],
      liabilities: [500],
      pricePerGram: 100,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: true,
    );
    expect(overdrawn.netAssets, 0);
    expect(overdrawn.zakatDue, 0);

    const rounded = ZakatCalculation(
      assets: [62020],
      liabilities: [],
      pricePerGram: 100,
      basis: ZakatNisabBasis.silver,
      lunarYearComplete: true,
    );
    expect(rounded.zakatDue, 1551);
  });

  test('parses English and Bangla decimal amounts without floating error', () {
    expect(ZakatCalculation.parseAmount('1,234.56'), 123456);
    expect(ZakatCalculation.parseAmount('১,২৩৪.৫৬'), 123456);
    expect(ZakatCalculation.parseAmount('١٢٣٤.٥٦'), 123456);
    expect(ZakatCalculation.tryParseAmount('12.345'), isNull);
    expect(ZakatCalculation.parseAmount(''), 0);
  });
}
