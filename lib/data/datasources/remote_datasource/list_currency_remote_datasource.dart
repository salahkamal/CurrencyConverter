import 'package:dio/dio.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/models/currency_model.dart';

abstract class ListCurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getAllCurrencies();
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
}
