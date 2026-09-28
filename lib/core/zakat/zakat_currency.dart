import 'package:intl/intl.dart';

enum ZakatCurrency {
  bdt('BDT', '৳'),
  usd('USD', '\$'),
  eur('EUR', '€'),
  gbp('GBP', '£'),
  sar('SAR', '﷼');

  const ZakatCurrency(this.code, this.symbol);

  final String code;
  final String symbol;

  String format(int hundredths, String locale) {
    final number = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: 2,
    ).format(hundredths / 100);
    return '$symbol $number';
  }
}
