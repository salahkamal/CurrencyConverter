import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/widgets/flag_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListCurrenciesScreen extends StatelessWidget {
  const ListCurrenciesScreen({super.key});
  static const String routeName = 'List Currencies Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency List'),
      ),
      body: BlocBuilder<ListCurrenciesBloc, ListCurrenciesState>(
        builder: (context, state) {
          if (state is LoadingListCurrenciesState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedListCurrenciesState) {
            return ListView.builder(
              itemCount: state.currencies.length,
              itemBuilder: (context, index) {
                Currency currency = state.currencies[index];
                return ListTile(
                  title: Text(currency.name),
                  subtitle: Text(currency.code),
                  trailing: Text(
                    currency.symbol,
                    style: const TextStyle(fontSize: 20),
                  ),
                  tileColor: Colors.black12,
                  leading: FlagImage(code: currency.code),
                );
              },
            );
          } else if (state is ErrorListCurrenciesState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
