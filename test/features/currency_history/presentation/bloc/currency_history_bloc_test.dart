import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/usecases/get_all_currency_history_usecase.dart';
import 'package:currency_converter/features/currency_history/presentation/bloc/currency_history_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCurrencyHistoryUsecase extends Mock
    implements GetAllCurrencyHistoryUsecase {}

void main() {
  late MockGetAllCurrencyHistoryUsecase mockGetAllCurrencyHistoryUsecase;

  setUp(() {
    mockGetAllCurrencyHistoryUsecase = MockGetAllCurrencyHistoryUsecase();
  });

  group('CurrencyHistoryBloc', () {
    blocTest<CurrencyHistoryBloc, CurrencyHistoryState>(
      'emits Dropdown1ValueSelected when Dropdown1SelectionChanged event is added',
      build: () => CurrencyHistoryBloc(
          getAllCurrencyHistoryUsecase: mockGetAllCurrencyHistoryUsecase),
      act: (bloc) => bloc.add(const Dropdown1SelectionChanged(
          Currency(code: 'EUR', name: 'EUR', symbol: 'EUR'))),
      expect: () => [
        const Dropdown1ValueSelected(
            dropdown1Value: Currency(code: 'EUR', name: 'EUR', symbol: 'EUR'))
      ],
    );

    blocTest<CurrencyHistoryBloc, CurrencyHistoryState>(
      'emits Dropdown2ValueSelected when Dropdown2SelectionChanged event is added',
      build: () => CurrencyHistoryBloc(
          getAllCurrencyHistoryUsecase: mockGetAllCurrencyHistoryUsecase),
      act: (bloc) => bloc.add(const Dropdown2SelectionChanged(
          Currency(code: 'USD', name: 'USD', symbol: 'USD'))),
      expect: () => [
        const Dropdown2ValueSelected(
            dropdown2Value: Currency(code: 'USD', name: 'USD', symbol: 'USD'))
      ],
    );

    blocTest<CurrencyHistoryBloc, CurrencyHistoryState>(
      'emits CurrencyHistoryLoadingState and CurrencyHistoryLoadedState when GetExchangeRateHistory event succeeds',
      build: () {
        when(() => mockGetAllCurrencyHistoryUsecase(any(), any()))
            .thenAnswer((_) async => const Right([]));
        return CurrencyHistoryBloc(
            getAllCurrencyHistoryUsecase: mockGetAllCurrencyHistoryUsecase);
      },
      act: (bloc) => bloc.add(const GetExchangeRateHistory('EUR', 'USD')),
      expect: () => [
        CurrencyHistoryLoadingState(),
        const CurrencyHistoryLoadedState(currencyHistory: []),
      ],
    );

    blocTest<CurrencyHistoryBloc, CurrencyHistoryState>(
      'emits CurrencyHistoryLoadingState and CurrencyHistoryErrorState when GetExchangeRateHistory event fails',
      build: () {
        when(() => mockGetAllCurrencyHistoryUsecase(any(), any())).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to fetch history')));
        return CurrencyHistoryBloc(
            getAllCurrencyHistoryUsecase: mockGetAllCurrencyHistoryUsecase);
      },
      act: (bloc) => bloc.add(const GetExchangeRateHistory('EUR', 'USD')),
      expect: () => [
        CurrencyHistoryLoadingState(),
        const CurrencyHistoryErrorState(message: 'Failed to fetch history'),
      ],
    );
  });
}
