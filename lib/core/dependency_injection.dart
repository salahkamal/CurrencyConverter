import 'package:currency_converter/domain/usecases/get_all_currency_history_usecase.dart';
import 'package:currency_converter/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:currency_converter/features/currency_exchange/presentation/bloc/currency_exchange_bloc.dart';
import 'package:currency_converter/features/currency_history/presentation/bloc/currency_history_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/datasources/list_currency_local_datasource.dart';
import 'package:currency_converter/data/datasources/list_currency_remote_datasource.dart';
import 'package:currency_converter/data/repositories/list_currency_repository_impl.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';
import 'package:currency_converter/domain/usecases/get_all_currencies_usecase.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  // Blocs
  sl.registerFactory(() => ListCurrenciesBloc(getAllCurrenciesUsecase: sl()));
  sl.registerFactory(() => CurrencyExchangeBloc(sl()));
  sl.registerFactory(
      () => CurrencyHistoryBloc(getAllCurrencyHistoryUsecase: sl()));

  //Usecases
  sl.registerLazySingleton(() => GetAllCurrenciesUsecase(sl()));
  sl.registerLazySingleton(() => GetExchangeRateUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetAllCurrencyHistoryUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ListCurrencyRepository>(
      () => ListCurrencyRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
            localDataSource: sl(),
          ));

  // Datasources

  sl.registerLazySingleton<ListCurrencyRemoteDataSource>(
      () => ListCurrencyRemoteDataSourceImpl(networkService: sl()));
  sl.registerLazySingleton<ListCurrencyLocalDataSource>(
      () => ListCurrencyLocalDataSourceImpl());

  // External
  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl(dio: sl()));
  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: Constants.kBaseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      )..interceptors.add(
          PrettyDioLogger(),
        ));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  await sl<ListCurrencyLocalDataSource>().initDb();
}
