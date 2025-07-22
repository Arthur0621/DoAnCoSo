import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/form_fields/custom_text_field.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

class TransactionTitleField extends StatelessWidget {
  final TextEditingController controller;
  final TransactionType transactionType;

  const TransactionTitleField({super.key, required this.controller, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    final isIncome = transactionType == TransactionType.income;
    return CustomTextField(
      controller: controller,
      label: isIncome ? 'Nguồn thu nhập' : 'Title',
      hint: isIncome ? 'Ví dụ: Lương, thưởng, bán hàng...' : 'Mua sắm, du lịch',
      prefixIcon: HugeIcons.strokeRoundedArrangeByLettersAZ,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      isRequired: true,
    );
  }
}
