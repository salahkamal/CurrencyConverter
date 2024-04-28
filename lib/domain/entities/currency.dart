import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'currency.g.dart';

@HiveType(typeId: 0)
class Currency extends Equatable {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String symbol;
  @HiveField(3)
  final String? nativeSymbol;
  @HiveField(4)
  final int? decimalDigits;
  @HiveField(5)
  final int? rounding;
  @HiveField(6)
  final String? namePlural;
  @HiveField(7)
  final String? type;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    this.nativeSymbol,
    this.decimalDigits,
    this.rounding,
    this.namePlural,
    this.type,
  });

  @override
  List<Object?> get props => [
        code,
        name,
        symbol,
        nativeSymbol,
        decimalDigits,
        rounding,
        namePlural,
        type
      ];
}

const List<Currency> currencies = [
  Currency(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
  ),
  Currency(
    code: 'USD',
    name: 'US Dollar',
    symbol: "\$",
  ),
  Currency(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
  ),
  Currency(
    code: 'BGN',
    name: 'Bulgarian Lev',
    symbol: 'BGN',
  ),
];
