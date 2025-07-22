import 'package:moneynest/features/analytics/domain/models/transaction_summary.dart';

abstract class AnalyticsRepository {
  Future<List<TransactionSummary>> getTransactionSummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Map<String, double>> getCategorySummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Map<String, double>> getTransactionsByCategory({
    required DateTime startDate,
    required DateTime endDate,
    bool isIncome,
  });
}
