import 'package:drift/drift.dart';
import '../moneynest_database.dart';
import '../tables/budget_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(AppDatabase db) : super(db);

  Future<int> insertBudget(BudgetsCompanion budget) => into(budgets).insert(budget);
  Future updateBudget(Budget budget) => update(budgets).replace(budget);
  Future deleteBudget(int id) => (delete(budgets)..where((t) => t.id.equals(id))).go();
  Stream<List<Budget>> watchBudgets() => select(budgets).watch();

  Future<Budget?> getBudgetById(int id) async {
    return (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateBudgetUsedAmount(int budgetId, double usedAmount) async {
    await (update(budgets)..where((b) => b.id.equals(budgetId))).write(BudgetsCompanion(usedAmount: Value(usedAmount)));
  }

  /// Cập nhật cộng/trừ số dư thực tế của ngân sách (currentBalance)
  Future<void> updateBudgetBalance(int budgetId, double delta) async {
    final budget = await getBudgetById(budgetId);
    if (budget != null) {
      final newBalance = (budget.currentBalance ?? 0) + delta;
      print('[DEBUG] updateBudgetBalance: id=$budgetId, old=${budget.currentBalance}, delta=$delta, new=$newBalance');
      await updateBudget(budget.copyWith(currentBalance: newBalance));
    }
  }
}
