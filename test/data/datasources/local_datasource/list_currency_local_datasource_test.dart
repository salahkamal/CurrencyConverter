import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/datasources/local_datasource/list_currency_local_datasource.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late ListCurrencyLocalDataSourceImpl dataSource;
  late MockHiveInterface mockHive;
  late MockBox<Currency> mockCurrencyBox;
  setUp(() {
    mockCurrencyBox = MockBox<Currency>();
    mockHive = MockHiveInterface();
    dataSource = ListCurrencyLocalDataSourceImpl(currencyBox: mockCurrencyBox);
  });

  group('addCurrencyList', () {
    test('adds currency list to the database successfully', () async {
      when(() => mockHive.openBox<Currency>(any()))
          .thenAnswer((_) async => mockCurrencyBox);
      when(() => mockCurrencyBox.addAll([
            const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
          ])).thenAnswer((_) async => [1]);

      final currencyList = [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
      ];
      expect(await dataSource.addCurrencyList(currencyList), equals(unit));
    });

    test('throws InternalCacheException when adding currency list fails',
        () async {
      when(() => mockHive.openBox<Currency>(any())).thenThrow(Exception());

      final currencyList = [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$')
      ];

      expect(() => dataSource.addCurrencyList(currencyList),
          throwsA(isA<InternalCacheException>()));
    });
  });

  group('getAllCurrencies', () {
    test('returns list of CurrencyModel from database', () async {
      when(() => mockCurrencyBox.values).thenReturn([
        const Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
        const Currency(code: 'EUR', name: 'Euro', symbol: '€'),
      ]);

      when(() => mockHive.openBox<Currency>(any()))
          .thenAnswer((_) async => mockCurrencyBox);

      final result = await dataSource.getAllCurrencies();

      expect(result, [
        const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$'),
        const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€'),
      ]);
    });

    test('throws InternalCacheException when fetching currencies fails',
        () async {
      when(() => mockHive.openBox<Currency>(any())).thenThrow(Exception());

      expect(() => dataSource.getAllCurrencies(),
          throwsA(isA<InternalCacheException>()));
    });
  });
}
