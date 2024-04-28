import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:currency_converter/features/currency_exchange/presentation/bloc/currency_exchange_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExchangeRateUsecase extends Mock
    implements GetExchangeRateUsecase {}

void main() {
  late MockGetExchangeRateUsecase mockGetExchangeRateUsecase;

  setUp(() {
    mockGetExchangeRateUsecase = MockGetExchangeRateUsecase();
  });

  group('CurrencyExchangeBloc', () {
    blocTest<CurrencyExchangeBloc, CurrencyExchangeState>(
      'emits Dropdown1ValueSelected when Dropdown1SelectionChanged event is added',
      build: () => CurrencyExchangeBloc(mockGetExchangeRateUsecase),
      act: (bloc) => bloc.add(const Dropdown1SelectionChanged(
          Currency(code: 'EUR', name: 'Euro', symbol: ''))),
      expect: () => [
        const Dropdown1ValueSelected(
            dropdown1Value: Currency(code: 'EUR', name: 'Euro', symbol: ''))
      ],
    );

    blocTest<CurrencyExchangeBloc, CurrencyExchangeState>(
      'emits Dropdown2ValueSelected when Dropdown2SelectionChanged event is added',
      build: () => CurrencyExchangeBloc(mockGetExchangeRateUsecase),
      act: (bloc) => bloc.add(const Dropdown2SelectionChanged(
          Currency(code: 'USD', name: 'Dollar', symbol: ''))),
      expect: () => [
        const Dropdown2ValueSelected(
            dropdown2Value: Currency(code: 'USD', name: 'Dollar', symbol: ''))
      ],
    );

    blocTest<CurrencyExchangeBloc, CurrencyExchangeState>(
      'emits LoadingCurrencyExchangeState and ExchangeRateChanged when GetExchangeRate event succeeds',
      build: () {
        when(() => mockGetExchangeRateUsecase(any(), any(), any()))
            .thenAnswer((_) async => const Right(1.23));
        return CurrencyExchangeBloc(mockGetExchangeRateUsecase);
      },
      act: (bloc) => bloc.add(const GetExchangeRate(100, 'EUR', 'USD')),
      expect: () => [
        LoadingCurrencyExchangeState(),
        const ExchangeRateChanged(rate: '1.23'),
      ],
    );

    blocTest<CurrencyExchangeBloc, CurrencyExchangeState>(
      'emits LoadingCurrencyExchangeState and ErrorCurrencyExchangeState when GetExchangeRate event fails',
      build: () {
        when(() => mockGetExchangeRateUsecase(any(), any(), any())).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to fetch rate')));
        return CurrencyExchangeBloc(mockGetExchangeRateUsecase);
      },
      act: (bloc) => bloc.add(
        const GetExchangeRate(100, 'EUR', 'USD'),
      ),
      expect: () => [
        LoadingCurrencyExchangeState(),
        const ErrorCurrencyExchangeState(message: 'Failed to fetch rate'),
      ],
    );
  });
}
