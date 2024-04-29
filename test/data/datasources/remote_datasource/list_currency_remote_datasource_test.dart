import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/datasources/remote_datasource/list_currency_remote_datasource.dart';
import 'package:currency_converter/data/models/currency_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkService extends Mock implements NetworkService {}

void main() {
  late ListCurrencyRemoteDataSource dataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    dataSource =
        ListCurrencyRemoteDataSourceImpl(networkService: mockNetworkService);
  });

  group('getAllCurrencies', () {
    test('returns list of CurrencyModels when successful', () async {
      when(() => mockNetworkService.get(
            any(),
            queryParams: any(named: "queryParams"),
            headers: any(named: "headers"),
          )).thenAnswer(
        (_) => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: Constants.kCurrenciesUrlPath),
            data: {
              "data": {
                "EUR": const CurrencyModel(
                  code: 'EUR',
                  name: 'Euro',
                  symbol: '€',
                ).toJson(),
                "USD": const CurrencyModel(
                  symbol: "\$",
                  name: "US Dollar",
                  code: "USD",
                ).toJson()
              }
            },
          ),
        ),
      );

      final currencies = await dataSource.getAllCurrencies();
      verify(() => mockNetworkService.get(
            any(),
            headers: any(named: 'headers'),
            queryParams: any(named: "queryParams"),
          )).called(1);
      expect(currencies, isA<List<CurrencyModel>>());
      expect(currencies.length, 2);
      expect(currencies.first.code, 'EUR');
      expect(currencies[1].symbol, "\$");
    });

    test('throws an exception when request fails', () async {
      when(() => mockNetworkService.get(
            any(),
            queryParams: any(named: 'queryParams'),
            headers: any(named: "headers"),
          )).thenThrow(DioException(
          response: Response(
              data: {
                "message": "Validation error",
              },
              statusCode: 404,
              statusMessage: 'Error',
              requestOptions:
                  RequestOptions(path: Constants.kCurrenciesUrlPath)),
          requestOptions: RequestOptions(path: Constants.kCurrenciesUrlPath)));

      expect(() => dataSource.getAllCurrencies(), throwsException);
      expect(() => dataSource.getAllCurrencies(),
          throwsA(isA<NoEndpointException>()));
    });
  });
}
