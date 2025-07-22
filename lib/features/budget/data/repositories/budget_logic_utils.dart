import 'package:moneynest/features/budget/data/model/budget_model.dart';

/// Tính tổng ngân sách còn hiệu lực cho tất cả ví hoặc 1 ví cụ thể.
double getTotalBudget(List<BudgetModel> budgets, {String? walletId}) {
  final now = DateTime.now();
  return budgets
      .where((b) =>
          (walletId == null || b.fundSource == walletId) &&
          !now.isBefore(b.startDate) &&
          !now.isAfter(b.endDate))
      .fold(0.0, (sum, b) => sum + b.amount);
}

/// Lấy danh sách ngân sách còn hiệu lực cho 1 ví, 1 danh mục, hoặc toàn bộ
double getCategoryBudget(List<BudgetModel> budgets, String categoryId, {String? walletId}) {
  final now = DateTime.now();
  return budgets
      .where((b) =>
          b.categoryId == categoryId &&
          (walletId == null || b.fundSource == walletId) &&
          !now.isBefore(b.startDate) &&
          !now.isAfter(b.endDate))
      .fold(0.0, (sum, b) => sum + b.amount);
}

/// Khi thêm ngân sách mới, chỉ thêm bản ghi mới, không update/cộng dồn vào bản ghi cũ.
void addBudget(List<BudgetModel> budgets, BudgetModel newBudget) {
  budgets.add(newBudget);
}

/// Khi chỉnh sửa ngân sách, chỉ update bản ghi được chọn (theo id)
void updateBudget(List<BudgetModel> budgets, BudgetModel updatedBudget) {
  final idx = budgets.indexWhere((b) => b.id == updatedBudget.id);
  if (idx != -1) {
    budgets[idx] = updatedBudget;
  }
}

/// Khi xóa ngân sách, chỉ xóa bản ghi theo id
void deleteBudget(List<BudgetModel> budgets, String budgetId) {
  budgets.removeWhere((b) => b.id == budgetId);
}
