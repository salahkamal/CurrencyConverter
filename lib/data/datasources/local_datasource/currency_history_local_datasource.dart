import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';

abstract class CurrencyHistoryLocalDataSource {
  Future<Unit> addCurrencyHistory(CurrencyHistoryModel currencyHistoryModel);
  Future<List<CurrencyHistoryModel>> getAllCurrencyHistoryBeforeWeek(
    int beforeWeekTimestamp, {
    required String baseCurrency,
    required String currencies,
  });
}

class CurrencyHistoryLocalDataSourceImpl
    extends CurrencyHistoryLocalDataSource {
  final Box<CurrencyHistory> currencyHistoryBox;

  CurrencyHistoryLocalDataSourceImpl({required this.currencyHistoryBox});

  @override
  Future<Unit> addCurrencyHistory(
      CurrencyHistoryModel currencyHistoryModel) async {
    try {
      await currencyHistoryBox.add(currencyHistoryModel);
      return Future.value(unit);
    } catch (_) {
      throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
    }
  }

  @override
  Future<List<CurrencyHistoryModel>> getAllCurrencyHistoryBeforeWeek(
    int beforeWeekTimestamp, {
    required String baseCurrency,
    required String currencies,
  }) async {
    try {
      final list = currencyHistoryBox.values
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
