import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/usecases/get_all_currencies_usecase.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCurrenciesUsecase extends Mock
    implements GetAllCurrenciesUsecase {}

void main() {
  late MockGetAllCurrenciesUsecase mockGetAllCurrenciesUsecase;

  setUp(() {
    mockGetAllCurrenciesUsecase = MockGetAllCurrenciesUsecase();
  });

  group('ListCurrenciesBloc', () {
    blocTest<ListCurrenciesBloc, ListCurrenciesState>(
      'emits LoadingListCurrenciesState and LoadedListCurrenciesState when GetAllCurrenciesEvent is added',
      build: () {
        when(() => mockGetAllCurrenciesUsecase())
            .thenAnswer((_) async => const Right([]));
        return ListCurrenciesBloc(
            getAllCurrenciesUsecase: mockGetAllCurrenciesUsecase);
      },
      act: (bloc) => bloc.add(GetAllCurrenciesEvent()),
      expect: () => [
        LoadingListCurrenciesState(),
        const LoadedListCurrenciesState(currencies: []),
      ],
      verify: (_) {
        verify(() => mockGetAllCurrenciesUsecase()).called(1);
      },
    );

    blocTest<ListCurrenciesBloc, ListCurrenciesState>(
      'emits LoadingListCurrenciesState and ErrorListCurrenciesState when GetAllCurrenciesEvent fails',
      build: () {
        when(() => mockGetAllCurrenciesUsecase()).thenAnswer((_) async =>
            const Left(ServerFailure('Failed to fetch currencies')));
        return ListCurrenciesBloc(
            getAllCurrenciesUsecase: mockGetAllCurrenciesUsecase);
      },
      act: (bloc) => bloc.add(GetAllCurrenciesEvent()),
      expect: () => [
        LoadingListCurrenciesState(),
        const ErrorListCurrenciesState(message: 'Failed to fetch currencies'),
      ],
      verify: (_) {
        verify(() => mockGetAllCurrenciesUsecase()).called(1);
      },
    );
  });
}
