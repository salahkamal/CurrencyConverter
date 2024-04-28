import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/datasources/list_currency_local_datasource.dart';
import 'package:currency_converter/data/models/currency_history_model.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late ListCurrencyLocalDataSourceImpl dataSource;
  late MockHiveInterface mockHive;
  setUp(() {
    mockHive = MockHiveInterface();
    dataSource = ListCurrencyLocalDataSourceImpl();
  });

  group('addCurrencyList', () {
    test('adds currency list to the database successfully', () async {
      final mockBox = MockBox<Currency>();
      when(() => mockHive.openBox<Currency>(any()))
          .thenAnswer((_) async => mockBox);
      when(() => mockBox.addAll([
            const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
          ])).thenAnswer((_) async => [1]);

      final currencyList = [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
      ];
      expect(await dataSource.addCurrencyList(mockBox, currencyList),
          equals(unit));
    });

    test('throws InternalCacheException when adding currency list fails',
        () async {
      final mockBox = MockBox<Currency>();
      when(() => mockHive.openBox<Currency>(any())).thenThrow(Exception());

      final currencyList = [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
      ];

      expect(() => dataSource.addCurrencyList(mockBox, currencyList),
          throwsA(isA<InternalCacheException>()));
    });
  });

  group('getAllCurrencies', () {
    test('returns list of CurrencyModel from database', () async {
      final mockBox = MockBox<Currency>();
      when(() => mockBox.values).thenReturn([
        const Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
        const Currency(code: 'EUR', name: 'Euro', symbol: '€'),
      ]);

      when(() => mockHive.openBox<Currency>(any()))
          .thenAnswer((_) async => mockBox);

      final result = await dataSource.getAllCurrencies(mockBox);

      expect(result, [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$'),
        const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€'),
      ]);
    });

    test('throws InternalCacheException when fetching currencies fails',
        () async {
      final mockBox = MockBox<Currency>();
      when(() => mockHive.openBox<Currency>(any())).thenThrow(Exception());

      expect(() => dataSource.getAllCurrencies(mockBox),
          throwsA(isA<InternalCacheException>()));
    });
  });

  group('addCurrencyHistory', () {
    test('adds currency history to the database successfully', () async {
      final mockBox = MockBox<CurrencyHistory>();

      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenAnswer((_) async => mockBox);

      final currencyHistoryModel = CurrencyHistoryModel(
        baseCurrency: 'USD',
        currencies: 'EUR',
        amount: 100,
        exchangeRate: 0.85,
        savingTime: DateTime.now().millisecondsSinceEpoch,
      );
      when(() => mockBox.add(currencyHistoryModel)).thenAnswer((_) async => 1);

      final result =
          await dataSource.addCurrencyHistory(mockBox, currencyHistoryModel);

      expect(result, unit);
    });

    test('throws InternalCacheException when adding currency history fails',
        () async {
      final mockBox = MockBox<CurrencyHistory>();
      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenThrow(Exception());

      final currencyHistoryModel = CurrencyHistoryModel(
        baseCurrency: 'USD',
        currencies: 'EUR',
        amount: 100,
        exchangeRate: 0.85,
        savingTime: DateTime.now().millisecondsSinceEpoch,
      );

      expect(() => dataSource.addCurrencyHistory(mockBox, currencyHistoryModel),
          throwsA(isA<InternalCacheException>()));
    });
  });

  group('getAllCurrencyHistoryBeforeWeek', () {
    test('returns list of CurrencyHistoryModel before a week', () async {
      final mockBox = MockBox<CurrencyHistory>();
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
      when(() => mockBox.values).thenReturn(currencyHistories);

      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenAnswer((_) async => mockBox);

      final beforeWeekTimestamp = DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;

      final result = await dataSource.getAllCurrencyHistoryBeforeWeek(
        mockBox,
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
      final mockBox = MockBox<CurrencyHistory>();
      when(() => mockHive.openBox<CurrencyHistory>(any()))
          .thenThrow(Exception());

      final beforeWeekTimestamp = DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch;

      expect(
        () => dataSource.getAllCurrencyHistoryBeforeWeek(
          mockBox,
          beforeWeekTimestamp,
          baseCurrency: 'USD',
          currencies: 'EUR',
        ),
        throwsA(isA<EmptyCacheException>()),
      );
    });
  });
}
