import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCurrenciesUsecase {
  final ListCurrencyRepository repository;

  GetAllCurrenciesUsecase(this.repository);

  Future<Either<Failure, List<Currency>>> call() async {
    return await repository.getAllCurrencies();
  }
}
