import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/repositories/exchange_rate_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchangeRateUsecase {
  final ExchangeRateRepository repository;

  GetExchangeRateUsecase({required this.repository});

  Future<Either<Failure, double>> call(
      String baseCurrency, String currencies, double amount) async {
    return await repository.getExchangeRate(baseCurrency, currencies, amount);
  }
}
