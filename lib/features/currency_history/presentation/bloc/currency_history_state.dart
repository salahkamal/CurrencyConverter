part of 'currency_history_bloc.dart';

abstract class CurrencyHistoryState extends Equatable {
  const CurrencyHistoryState();
}

class CurrencyHistoryInitial extends CurrencyHistoryState {
  @override
  List<Object?> get props => [];
}

class CurrencyHistoryLoadingState extends CurrencyHistoryState {
  @override
  List<Object?> get props => [];
}

class CurrencyHistoryLoadedState extends CurrencyHistoryState {
  final List<CurrencyHistory> currencyHistory;

  const CurrencyHistoryLoadedState({required this.currencyHistory});
  @override
  List<Object?> get props => [currencyHistory];
}

class CurrencyHistoryErrorState extends CurrencyHistoryState {
  final String message;

  const CurrencyHistoryErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class Dropdown1ValueSelected extends CurrencyHistoryState {
  final Currency dropdown1Value;

  const Dropdown1ValueSelected({required this.dropdown1Value});

  @override
  List<Object> get props => [dropdown1Value];
}

class Dropdown2ValueSelected extends CurrencyHistoryState {
  final Currency dropdown2Value;

  const Dropdown2ValueSelected({required this.dropdown2Value});

  @override
  List<Object> get props => [dropdown2Value];
}
