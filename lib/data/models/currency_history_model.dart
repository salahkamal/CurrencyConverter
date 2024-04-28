import 'package:currency_converter/domain/entities/currency_history.dart';

class CurrencyHistoryModel extends CurrencyHistory {
  const CurrencyHistoryModel(
      {required super.baseCurrency,
      required super.currencies,
      required super.amount,
      required super.exchangeRate,
      required super.savingTime});
}
