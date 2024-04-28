part of 'list_currencies_bloc.dart';

abstract class ListCurrenciesEvent extends Equatable {
  const ListCurrenciesEvent();

  @override
  List<Object> get props => [];
}

class GetAllCurrenciesEvent extends ListCurrenciesEvent {}
