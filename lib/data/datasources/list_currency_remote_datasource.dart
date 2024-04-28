import 'package:dio/dio.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/models/currency_model.dart';

abstract class ListCurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getAllCurrencies();
  Future<double> getLatestExchangeRate(String baseCurrency, String currencies);
}

class ListCurrencyRemoteDataSourceImpl extends ListCurrencyRemoteDataSource {
  final NetworkService networkService;

  ListCurrencyRemoteDataSourceImpl({required this.networkService});
  @override
  Future<List<CurrencyModel>> getAllCurrencies() async {
    try {
      final response = await networkService.get(
          '${Constants.kBaseUrl}${Constants.kCurrenciesUrlPath}',
          queryParams: {'apikey': Constants.kApiKey});

      if (response.statusCode == 200) {
        final List<CurrencyModel> list =
            (response.data['data'] as Map<String, dynamic>)
                .entries
                .map(
                  (e) => CurrencyModel.fromJson(e.value),
                )
                .toList();

        return list;
      } else {
        throw handleExceptions(response);
      }
    } on DioException catch (e) {
      throw handleExceptions(e.response!);
    }
  }

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
