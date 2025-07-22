import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneynest/core/components/progress_indicators/progress_bar.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/features/budget/presentation/components/budget_spent_card.dart';
import 'package:moneynest/features/budget/presentation/components/budget_card_holder.dart';

import 'package:moneynest/features/budget/riverpod/budget_providers.dart';
import 'package:moneynest/features/budget/riverpod/transactions_provider.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/current_month_expense_provider.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';

class BudgetSummaryCard extends ConsumerWidget {
  const BudgetSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
      ),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.tertiary50,
        border: Border.all(color: AppColors.tertiaryAlpha25),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(AppSpacing.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tổng ngân sách còn lại',
                    style: AppTextStyles.body4,
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () {
                      ref.refresh(currentMonthExpenseProvider);
                      ref.refresh(monthlyBudgetProvider);
                      ref.refresh(allWalletsStreamProvider);
                      ref.refresh(budgetsProvider);
                      ref.refresh(transactionsProvider);
                    },
                    borderRadius: BorderRadius.circular(AppRadius.radius8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.purpleAlpha10,
                        border: Border.all(color: AppColors.purpleAlpha10),
                        borderRadius: BorderRadius.circular(AppRadius.radius8),
                      ),
                      child: const Icon(
                        Icons.remove_red_eye,
                        size: 14,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, _) {
                  final budgetsAsync = ref.watch(budgetsProvider);
                  final transactionsAsync = ref.watch(transactionsProvider);
                  return budgetsAsync.when(
                    data: (budgets) {
                      return transactionsAsync.when(
                        data: (transactions) {
                          double totalBudgetBalance = 0;
                          for (final budget in budgets) {
                            // Tổng tiền đã chuyển vào ngân sách này (từ các giao dịch chuyển khoản từ ví vào ngân sách)
                            final transferredIn = transactions
                                .where((t) => t.transactionType == TransactionType.transfer && t.toBudgetId == budget.id)
                                .fold<double>(0, (sum, t) => sum + t.amount);
                            // Tổng chi tiêu từ ngân sách này
                            final spent = transactions
                                .where((t) => t.transactionType == TransactionType.expense && t.fromBudgetId == budget.id)
                                .fold<double>(0, (sum, t) => sum + t.amount);
                            final budgetBalance = (transferredIn - spent).clamp(0, double.infinity);
                            totalBudgetBalance += budgetBalance;
                          }
                          final formatted = totalBudgetBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
                          return Text(
                            formatted,
                            style: AppTextStyles.numericHeading.copyWith(color: AppColors.primary),
                          );
                        },
                        loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                        error: (e, _) => Text('Lỗi ngân sách', style: AppTextStyles.numericHeading.copyWith(color: AppColors.primary)),
                      );
                    },
                    loading: () => const SizedBox(height: 32, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                    error: (e, _) => Text('Lỗi ngân sách', style: AppTextStyles.numericHeading.copyWith(color: AppColors.primary)),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final walletsAsync = ref.watch(allWalletsStreamProvider);
                  return walletsAsync.when(
                    data: (wallets) {
                      final totalWalletBalance = wallets.fold<double>(0, (sum, w) => sum + w.balance);
                      final formatted = totalWalletBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary50,
                            borderRadius: BorderRadius.circular(AppRadius.radius8),
                            border: Border.all(color: AppColors.secondaryAlpha10),
                          ),
                          child: Text(
                            'Tổng số dư các ví: $formatted VND',
                            style: AppTextStyles.body4.copyWith(color: AppColors.purple950),
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(height: 24, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                    error: (e, _) => Text('Lỗi ví', style: AppTextStyles.body4.copyWith(color: AppColors.purple950)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
