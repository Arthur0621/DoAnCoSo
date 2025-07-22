import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/currency_picker/data/models/currency.dart';

class CurrencyLocalDataSource {
  Future<List<Currency>> getCurrencies() async {
    // Chỉ trả về VND
    final jsonString =
        await rootBundle.loadString('assets/data/currencies.json');
    final jsonList = jsonDecode(jsonString);
    final vndCurrency = jsonList['currencies'].firstWhere((currency) => currency['isoCode'] == 'VND');
    return [Currency.fromJson(vndCurrency)];
  }

  static const Currency dummy = Currency(
    symbol: '',
    name: '',
    decimalDigits: 0,
    rounding: 0,
    isoCode: '',
    namePlural: '',
    country: '',
    countryCode: '',
  );

  List<String> getAvailableCurrencies() {
    // Chỉ trả về mã quốc gia Việt Nam
    return ['VN'];
  }
}
