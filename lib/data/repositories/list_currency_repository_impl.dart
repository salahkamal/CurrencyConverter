import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/data/datasources/list_currency_local_datasource.dart';
import 'package:currency_converter/data/datasources/list_currency_remote_datasource.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';

class ListCurrencyRepositoryImpl extends ListCurrencyRepository {
  final ListCurrencyRemoteDataSource remoteDataSource;
  final ListCurrencyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ListCurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, List<Currency>>> getAllCurrencies() async {
    List<Currency> currencyList;
    try {
      if (Hive.isBoxOpen(Constants.kCurrencyBox) &&
          Hive.box<Currency>(Constants.kCurrencyBox).values.isEmpty) {
        if (await networkInfo.isConnected) {
          currencyList = await remoteDataSource.getAllCurrencies();

          await localDataSource.addCurrencyList(
              Hive.box<Currency>(Constants.kCurrencyBox),
              currencyList
                  .map((e) => CurrencyModel(
                      code: e.code, name: e.name, symbol: e.symbol))
                  .toList());
        } else {
          return const Left(OfflineFailure(Constants.kOfflineFailureMessage));
        }
      } else {
        currencyList = await localDataSource
            .getAllCurrencies(Hive.box<Currency>(Constants.kCurrencyBox));
      }
      return Right(currencyList);
    } on Exception catch (e) {
      return Left(handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, double>> getExchangeRate(
      String baseCurrency, String currencies, double amount) async {
    try {
      if (await networkInfo.isConnected) {
        double exchangeRate = await remoteDataSource.getLatestExchangeRate(
            baseCurrency, currencies);
        localDataSource.addCurrencyHistory(
            Hive.box<CurrencyHistory>(Constants.kCurrencyHistoryBox),
            CurrencyHistoryModel(
              baseCurrency: baseCurrency,
              currencies: currencies,
              amount: amount,
              exchangeRate: exchangeRate,
              savingTime: DateTime.now().millisecondsSinceEpoch,
            ));
        return Right(exchangeRate * amount);
      } else {
        return const Left(OfflineFailure(Constants.kOfflineFailureMessage));
      }
    } on Exception catch (e) {
      return Left(handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CurrencyHistory>>>
      getAllExchangeRateHistoryBeforeWeek({
    required String baseCurrency,
    required String currencies,
  }) async {
    try {
      List<CurrencyHistory> currencyHistoryList =
          await localDataSource.getAllCurrencyHistoryBeforeWeek(
        Hive.box<CurrencyHistory>(Constants.kCurrencyHistoryBox),
        DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch,
        baseCurrency: baseCurrency,
        currencies: currencies,
      );

      return Right(currencyHistoryList);
    } on Exception catch (e) {
      return Left(handleFailure(e));
    }
  }
}
