import 'package:flutter/material.dart';

/// Enum for time type selection
enum TransactionTimeType { day, week, month, year, custom }

class TransactionTimeTypeSelector extends StatelessWidget {
  final TransactionTimeType selectedType;
  final ValueChanged<TransactionTimeType> onTypeSelected;

  const TransactionTimeTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['Ngày', 'Tuần', 'Tháng', 'Năm', 'Khoảng thời gian'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: TransactionTimeType.values.map((type) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(labels[type.index]),
              selected: selectedType == type,
              onSelected: (_) => onTypeSelected(type),
            ),
          ),
        );
      }).toList(),
    );
  }
}
