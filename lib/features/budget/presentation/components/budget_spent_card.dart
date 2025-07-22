import 'package:flutter/material.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/current_month_expense_provider.dart';

class BudgetSpentCard extends ConsumerWidget {
  const BudgetSpentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.red50,
        border: Border.all(color: AppColors.redAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng chi tiêu',
            style: AppTextStyles.body5.copyWith(
              color: AppColors.red,
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final expenseAsync = ref.watch(currentMonthExpenseProvider);
              return expenseAsync.when(
                data: (expense) {
                  final formatted = expense.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
                  return Text(
                    formatted,
                    style: AppTextStyles.numericMedium.copyWith(
                      color: AppColors.red900,
                    ),
                  );
                },
                loading: () => const SizedBox(height: 24, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                error: (e, _) => Text('Lỗi', style: AppTextStyles.numericMedium.copyWith(color: AppColors.red900)),
              );
            },
          ),
        ],
      ),
    );
  }
}
