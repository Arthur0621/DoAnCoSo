import 'package:moneynest/features/currency_picker/data/models/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> fetchCurrencies();
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  @override
  Future<List<Currency>> fetchCurrencies() async {
    // Chỉ trả về VND
    return [Currency(code: 'VND', name: 'Việt Nam đồng', symbol: '₫')];
  }
}
