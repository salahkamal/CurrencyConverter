import 'package:dartz/dartz.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/data/datasources/local_datasource/currency_history_local_datasource.dart';
import 'package:currency_converter/data/datasources/remote_datasource/latest_exchange_rate_remote_datasource.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/domain/repositories/exchange_rate_repository.dart';

class ExchangeRateRepositoryImpl extends ExchangeRateRepository {
  final LatestExchangeRemoteDataSource remoteDataSource;
  final CurrencyHistoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ExchangeRateRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, double>> getExchangeRate(
      String baseCurrency, String currencies, double amount) async {
    try {
      if (await networkInfo.isConnected) {
        double exchangeRate = await remoteDataSource.getLatestExchangeRate(
            baseCurrency, currencies);
        localDataSource.addCurrencyHistory(CurrencyHistoryModel(
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
