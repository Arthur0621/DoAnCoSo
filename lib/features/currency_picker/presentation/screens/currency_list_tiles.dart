import 'package:flutter/material.dart';
import 'package:moneynest/features/currency_picker/data/models/currency.dart';

class CurrencyListTiles extends StatelessWidget {
  const CurrencyListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Currency')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(vndCurrency.name),
            subtitle: Text(vndCurrency.symbol),
            onTap: null,
          ),
        ],
      ),
    );
  }
}