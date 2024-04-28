part of 'currency_exchange_bloc.dart';

abstract class CurrencyExchangeEvent extends Equatable {
  const CurrencyExchangeEvent();
}

class Dropdown1SelectionChanged extends CurrencyExchangeEvent {
  final Currency value;

  const Dropdown1SelectionChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class Dropdown2SelectionChanged extends CurrencyExchangeEvent {
  final Currency value;

  const Dropdown2SelectionChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class GetExchangeRate extends CurrencyExchangeEvent {
  final double amount;
  final String baseCurrency;
  final String currencies;

  const GetExchangeRate(this.amount, this.baseCurrency, this.currencies);

  @override
  List<Object?> get props => [amount, baseCurrency, currencies];
}
