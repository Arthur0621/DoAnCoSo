import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/budget/riverpod/budget_providers.dart';
import 'package:moneynest/features/budget/presentation/components/budget_card.dart';
import 'package:moneynest/features/category/data/repositories/category_repo.dart';
import 'package:moneynest/core/database/daos/transaction_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/features/budget/riverpod/transactions_provider.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngân sách của tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/budget_form');
            },
          ),
        ],
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          return transactionsAsync.when(
            data: (transactions) {
              final allCategories = categories.getAllCategories();
              return ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  final category = allCategories.firstWhere(
                    (cat) => cat.id == budget.categoryId,
                    orElse: () => allCategories.first,
                  );
                  // Tính tổng chi tiêu cho ngân sách này
                  final spent = transactions
                      .where((tx) =>
                          tx.category.id == budget.categoryId &&
                          tx.wallet.id == budget.walletId &&
                          tx.transactionType == TransactionType.expense &&
                          tx.date.isAfter(budget.startDate.subtract(const Duration(days: 1))) &&
                          (budget.endDate == null || tx.date.isBefore(budget.endDate!.add(const Duration(days: 1)))))
                      .fold<double>(0, (sum, tx) => sum + tx.amount);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: BudgetCard(
                      category: category,
                      amountSpent: spent,
                      amountTarget: budget.amount,
                      isRecurring: budget.isRecurring,
                      startDate: budget.startDate,
                      endDate: budget.endDate,
                      onTap: () {},
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
      ),
    );
  }
}
