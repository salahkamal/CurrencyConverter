import 'package:dio/dio.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/network_service.dart';

abstract class LatestExchangeRemoteDataSource {
  Future<double> getLatestExchangeRate(String baseCurrency, String currencies);
}

class LatestExchangeRemoteDataSourceImpl
    extends LatestExchangeRemoteDataSource {
  final NetworkService networkService;

  LatestExchangeRemoteDataSourceImpl({required this.networkService});

  @override
  Future<double> getLatestExchangeRate(
      String baseCurrency, String currencies) async {
    try {
      final response = await networkService.get(
          '${Constants.kBaseUrl}${Constants.kLatestUrlPath}',
          queryParams: {
            'apikey': Constants.kApiKey,
            'base_currency': baseCurrency,
            'currencies': currencies,
          });

      if (response.statusCode == 200) {
        final double exchangeRate =
            (response.data['data'] as Map<String, dynamic>).values.first * 1.0;

        return exchangeRate;
      } else {
        throw handleExceptions(response);
      }
    } on DioException catch (e) {
      throw handleExceptions(e.response!);
    }
  }
}
