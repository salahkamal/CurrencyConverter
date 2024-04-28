import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'currency_history.g.dart';

@HiveType(typeId: 1)
class CurrencyHistory extends Equatable {
  @HiveField(0)
  final String baseCurrency;
  @HiveField(1)
  final String currencies;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final double exchangeRate;
  @HiveField(4)
  final int savingTime;

  const CurrencyHistory({
    required this.baseCurrency,
    required this.currencies,
    required this.amount,
    required this.exchangeRate,
    required this.savingTime,
  });

  @override
  List<Object?> get props => [
        baseCurrency,
        currencies,
        amount,
        exchangeRate,
        savingTime,
      ];
}
