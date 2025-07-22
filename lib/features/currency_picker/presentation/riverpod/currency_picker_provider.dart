import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/currency_picker/data/models/currency.dart';

final currencyProvider = StateProvider<Currency>((ref) {
  return vndCurrency;
});

final currenciesStaticProvider = StateProvider<List<Currency>>((ref) {
  return [vndCurrency];
});

final currenciesProvider = FutureProvider.autoDispose<List<Currency>>((ref) async {
  return [vndCurrency];
});
