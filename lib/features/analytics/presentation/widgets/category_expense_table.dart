import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryExpenseTable extends StatelessWidget {
  final Map<String, double> categoryExpenseData;
  const CategoryExpenseTable({
    super.key,
    required this.categoryExpenseData,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = categoryExpenseData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = sortedEntries.fold<double>(0, (sum, e) => sum + e.value);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
      columns: const [
        DataColumn(label: Text('Danh mục')),
        DataColumn(label: Text('Số tiền chi')),
        DataColumn(label: Text('Tỉ lệ (%)')),
      ],
      rows: [
        for (final entry in sortedEntries)
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text(NumberFormat.currency(symbol: '₫', decimalDigits: 0).format(entry.value))),
            DataCell(Text(total > 0 ? (entry.value / total * 100).toStringAsFixed(1) + '%' : '-')),
          ]),
      ],
      border: TableBorder.all(color: Colors.deepPurple, width: 1),
      headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.deepPurple.shade50),
      dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.white),
      dividerThickness: 2,
      showBottomBorder: true,
            ),
          ),
        );
      },
    );
  }
}
