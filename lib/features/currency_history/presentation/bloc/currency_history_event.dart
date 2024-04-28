part of 'currency_history_bloc.dart';

abstract class CurrencyHistoryEvent extends Equatable {
  const CurrencyHistoryEvent();
}

class GetExchangeRateHistory extends CurrencyHistoryEvent {
  final String baseCurrency;
  final String currencies;

  const GetExchangeRateHistory(this.baseCurrency, this.currencies);

  @override
  List<Object?> get props => [baseCurrency, currencies];
}

class Dropdown1SelectionChanged extends CurrencyHistoryEvent {
  final Currency value;

  const Dropdown1SelectionChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class Dropdown2SelectionChanged extends CurrencyHistoryEvent {
  final Currency value;

  const Dropdown2SelectionChanged(this.value);

  @override
  List<Object?> get props => [value];
}
