import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/core/database/daos/budget_dao.dart';
import 'package:moneynest/core/di/di.dart';
import 'package:moneynest/features/budget/riverpod/transactions_provider.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

final budgetDaoProvider = Provider<BudgetDao>((ref) {
  final db = ref.watch(databaseProvider);
  return BudgetDao(db);
});

final budgetsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(budgetDaoProvider).watchBudgets();
});

/// Provider trả về currentBalance thực tế từ model ngân sách (không còn tính toán động từ transaction)
final budgetBalancesProvider = Provider.autoDispose<Map<int, double>>((ref) {
  final budgetsAsync = ref.watch(budgetsProvider);
  if (budgetsAsync.asData == null) {
    return {};
  }
  final budgets = budgetsAsync.asData!.value;
  final Map<int, double> balances = {
    for (final budget in budgets) budget.id: budget.currentBalance ?? 0.0,
  };
  return balances;
});
