import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:dartz/dartz.dart';

abstract class ListCurrencyRepository {
  Future<Either<Failure, List<Currency>>> getAllCurrencies();
}
