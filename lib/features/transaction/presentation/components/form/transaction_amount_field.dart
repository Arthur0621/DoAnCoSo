import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/form_fields/custom_numeric_field.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

class TransactionAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String defaultCurrency;
  final bool autofocus;
  final TransactionType transactionType;

  const TransactionAmountField({
    super.key,
    required this.controller,
    required this.defaultCurrency,
    required this.transactionType,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transactionType == TransactionType.income;
    return CustomNumericField(
      controller: controller,
      label: isIncome ? 'Số tiền nhận' : 'Số tiền chi',
      hint: 'VND',
      icon: HugeIcons.strokeRoundedCoins01,
      isRequired: true,
      autofocus: autofocus,
    );
  }
}
