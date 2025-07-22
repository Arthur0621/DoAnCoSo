import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/components/buttons/button_chip.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

class TransactionTypeSelector extends HookConsumerWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeSelected;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: TransactionType.values.map((type) {
        String label;
        switch (type) {
          case TransactionType.income:
            label = 'Thu nhập';
            break;
          case TransactionType.expense:
            label = 'Chi tiêu';
            break;
          case TransactionType.transfer:
            label = 'Chuyển';
            break;
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ButtonChip(
              label: label,
              active: selectedType == type,
              onTap: () => onTypeSelected(type),
            ),
          ),
        );
      }).toList(),
    );
  }
}
