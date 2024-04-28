import 'package:currency_converter/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:equatable/equatable.dart';

part 'currency_exchange_event.dart';
part 'currency_exchange_state.dart';

class CurrencyExchangeBloc
    extends Bloc<CurrencyExchangeEvent, CurrencyExchangeState> {
  final GetExchangeRateUsecase getExchangeRateUsecase;
  CurrencyExchangeBloc(this.getExchangeRateUsecase)
      : super(CurrencyExchangeInitial()) {
    on<CurrencyExchangeEvent>((event, emit) async {
      if (event is Dropdown1SelectionChanged) {
        emit(Dropdown1ValueSelected(dropdown1Value: event.value));
      } else if (event is Dropdown2SelectionChanged) {
        emit(Dropdown2ValueSelected(dropdown2Value: event.value));
      } else if (event is GetExchangeRate) {
        emit(LoadingCurrencyExchangeState());
        final failureOrGetRate = await getExchangeRateUsecase(
            event.baseCurrency, event.currencies, event.amount);
        failureOrGetRate.fold(
            (failure) =>
                emit(ErrorCurrencyExchangeState(message: failure.message)),
            (rate) => emit(ExchangeRateChanged(rate: rate.toStringAsFixed(2))));
      }
    });
  }
}
