// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'currency_exchange_bloc.dart';

abstract class CurrencyExchangeState extends Equatable {
  const CurrencyExchangeState();

  @override
  List<Object> get props => [];
}

class CurrencyExchangeInitial extends CurrencyExchangeState {}

class LoadingCurrencyExchangeState extends CurrencyExchangeState {}

class Dropdown1ValueSelected extends CurrencyExchangeState {
  final Currency dropdown1Value;

  const Dropdown1ValueSelected({required this.dropdown1Value});

  @override
  List<Object> get props => [dropdown1Value];
}

class Dropdown2ValueSelected extends CurrencyExchangeState {
  final Currency dropdown2Value;

  const Dropdown2ValueSelected({required this.dropdown2Value});

  @override
  List<Object> get props => [dropdown2Value];
}

class ExchangeRateChanged extends CurrencyExchangeState {
  final String rate;

  const ExchangeRateChanged({required this.rate});

  @override
  List<Object> get props => [rate];
}

class ErrorCurrencyExchangeState extends CurrencyExchangeState {
  final String message;

  const ErrorCurrencyExchangeState({required this.message});

  @override
  List<Object> get props => [message];
}
