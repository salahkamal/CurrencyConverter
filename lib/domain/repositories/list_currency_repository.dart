import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:dartz/dartz.dart';

abstract class ListCurrencyRepository {
  Future<Either<Failure, List<Currency>>> getAllCurrencies();
  Future<Either<Failure, List<CurrencyHistory>>>
      getAllExchangeRateHistoryBeforeWeek({
    required String baseCurrency,
    required String currencies,
  });
  Future<Either<Failure, double>> getExchangeRate(
      String baseCurrency, String currencies, double amount);
}
