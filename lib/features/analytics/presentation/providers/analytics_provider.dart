import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/core/di/di.dart';
import 'package:moneynest/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:moneynest/features/analytics/domain/models/transaction_summary.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepositoryImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return AnalyticsRepositoryImpl(db);
});

final dateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  // Default to current month
  final firstDay = DateTime(now.year, now.month, 1);
  final lastDay = DateTime(now.year, now.month + 1, 0);
  return DateTimeRange(start: firstDay, end: lastDay);
});

final transactionSummaryProvider = FutureProvider.family<List<TransactionSummary>, ({DateTime start, DateTime end})>((ref, params) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return await repository.getTransactionSummary(
    startDate: params.start,
    endDate: params.end,
  );
});
