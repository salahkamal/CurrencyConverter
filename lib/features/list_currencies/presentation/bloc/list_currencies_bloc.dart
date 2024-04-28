import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/core/error/failure.dart';
import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/usecases/get_all_currencies_usecase.dart';

part 'list_currencies_event.dart';
part 'list_currencies_state.dart';

class ListCurrenciesBloc
    extends Bloc<ListCurrenciesEvent, ListCurrenciesState> {
  final GetAllCurrenciesUsecase getAllCurrenciesUsecase;
  ListCurrenciesBloc({required this.getAllCurrenciesUsecase})
      : super(ListCurrenciesInitial()) {
    on<ListCurrenciesEvent>((event, emit) async {
      log(event.toString());
      if (event is GetAllCurrenciesEvent) {
        emit(LoadingListCurrenciesState());

        final failureOrCurrency = await getAllCurrenciesUsecase();
        emit(_mapFailureOrCurrencyToState(failureOrCurrency));
      }
    });
  }
}

ListCurrenciesState _mapFailureOrCurrencyToState(
    Either<Failure, List<Currency>> either) {
  return either.fold(
    (failure) => ErrorListCurrenciesState(message: failure.message),
    (currencies) => LoadedListCurrenciesState(
      currencies: currencies,
    ),
  );
}
