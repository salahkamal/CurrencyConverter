import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';

abstract class ListCurrencyLocalDataSource {
  Future<List<CurrencyModel>> getAllCurrencies();
  Future<Unit> addCurrencyList(List<CurrencyModel> currencyList);
}

class ListCurrencyLocalDataSourceImpl extends ListCurrencyLocalDataSource {
  final Box<Currency> currencyBox;

  ListCurrencyLocalDataSourceImpl({required this.currencyBox});

  @override
  Future<Unit> addCurrencyList(List<CurrencyModel> currencyList) async {
    try {
      await currencyBox.addAll(currencyList);
      return Future.value(unit);
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<List<CurrencyModel>> getAllCurrencies() async {
    try {
      return currencyBox.values
          .map((e) =>
              CurrencyModel(code: e.code, name: e.name, symbol: e.symbol))
          .toList();
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }
}
