// ignore_for_file: library_private_types_in_public_api

import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/entities/currency_history.dart';
import 'package:currency_converter/features/currency_history/presentation/bloc/currency_history_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/widgets/flag_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CurrencyExchangeHistoryScreen extends StatelessWidget {
  const CurrencyExchangeHistoryScreen({super.key});
  static const String routeName = 'Currency Exchange History Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange History'),
      ),
      body: BlocBuilder<ListCurrenciesBloc, ListCurrenciesState>(
        builder: (context, listCurrencies) {
          if (listCurrencies is LoadingListCurrenciesState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (listCurrencies is LoadedListCurrenciesState) {
            Currency selectedCurrency1 = listCurrencies.currencies.first;
            Currency selectedCurrency2 = listCurrencies.currencies.first;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<CurrencyHistoryBloc, CurrencyHistoryState>(
                    builder: (context, currencyExchangeState) {
                      if (currencyExchangeState is Dropdown1ValueSelected) {
                        selectedCurrency1 =
                            currencyExchangeState.dropdown1Value;
                      }
                      return DropdownButtonFormField<Currency>(
                        value: selectedCurrency1,
                        items:
                            listCurrencies.currencies.map((Currency currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Row(
                              children: [
                                FlagImage(
                                  code: currency.code,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(currency.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (Currency? newValue) {
                          context
                              .read<CurrencyHistoryBloc>()
                              .add(Dropdown1SelectionChanged(newValue!));
                        },
                        decoration: const InputDecoration(
                          labelText: 'Currency 1',
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<CurrencyHistoryBloc, CurrencyHistoryState>(
                    builder: (context, currencyExchangeState) {
                      if (currencyExchangeState is Dropdown2ValueSelected) {
                        selectedCurrency2 =
                            currencyExchangeState.dropdown2Value;
                      }
                      return DropdownButtonFormField<Currency>(
                        value: selectedCurrency2,
                        items:
                            listCurrencies.currencies.map((Currency currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Row(
                              children: [
                                FlagImage(
                                  code: currency.code,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(currency.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (Currency? newValue) {
                          context
                              .read<CurrencyHistoryBloc>()
                              .add(Dropdown2SelectionChanged(newValue!));
                        },
                        decoration: const InputDecoration(
                          labelText: 'Currency 2',
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CurrencyHistoryBloc>().add(
                          GetExchangeRateHistory(
                              selectedCurrency1.code, selectedCurrency2.code));
                    },
                    child: const Text('Show History'),
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<CurrencyHistoryBloc, CurrencyHistoryState>(
                    builder: (context, state) {
                      if (state is CurrencyHistoryLoadedState) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: state.currencyHistory.length,
                              itemBuilder: (context, index) {
                                CurrencyHistory currencyHistory =
                                    state.currencyHistory[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FlagImage(
                                                code: currencyHistory
                                                    .baseCurrency),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${currencyHistory.amount} ${currencyHistory.baseCurrency} to ${currencyHistory.currencies} is ${(currencyHistory.amount * currencyHistory.exchangeRate).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 10),
                                            FlagImage(
                                                code:
                                                    currencyHistory.currencies),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(DateFormat.yMEd().add_jm().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                currencyHistory.savingTime))),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
