import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchangeRateUsecase {
  final ListCurrencyRepository repository;

  GetExchangeRateUsecase({required this.repository});

  Future<Either<Failure, double>> call(
      String baseCurrency, String currencies, double amount) async {
    return await repository.getExchangeRate(baseCurrency, currencies, amount);
  }
}
