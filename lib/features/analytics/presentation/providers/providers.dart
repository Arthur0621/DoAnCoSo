import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/core/di/di.dart';
import 'package:moneynest/features/analytics/domain/enums/time_range_filter.dart';
import 'package:moneynest/features/analytics/domain/enums/transaction_type_filter.dart';
import 'package:moneynest/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:moneynest/features/analytics/data/repositories/analytics_repository_impl.dart';
// Time Range Provider
final timeRangeFilterProvider = StateProvider<TimeRangeFilter>((ref) {
  return TimeRangeFilter.month;
});

// Transaction Type Filter Provider
final transactionTypeFilterProvider = StateProvider<TransactionTypeFilter>((ref) {
  return TransactionTypeFilter.all;
});

// Date Range Provider
final dateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final timeRange = ref.watch(timeRangeFilterProvider);
  return timeRange.getDateRange();
});

// Category Summary Provider
// Analytics Repository Provider
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AnalyticsRepositoryImpl(db);
});

// Category Summary Provider - dùng record để kèm biến isIncome
final categorySummaryProvider = FutureProvider.family<
    Map<String, double>, ({DateTime start, DateTime end, bool isIncome})>((ref, params) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return await repository.getTransactionsByCategory(
    startDate: params.start,
    endDate: params.end,
    isIncome: params.isIncome,
  );
});