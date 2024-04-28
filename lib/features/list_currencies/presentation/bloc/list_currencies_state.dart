part of 'list_currencies_bloc.dart';

abstract class ListCurrenciesState extends Equatable {
  const ListCurrenciesState();

  @override
  List<Object> get props => [];
}

class ListCurrenciesInitial extends ListCurrenciesState {}

class LoadingListCurrenciesState extends ListCurrenciesState {}

class LoadedListCurrenciesState extends ListCurrenciesState {
  final List<Currency> currencies;

  const LoadedListCurrenciesState({required this.currencies});

  @override
  List<Object> get props => [currencies];
}

class ErrorListCurrenciesState extends ListCurrenciesState {
  final String message;

  const ErrorListCurrenciesState({required this.message});

  @override
  List<Object> get props => [message];
}
