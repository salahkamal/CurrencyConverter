import 'package:currency_converter/domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.code,
    required super.name,
    required super.symbol,
    super.decimalDigits,
    super.namePlural,
    super.nativeSymbol,
    super.rounding,
    super.type,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      symbol: json['symbol'],
      name: json['name'],
      nativeSymbol: json['symbol_native'],
      decimalDigits: json['decimal_digits'],
      rounding: json['rounding'],
      code: json['code'],
      namePlural: json['name_plural'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['symbol_native'] = nativeSymbol;
    data['decimal_digits'] = decimalDigits;
    data['rounding'] = rounding;
    data['code'] = code;
    data['name_plural'] = namePlural;
    data['type'] = type;
    return data;
  }
}
