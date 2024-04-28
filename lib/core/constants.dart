class Constants {
  static const String kBaseUrl = String.fromEnvironment('BASE_URL');
  static const String kApiKey = String.fromEnvironment('API_KEY');
  static const String kCurrencyBox = 'currency_box';
  static const String kCurrencyHistoryBox = 'currency_history_box';
  static const String kLatestUrlPath = '/latest';
  static const String kCurrenciesUrlPath = '/currencies';
  static const String kEmptyCacheFailureMessage = 'No Data';
  static const String kOfflineFailureMessage =
      'Please Check your Internet Connection';
}
