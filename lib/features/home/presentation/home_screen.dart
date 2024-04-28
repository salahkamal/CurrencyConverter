import 'package:currency_converter/features/currency_exchange/presentation/pages/currency_exchange_screen.dart';
import 'package:currency_converter/features/currency_history/presentation/pages/currency_history_screen.dart';
import 'package:currency_converter/features/list_currencies/presentation/pages/list_currencies_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = 'Home Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.currency_exchange_sharp,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ListCurrenciesScreen.routeName);
              },
              child: const Text('List All Currencies'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CurrencyExchangeScreen.routeName);
              },
              child: const Text('Currency Converter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, CurrencyExchangeHistoryScreen.routeName);
              },
              child: const Text('Currency History'),
            ),
          ],
        ),
      ),
    );
  }
}
