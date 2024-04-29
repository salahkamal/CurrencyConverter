import 'package:currency_converter/core/error/exceptions.dart';
import 'package:currency_converter/data/datasources/local_datasource/currency_history_local_datasource.dart';
import 'package:currency_converter/data/datasources/remote_datasource/latest_exchange_rate_remote_datasource.dart';
import 'package:currency_converter/data/repositories/exchange_rate_repository_impl.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/domain/repositories/exchange_rate_repository.dart';
import 'package:currency_converter/domain/usecases/get_all_currency_history_usecase.dart';
import 'package:currency_converter/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:currency_converter/features/currency_exchange/presentation/bloc/currency_exchange_bloc.dart';
import 'package:currency_converter/features/currency_history/presentation/bloc/currency_history_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:currency_converter/core/constants.dart';
import 'package:currency_converter/core/network/network_info.dart';
import 'package:currency_converter/core/network/network_service.dart';
import 'package:currency_converter/data/datasources/local_datasource/list_currency_local_datasource.dart';
import 'package:currency_converter/data/datasources/remote_datasource/list_currency_remote_datasource.dart';
import 'package:currency_converter/data/repositories/list_currency_repository_impl.dart';
import 'package:currency_converter/domain/repositories/list_currency_repository.dart';
import 'package:currency_converter/domain/usecases/get_all_currencies_usecase.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await initDb();

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
  sl.registerLazySingleton<ExchangeRateRepository>(
      () => ExchangeRateRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
            localDataSource: sl(),
          ));
  sl.registerLazySingleton<ListCurrencyRepository>(
      () => ListCurrencyRepositoryImpl(
            remoteDataSource: sl(),
            networkInfo: sl(),
            localDataSource: sl(),
          ));

  // Datasources

  sl.registerLazySingleton<LatestExchangeRemoteDataSource>(
      () => LatestExchangeRemoteDataSourceImpl(networkService: sl()));
  sl.registerLazySingleton<ListCurrencyLocalDataSource>(() =>
      ListCurrencyLocalDataSourceImpl(
          currencyBox: Hive.box<Currency>(Constants.kCurrencyBox)));
  sl.registerLazySingleton<ListCurrencyRemoteDataSource>(
      () => ListCurrencyRemoteDataSourceImpl(networkService: sl()));
  sl.registerLazySingleton<CurrencyHistoryLocalDataSource>(() =>
      CurrencyHistoryLocalDataSourceImpl(
          currencyHistoryBox:
              Hive.box<CurrencyHistory>(Constants.kCurrencyHistoryBox)));
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
}

Future<bool> initDb() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(CurrencyAdapter());
    Hive.registerAdapter(CurrencyHistoryAdapter());

    await Hive.openBox<Currency>(Constants.kCurrencyBox);
    await Hive.openBox<CurrencyHistory>(Constants.kCurrencyHistoryBox);
    return true;
  } catch (_) {
    throw InternalCacheException(Constants.kEmptyCacheFailureMessage);
  }
}
