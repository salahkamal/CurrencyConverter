import 'package:dio/dio.dart';

abstract class NetworkService {
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});

  Future<Response> post(String url, dynamic data,
      {Map<String, dynamic>? headers});
}

class NetworkServiceImpl implements NetworkService {
  final Dio dio;

  NetworkServiceImpl({required this.dio});

  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) async {
    final response = await dio.get(url,
        queryParameters: queryParams,
        options: Options(headers: headers, responseType: ResponseType.json));
    return response;
  }

  @override
  Future<Response> post(String url, dynamic data,
      {Map<String, dynamic>? headers}) async {
    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }
}
