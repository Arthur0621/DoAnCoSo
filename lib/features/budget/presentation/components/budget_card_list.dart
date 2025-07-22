import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/budget/riverpod/budget_providers.dart';
import 'package:moneynest/features/budget/presentation/components/budget_card.dart';
import 'package:moneynest/features/category/data/repositories/category_repo.dart';
import 'package:moneynest/features/budget/riverpod/transactions_provider.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'package:moneynest/features/budget/riverpod/budget_providers.dart';

class BudgetCardList extends ConsumerWidget {
  const BudgetCardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final balances = ref.watch(budgetBalancesProvider);

    return budgetsAsync.when(
      data: (budgets) {
        return transactionsAsync.when(
          data: (transactions) {
            final allCategories = categories.getAllCategories();
            if (budgets.isEmpty) {
              return const Center(child: Text('Chưa có ngân sách nào'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final category = allCategories.firstWhere(
                  (cat) => cat.id == budget.categoryId,
                  orElse: () => allCategories.first,
                );
                final spent = transactions
                    .where((tx) =>
                        tx.category.id == budget.categoryId &&
                        tx.wallet?.id == budget.walletId &&
                        tx.transactionType == TransactionType.expense &&
                        tx.date.isAfter(budget.startDate.subtract(const Duration(days: 1))) &&
                        (budget.endDate == null || tx.date.isBefore(budget.endDate!.add(const Duration(days: 1)))))
                    .fold<double>(0, (sum, tx) => sum + tx.amount);
                final balance = balances[budget.id] ?? 0;
                print('[DEBUG][UI] BudgetCardList: budgetId=${budget.id}, name=${budget.name}, currentBalance=${budget.currentBalance}, balanceProvider=$balance');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: BudgetCard(
                    budgetName: budget.name,
                    category: category,
                    amountSpent: spent,
                    amountTarget: budget.amount,
                    isRecurring: budget.isRecurring,
                    startDate: budget.startDate,
                    endDate: budget.endDate,
                    onTap: () {},
                    balance: balance,
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Xác nhận'),
                          content: const Text('Bạn có chắc muốn xóa ngân sách này?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final budgetDao = ref.read(budgetDaoProvider);
                        await budgetDao.deleteBudget(budget.id);
                        ref.invalidate(budgetsProvider);
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Lỗi giao dịch: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Lỗi: $err')),
    );
  }
}
