import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/datasources/remote_datasource/latest_exchange_rate_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkService extends Mock implements NetworkService {}

void main() {
  late LatestExchangeRemoteDataSource dataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    dataSource =
        LatestExchangeRemoteDataSourceImpl(networkService: mockNetworkService);
  });

  group('getLatestExchangeRate', () {
    test('returns exchange rate when successful', () async {
      when(() => mockNetworkService.get(
            any(),
            queryParams: any(named: 'queryParams'),
            headers: any(named: "headers"),
          )).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: Constants.kLatestUrlPath),
            data: {
              "data": {"EUR": 0.85}
            },
          ),
        ),
      );

      final exchangeRate = await dataSource.getLatestExchangeRate('USD', 'EUR');

      expect(exchangeRate, 0.85);
    });

    test('throws an exception when request fails', () async {
      when(() => mockNetworkService.get(any(),
          queryParams: any(named: 'queryParams'))).thenThrow(
        DioException(
          response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: Constants.kLatestUrlPath),
              data: {
                "message": "Validation error",
              }),
          requestOptions: RequestOptions(path: Constants.kLatestUrlPath),
        ),
      );

      expect(() => dataSource.getLatestExchangeRate('USD', 'EUR'),
          throwsException);
      expect(() => dataSource.getLatestExchangeRate('USD', 'EUR'),
          throwsA(isA<ServerException>()));
    });
  });
}
