// Add back all the necessary imports
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneynest/features/analytics/domain/models/transaction_summary.dart';
import 'package:moneynest/features/analytics/domain/enums/transaction_type_filter.dart';
import 'package:moneynest/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:moneynest/features/analytics/presentation/providers/providers.dart' as custom_providers;
import 'package:moneynest/features/analytics/presentation/providers/providers.dart' as custom_providers;

class IncomeExpenseChart extends ConsumerWidget {
  const IncomeExpenseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(custom_providers.dateRangeProvider);
    final transactionType = ref.watch(custom_providers.transactionTypeFilterProvider);
    
    final summaryAsync = ref.watch(transactionSummaryProvider((start: dateRange.start, end: dateRange.end)));


    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      data: (summaries) {
        if (summaries.isEmpty) {
          return const Center(
            child: Text('Không có dữ liệu giao dịch trong khoảng thời gian này'),
          );
        }

        final filteredSummaries = summaries.where((summary) {
          if (transactionType == TransactionTypeFilter.income) {
            return summary.income > 0;
          } else if (transactionType == TransactionTypeFilter.expense) {
            return summary.expense > 0;
          }
          return true;
        }).toList();

        if (filteredSummaries.isEmpty) {
          return const Center(
            child: Text('Không có dữ liệu phù hợp với bộ lọc'),
          );
        }

        return Column(
          children: [
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(filteredSummaries),
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final summary = filteredSummaries[groupIndex];
                        final isIncome = rodIndex == 0;
                        final label = isIncome ? 'Thu nhập' : 'Chi tiêu';
                        final value = rod.toY;
                        return BarTooltipItem(
                          '$label\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: NumberFormat.currency(symbol: '₫', decimalDigits: 0).format(value),
                              style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= filteredSummaries.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd/MM').format(filteredSummaries[value.toInt()].date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(filteredSummaries, transactionType, context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(transactionType, context),
          ],
        );
      },
    );
  }

  double _calculateMaxY(List<TransactionSummary> summaries) {
    double max = 0;
    for (var summary in summaries) {
      final total = summary.income + summary.expense;
      if (total > max) max = total;
    }
    return max * 1.2;
  }

  double _calculateMinY(List<TransactionSummary> summaries) {
    double min = 0;
    for (var summary in summaries) {
      if (summary.expense > 0) {
        final expense = -summary.expense;
        if (expense < min) min = expense;
      }
    }
    return min * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(
    List<TransactionSummary> summaries,
    TransactionTypeFilter filter,
    BuildContext context,
  ) {
    return List.generate(summaries.length, (index) {
      final summary = summaries[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          if (filter != TransactionTypeFilter.expense)
            BarChartRodData(
              toY: summary.income,
              color: Theme.of(context).primaryColor,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
          if (filter != TransactionTypeFilter.income)
            BarChartRodData(
              toY: -summary.expense,
              color: Theme.of(context).colorScheme.error,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
        ],
        showingTooltipIndicators: [0, 1],
      );
    });
  }

  Widget _buildLegend(TransactionTypeFilter filter, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (filter != TransactionTypeFilter.expense)
          _buildLegendItem('Thu nhập', theme.primaryColor, context),
        if (filter != TransactionTypeFilter.expense &&
            filter != TransactionTypeFilter.income)
          const SizedBox(width: 16),
        if (filter != TransactionTypeFilter.income)
          _buildLegendItem('Chi tiêu', theme.colorScheme.error, context),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}