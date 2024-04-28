import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';

abstract class ListCurrencyLocalDataSource {
  Future<bool> initDb();
  Future<List<CurrencyModel>> getAllCurrencies(Box<Currency> box);
  Future<Unit> addCurrencyList(
      Box<Currency> box, List<CurrencyModel> currencyList);
  Future<Unit> addCurrencyHistory(
      Box<CurrencyHistory> box, CurrencyHistoryModel currencyHistoryModel);
  Future<List<CurrencyHistoryModel>> getAllCurrencyHistoryBeforeWeek(
    Box<CurrencyHistory> box,
    int beforeWeekTimestamp, {
    required String baseCurrency,
    required String currencies,
  });
}

class ListCurrencyLocalDataSourceImpl extends ListCurrencyLocalDataSource {
  @override
  Future<bool> initDb() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(CurrencyAdapter());
      Hive.registerAdapter(CurrencyHistoryAdapter());

      await Hive.openBox<Currency>(Constants.kCurrencyBox);
      await Hive.openBox<CurrencyHistory>(Constants.kCurrencyHistoryBox);
      return true;
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<Unit> addCurrencyList(
      Box<Currency> box, List<CurrencyModel> currencyList) async {
    try {
      await box.addAll(currencyList);
      return Future.value(unit);
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<List<CurrencyModel>> getAllCurrencies(Box<Currency> box) async {
    try {
      return box.values
          .map((e) =>
              CurrencyModel(code: e.code, name: e.name, symbol: e.symbol))
          .toList();
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<Unit> addCurrencyHistory(Box<CurrencyHistory> box,
      CurrencyHistoryModel currencyHistoryModel) async {
    try {
      await box.add(currencyHistoryModel);
      return Future.value(unit);
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<List<CurrencyHistoryModel>> getAllCurrencyHistoryBeforeWeek(
    Box<CurrencyHistory> box,
    int beforeWeekTimestamp, {
    required String baseCurrency,
    required String currencies,
  }) async {
    try {
      final list = box.values
          .where((element) =>
              (element.baseCurrency == baseCurrency &&
                  element.currencies == currencies) ||
              (element.currencies == baseCurrency &&
                  element.baseCurrency == currencies))
          .where((element) => element.savingTime > beforeWeekTimestamp)
          .map(
            (e) => CurrencyHistoryModel(
              baseCurrency: e.baseCurrency,
              currencies: e.currencies,
              amount: e.amount,
              exchangeRate: e.exchangeRate,
              savingTime: e.savingTime,
            ),
          )
          .toList();
      return list;
    } catch (_) {
      throw EmptyCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }
}
