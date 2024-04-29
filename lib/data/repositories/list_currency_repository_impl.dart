import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/data/datasources/local_datasource/list_currency_local_datasource.dart';
import 'package:currency_converter/data/datasources/remote_datasource/list_currency_remote_datasource.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';
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

          await localDataSource.addCurrencyList(currencyList
              .map((e) =>
                  CurrencyModel(code: e.code, name: e.name, symbol: e.symbol))
              .toList());
        } else {
          return const Left(OfflineFailure(Constants.kOfflineFailureMessage));
        }
      } else {
        currencyList = await localDataSource.getAllCurrencies();
      }
      return Right(currencyList);
    } on Exception catch (e) {
      return Left(handleFailure(e));
    }
  }
}
