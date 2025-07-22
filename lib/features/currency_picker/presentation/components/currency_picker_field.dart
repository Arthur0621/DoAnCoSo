import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/currency_picker/data/models/currency.dart';

class CurrencyPickerField extends HookConsumerWidget {
  final Currency? defaultCurrency;
  const CurrencyPickerField({super.key, this.defaultCurrency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyController = useTextEditingController(text: vndCurrency.name);

    return TextField(
      controller: currencyController,
      decoration: InputDecoration(
        labelText: 'Loại tiền',
        hintText: vndCurrency.symbol,
        prefixIcon: Icon(Icons.attach_money),
      ),
      readOnly: true,
      enabled: false,
    );
  }
}
