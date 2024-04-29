import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/datasources/local_datasource/currency_history_local_datasource.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late CurrencyHistoryLocalDataSource dataSource;
  late MockHiveInterface mockHive;
  late MockBox<CurrencyHistory> mockCurrencyHistoryBox;
  setUp(() {
    mockCurrencyHistoryBox = MockBox<CurrencyHistory>();
    mockHive = MockHiveInterface();
    dataSource = CurrencyHistoryLocalDataSourceImpl(
        currencyHistoryBox: mockCurrencyHistoryBox);
  });

  group('addCurrencyHistory', () {
    test('adds currency history to the database successfully', () async {
      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenAnswer((_) async => mockCurrencyHistoryBox);

      final currencyHistoryModel = CurrencyHistoryModel(
        baseCurrency: 'USD',
        currencies: 'EUR',
        amount: 100,
        exchangeRate: 0.85,
        savingTime: DateTime.now().millisecondsSinceEpoch,
      );
      when(() => mockCurrencyHistoryBox.add(currencyHistoryModel))
          .thenAnswer((_) async => 1);

      final result = await dataSource.addCurrencyHistory(currencyHistoryModel);

      expect(result, unit);
    });

    test('throws InternalCacheException when adding currency history fails',
        () async {
      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenThrow(Exception());

      final currencyHistoryModel = CurrencyHistoryModel(
        baseCurrency: 'USD',
        currencies: 'EUR',
        amount: 100,
        exchangeRate: 0.85,
        savingTime: DateTime.now().millisecondsSinceEpoch,
      );

      expect(() => dataSource.addCurrencyHistory(currencyHistoryModel),
          throwsA(isA<InternalCacheException>()));
    });
  });

  group('getAllCurrencyHistoryBeforeWeek', () {
    test('returns list of CurrencyHistoryModel before a week', () async {
      final currencyHistories = [
        CurrencyHistory(
          baseCurrency: 'USD',
          currencies: 'EUR',
          amount: 100,
          exchangeRate: 0.85,
          savingTime: DateTime.now().millisecondsSinceEpoch,
        ),
        CurrencyHistory(
          baseCurrency: 'EUR',
          currencies: 'USD',
          amount: 85,
          exchangeRate: 1.18,
          savingTime: DateTime.now()
              .subtract(const Duration(days: 8))
              .millisecondsSinceEpoch,
        ),
      ];
      when(() => mockCurrencyHistoryBox.values).thenReturn(currencyHistories);

      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenAnswer((_) async => mockCurrencyHistoryBox);

      final beforeWeekTimestamp = DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;

      final result = await dataSource.getAllCurrencyHistoryBeforeWeek(
        beforeWeekTimestamp,
        baseCurrency: 'USD',
        currencies: 'EUR',
      );

      expect(result.length, 1);
      expect(result, [
        CurrencyHistoryModel(
          baseCurrency: 'USD',
          currencies: 'EUR',
          amount: 100,
          exchangeRate: 0.85,
          savingTime: currencyHistories.first.savingTime,
        ),
      ]);
    });

    test('throws EmptyCacheException when fetching currency history fails',
        () async {
      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenThrow(Exception());

      final beforeWeekTimestamp = DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;

      expect(
        () => dataSource.getAllCurrencyHistoryBeforeWeek(
          beforeWeekTimestamp,
          baseCurrency: 'USD',
          currencies: 'EUR',
        ),
        throwsA(isA<EmptyCacheException>()),
      );
    });
  });
}
