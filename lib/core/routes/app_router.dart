import 'package:currency_converter/core/dependency_injection.dart' as di;
import 'package:currency_converter/features/currency_exchange/presentation/bloc/currency_exchange_bloc.dart';
import 'package:currency_converter/features/currency_exchange/presentation/pages/currency_exchange_screen.dart';
import 'package:currency_converter/features/currency_history/presentation/bloc/currency_history_bloc.dart';
import 'package:currency_converter/features/currency_history/presentation/pages/currency_history_screen.dart';
import 'package:currency_converter/features/home/presentation/home_screen.dart';
import 'package:currency_converter/features/list_currencies/presentation/bloc/list_currencies_bloc.dart';
import 'package:currency_converter/features/list_currencies/presentation/pages/list_currencies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => di.sl<ListCurrenciesBloc>(),
                  child: const HomeScreen(),
                ));
      case ListCurrenciesScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      di.sl<ListCurrenciesBloc>()..add(GetAllCurrenciesEvent()),
                  child: const ListCurrenciesScreen(),
                ));
      case CurrencyExchangeScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => di.sl<ListCurrenciesBloc>()
                        ..add(GetAllCurrenciesEvent()),
                    ),
                    BlocProvider(
                      create: (context) => di.sl<CurrencyExchangeBloc>(),
                    ),
                  ],
                  child: CurrencyExchangeScreen(),
                ));
      case CurrencyExchangeHistoryScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => di.sl<ListCurrenciesBloc>()
                        ..add(GetAllCurrenciesEvent()),
                    ),
                    BlocProvider(
                      create: (context) => di.sl<CurrencyHistoryBloc>(),
                    ),
                  ],
                  child: const CurrencyExchangeHistoryScreen(),
                ));
      default:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
