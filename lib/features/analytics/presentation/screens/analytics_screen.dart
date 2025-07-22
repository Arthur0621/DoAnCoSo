import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneynest/core/components/scaffolds/custom_scaffold.dart';
import 'package:moneynest/features/analytics/presentation/widgets/income_expense_chart.dart';
import 'package:moneynest/features/analytics/presentation/widgets/category_pie_chart.dart';
import 'package:moneynest/features/analytics/presentation/widgets/category_expense_table.dart';
import 'package:moneynest/features/analytics/presentation/providers/providers.dart' as custom_providers;
import 'package:moneynest/features/analytics/domain/enums/time_range_filter.dart';
import 'package:moneynest/features/analytics/domain/enums/transaction_type_filter.dart';
import 'package:moneynest/core/di/di.dart'; // Để sử dụng databaseProvider
import '../widgets/analytics_chat_box.dart';


// Bổ sung widget cho chế độ bảng (table)
class _CategoryTableSection extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool isIncome;
  const _CategoryTableSection({
    required this.startDate,
    required this.endDate,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySummaryAsync = ref.watch(
      custom_providers.categorySummaryProvider((start: startDate, end: endDate, isIncome: isIncome)),
    );
    return categorySummaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      data: (categoryMap) {
        if (categoryMap.isEmpty) {
          return Center(
            child: Text(
              isIncome ? 'Không có thu nhập' : 'Không có chi tiêu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          );
        }
        return CategoryExpenseTable(categoryExpenseData: categoryMap);
      },
    );
  }
}

enum ChartType { pie, table }

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(custom_providers.dateRangeProvider);
    final dateRangeNotifier = ref.read(custom_providers.dateRangeProvider.notifier);
    final timeRangeFilter = ref.watch(custom_providers.timeRangeFilterProvider);
    final timeRangeNotifier = ref.read(custom_providers.timeRangeFilterProvider.notifier);
    final transactionType = ref.watch(custom_providers.transactionTypeFilterProvider);
    final transactionTypeNotifier = ref.read(custom_providers.transactionTypeFilterProvider.notifier);

    Future<void> _selectDateRange(BuildContext context) async {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        locale: const Locale('vi'),
        initialDateRange: dateRange,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && picked != dateRange) {
        timeRangeNotifier.state = TimeRangeFilter.custom;
        dateRangeNotifier.state = picked;
      }
    }

    void _updateTimeRange(TimeRangeFilter filter) {
      timeRangeNotifier.state = filter;
      if (filter != TimeRangeFilter.custom) {
        dateRangeNotifier.state = filter.getDateRange();
      }
    }

    final chartTypeNotifier = ref.watch(_chartTypeProvider.notifier);
    final chartType = ref.watch(_chartTypeProvider);

    return CustomScaffold(
      context: context,
      title: 'Phân tích thu/chi',
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80), // chừa chỗ cho chat box và bottom nav
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Time Range Filter
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chọn khoảng thởi gian',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTimeRangeChip(
                                  context,
                                  'Ngày',
                                  TimeRangeFilter.day,
                                  timeRangeFilter,
                                  _updateTimeRange,
                                ),
                                const SizedBox(width: 8),
                                _buildTimeRangeChip(
                                  context,
                                  'Tuần',
                                  TimeRangeFilter.week,
                                  timeRangeFilter,
                                  _updateTimeRange,
                                ),
                                const SizedBox(width: 8),
                                _buildTimeRangeChip(
                                  context,
                                  'Tháng',
                                  TimeRangeFilter.month,
                                  timeRangeFilter,
                                  _updateTimeRange,
                                ),
                                const SizedBox(width: 8),
                                _buildTimeRangeChip(
                                  context,
                                  'Năm',
                                  TimeRangeFilter.year,
                                  timeRangeFilter,
                                  _updateTimeRange,
                                ),
                                const SizedBox(width: 8),
                                _buildCustomDateRangeChip(
                                  context,
                                  dateRange,
                                  _selectDateRange,
                                  isSelected: timeRangeFilter == TimeRangeFilter.custom,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Transaction Type Filter
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Loại giao dịch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTransactionTypeChip(
                                  context,
                                  'Tất cả',
                                  TransactionTypeFilter.all,
                                  transactionType,
                                  transactionTypeNotifier,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTransactionTypeChip(
                                  context,
                                  'Thu nhập',
                                  TransactionTypeFilter.income,
                                  transactionType,
                                  transactionTypeNotifier,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTransactionTypeChip(
                                  context,
                                  'Chi tiêu',
                                  TransactionTypeFilter.expense,
                                  transactionType,
                                  transactionTypeNotifier,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Chart Type Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ToggleButtons(
                        isSelected: [chartType == ChartType.pie, chartType == ChartType.table],
                        onPressed: (index) {
                          final notifier = ref.read(_chartTypeProvider.notifier);
                          if (index == 0) notifier.state = ChartType.pie;
                          if (index == 1) notifier.state = ChartType.table;
                        },
                        children: const [
                          Icon(Icons.pie_chart),
                          Icon(Icons.table_chart),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Biểu đồ thu chi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: (transactionType == TransactionTypeFilter.all && chartType == ChartType.pie)
                                ? _IncomeExpensePieChartSection(
                                    startDate: dateRange.start,
                                    endDate: dateRange.end,
                                  )
                                : (transactionType == TransactionTypeFilter.expense && chartType == ChartType.table
                                    ? _CategoryTableSection(
                                        startDate: dateRange.start,
                                        endDate: dateRange.end,
                                        isIncome: false,
                                      )
                                    : _CategoryPieChartSection(
                                        startDate: dateRange.start,
                                        endDate: dateRange.end,
                                        isIncome: transactionType == TransactionTypeFilter.income,
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chat box nhỏ luôn ở cuối cùng
          // Chat box nhỏ luôn nổi phía trên bottom nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // dịch lên cao hơn để tránh che bởi phím điều hướng
            child: AnalyticsChatBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeChip(
    BuildContext context,
    String label,
    TimeRangeFilter value,
    TimeRangeFilter selectedValue,
    void Function(TimeRangeFilter) onSelected,
  ) {
    final isSelected = selectedValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected(value);
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }

  Widget _buildCustomDateRangeChip(
    BuildContext context,
    DateTimeRange dateRange,
    Future<void> Function(BuildContext) onTap, {
    required bool isSelected,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 16),
          const SizedBox(width: 4),
          Text(
            '${dateFormat.format(dateRange.start)} - ${dateFormat.format(dateRange.end)}',
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }

  Widget _buildTransactionTypeChip(
    BuildContext context,
    String label,
    TransactionTypeFilter value,
    TransactionTypeFilter selectedValue,
    StateController<TransactionTypeFilter> notifier,
  ) {
    final isSelected = selectedValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) notifier.state = value;
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}

/// Provider để lưu trạng thái dạng biểu đồ
final _chartTypeProvider = StateProvider<ChartType>((ref) => ChartType.pie);

class _IncomeExpensePieChartSection extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  const _IncomeExpensePieChartSection({
    required this.startDate,
    required this.endDate,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeAsync = ref.watch(
      custom_providers.categorySummaryProvider((start: startDate, end: endDate, isIncome: true)),
    );
    final expenseAsync = ref.watch(
      custom_providers.categorySummaryProvider((start: startDate, end: endDate, isIncome: false)),
    );
    return incomeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      data: (incomeMap) {
        return expenseAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Lỗi: $error')),
          data: (expenseMap) {
            final totalIncome = incomeMap.values.fold(0.0, (a, b) => a + b);
            final totalExpense = expenseMap.values.fold(0.0, (a, b) => a + b);
            final pieData = <String, double>{
              'Thu nhập': totalIncome,
              'Chi tiêu': totalExpense,
            }..removeWhere((key, value) => value == 0);
            if (pieData.isEmpty) {
              return const Center(child: Text('Không có dữ liệu thu/chi'));
            }
            return CategoryPieChart(
              categoryData: pieData,
              isIncome: false, // Không dùng màu thu/chi riêng, dùng mặc định
            );
          },
        );
      },
    );
  }
}

class _CategoryPieChartSection extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool isIncome;
  const _CategoryPieChartSection({
    required this.startDate,
    required this.endDate,
    required this.isIncome,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySummaryAsync = ref.watch(
      custom_providers.categorySummaryProvider((start: startDate, end: endDate, isIncome: isIncome)),
    );
    return categorySummaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      data: (categoryMap) {
        if (categoryMap.isEmpty) {
          return Center(
            child: Text(
              isIncome ? 'Không có thu nhập' : 'Không có chi tiêu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          );
        }
        // Nếu là chế độ pie thì hiện biểu đồ tròn, nếu là chế độ bảng thì hiện bảng thống kê
        final chartType = ref.watch(_chartTypeProvider);
        if (chartType == ChartType.pie) {
          return CategoryPieChart(
            categoryData: categoryMap,
            isIncome: isIncome,
          );
        } else {
          // Hiện bảng thống kê, chỉ cho chi tiêu
          if (isIncome) {
            return Center(child: Text('Chỉ hỗ trợ bảng cho chi tiêu.')); // hoặc bạn có thể mở rộng cho cả thu nhập nếu muốn
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CategoryExpenseTable(categoryExpenseData: categoryMap),
            ),
          );
        }
      },
    );
  }
}

class _CategoryBreakdown extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool isIncome;

  const _CategoryBreakdown({
    required this.startDate,
    required this.endDate,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySummaryAsync = ref.watch(
      custom_providers.categorySummaryProvider((start: startDate, end: endDate, isIncome: isIncome)),

    );

    return categorySummaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      data: (categoryMap) {
        if (categoryMap.isEmpty) {
          return Center(
            child: Text(
              isIncome ? 'Không có thu nhập' : 'Không có chi tiêu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          );
        }

        final total = categoryMap.values.fold(0.0, (sum, amount) => sum + amount);
        final sortedCategories = categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isIncome ? 'Thu nhập' : 'Chi tiêu',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...sortedCategories.map((entry) {
              final percentage = (entry.value / total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${NumberFormat.currency(symbol: '₫', decimalDigits: 0).format(entry.value)} ($percentage%)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor: Theme.of(context).dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isIncome
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.error,
                      ),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}