import 'dart:async';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/features/analytics/domain/models/transaction_summary.dart';
import 'package:moneynest/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:logging/logging.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AppDatabase _db;
  final _logger = Logger('AnalyticsRepository');

  AnalyticsRepositoryImpl(this._db);

  @override
  Future<List<TransactionSummary>> getTransactionSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final transactions = await _db.transactionDao.getTransactionsByDateRange(
        startDate,
        endDate,
      );

      final Map<DateTime, ({double income, double expense, int count})> summaryMap = {};

      for (final transaction in transactions) {
        final date = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );

        final current = summaryMap[date] ?? (income: 0.0, expense: 0.0, count: 0);
        
        if (transaction.transactionType == 0) { // 0: income
          summaryMap[date] = (
            income: current.income + transaction.amount.abs(),
            expense: current.expense,
            count: current.count + 1,
          );
        } else if (transaction.transactionType == 1) { // 1: expense
          summaryMap[date] = (
            income: current.income,
            expense: current.expense + transaction.amount.abs(),
            count: current.count + 1,
          );
        }
      }

      return summaryMap.entries
          .map((e) => TransactionSummary(
                date: e.key,
                income: e.value.income,
                expense: e.value.expense,
                transactionCount: e.value.count,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e, stackTrace) {
      _logger.severe('Error in getTransactionSummary', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getTransactionsByCategory({
    required DateTime startDate,
    required DateTime endDate,
    bool isIncome = false,
  }) async {
    try {
      final transactions = await _db.transactionDao.getTransactionsByDateRange(
        startDate,
        endDate,
      );

      final categoryMap = <String, double>{};

      for (final transaction in transactions) {
        _logger.info('[DEBUG] id=${transaction.id}, type=${transaction.transactionType}, amount=${transaction.amount}, date=${transaction.date}, categoryId=${transaction.categoryId}');
        if ((isIncome && transaction.transactionType != 0) ||
            (!isIncome && transaction.transactionType != 1)) {
          continue;
        }

        String categoryName = 'Không phân loại';
        if (transaction.categoryId != null) {
          final category = await _db.categoryDao.getCategoryById(transaction.categoryId!);
          categoryName = category?.title ?? 'Không phân loại';
        }
        final amount = transaction.amount.abs();

        categoryMap.update(
          categoryName,
          (value) => value + amount,
          ifAbsent: () => amount,
        );
      }

      return categoryMap;
    } catch (e, stackTrace) {
      _logger.severe('Error in getTransactionsByCategory', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getCategorySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Get both income and expense categories
      final incomeByCategory = await getTransactionsByCategory(
        startDate: startDate,
        endDate: endDate,
        isIncome: true,
      );
      
      final expenseByCategory = await getTransactionsByCategory(
        startDate: startDate,
        endDate: endDate,
        isIncome: false,
      );

      // Combine both maps
      final result = <String, double>{};
      
      // Add income (positive values)
      incomeByCategory.forEach((category, amount) {
        result[category] = amount;
      });
      
      // Add expenses (negative values)
      expenseByCategory.forEach((category, amount) {
        result[category] = (result[category] ?? 0) - amount;
      });

      return result;
    } catch (e, stackTrace) {
      _logger.severe('Error in getCategorySummary', e, stackTrace);
      rethrow;
    }
  }
}