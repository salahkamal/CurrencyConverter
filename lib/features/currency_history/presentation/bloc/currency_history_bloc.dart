import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/domain/usecases/get_all_currency_history_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'currency_history_event.dart';
part 'currency_history_state.dart';

class CurrencyHistoryBloc
    extends Bloc<CurrencyHistoryEvent, CurrencyHistoryState> {
  final GetAllCurrencyHistoryUsecase getAllCurrencyHistoryUsecase;
  CurrencyHistoryBloc({required this.getAllCurrencyHistoryUsecase})
      : super(CurrencyHistoryInitial()) {
    on<CurrencyHistoryEvent>((event, emit) async {
      if (event is Dropdown1SelectionChanged) {
        emit(Dropdown1ValueSelected(dropdown1Value: event.value));
      } else if (event is Dropdown2SelectionChanged) {
        emit(Dropdown2ValueSelected(dropdown2Value: event.value));
      } else if (event is GetExchangeRateHistory) {
        emit(CurrencyHistoryLoadingState());
        final failureOrCurrencyHistory = await getAllCurrencyHistoryUsecase(
            event.baseCurrency, event.currencies);
        emit(_mapFailureOrCurrencyToState(failureOrCurrencyHistory));
      }
    });
  }
}

CurrencyHistoryState _mapFailureOrCurrencyToState(
    Either<Failure, List<CurrencyHistory>> either) {
  return either.fold(
    (failure) => CurrencyHistoryErrorState(message: failure.message),
    (currencyHistory) => CurrencyHistoryLoadedState(
      currencyHistory: currencyHistory,
    ),
  );
}
