import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCurrencyHistoryUsecase {
  final ListCurrencyRepository repository;

  GetAllCurrencyHistoryUsecase({required this.repository});

  Future<Either<Failure, List<CurrencyHistory>>> call(
      String baseCurrency, String currencies) async {
    return await repository.getAllExchangeRateHistoryBeforeWeek(
        baseCurrency: baseCurrency, currencies: currencies);
  }
}
