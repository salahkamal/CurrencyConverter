// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/features/currency_exchange/presentation/bloc/currency_exchange_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/widgets/flag_image_widget.dart';

class CurrencyExchangeScreen extends StatelessWidget {
  CurrencyExchangeScreen({super.key});
  static const String routeName = 'Currency Exchange Screen';
  final TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange'),
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
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text('Amount'), border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<CurrencyExchangeBloc, CurrencyExchangeState>(
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
                                FlagImage(code: currency.code),
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
                              .read<CurrencyExchangeBloc>()
                              .add(Dropdown1SelectionChanged(newValue!));
                        },
                        decoration: const InputDecoration(
                          labelText: 'From',
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<CurrencyExchangeBloc, CurrencyExchangeState>(
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
                                FlagImage(code: currency.code),
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
                              .read<CurrencyExchangeBloc>()
                              .add(Dropdown2SelectionChanged(newValue!));
                        },
                        decoration: const InputDecoration(
                          labelText: 'To',
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
                      context.read<CurrencyExchangeBloc>().add(GetExchangeRate(
                          double.tryParse(amountController.text) ?? 1.0,
                          selectedCurrency1.code,
                          selectedCurrency2.code));
                    },
                    child: const Text('Calculate'),
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<CurrencyExchangeBloc, CurrencyExchangeState>(
                    builder: (context, state) {
                      if (state is ExchangeRateChanged) {
                        return Center(
                          child: Text(
                              '${amountController.text} ${selectedCurrency1.code} is ${state.rate} ${selectedCurrency2.code}'),
                        );
                      } else if (state is ErrorCurrencyExchangeState) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      } else if (state is LoadingCurrencyExchangeState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            );
          } else if (listCurrencies is ErrorListCurrenciesState) {
            return Center(
              child: Text(
                listCurrencies.message,
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
