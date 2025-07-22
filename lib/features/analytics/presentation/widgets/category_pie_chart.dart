import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final bool isIncome;
  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final total = categoryData.values.fold(0.0, (sum, value) => sum + value);
    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final colors = List<Color>.generate(
      sortedEntries.length,
      (i) => Colors.primaries[i % Colors.primaries.length],
    );
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: List.generate(sortedEntries.length, (i) {
                final entry = sortedEntries[i];
                final percent = total > 0 ? (entry.value / total * 100) : 0;
                return PieChartSectionData(
                  value: entry.value,
                  color: colors[i],
                  title: percent >= 5 ? '${percent.toStringAsFixed(1)}%' : '',
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  radius: 60,
                );
              }),
              sectionsSpace: 2,
              centerSpaceRadius: 36,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: List.generate(sortedEntries.length, (i) {
            final entry = sortedEntries[i];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: colors[i]),
                const SizedBox(width: 4),
                Text(entry.key, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 4),
                Text(NumberFormat.currency(symbol: '₫', decimalDigits: 0).format(entry.value), style: Theme.of(context).textTheme.bodySmall),
              ],
            );
          }),
        ),
      ],
    );
  }
}
