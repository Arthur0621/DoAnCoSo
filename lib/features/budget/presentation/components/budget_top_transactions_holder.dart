import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/features/budget/presentation/components/budget_top_transactions.dart';

class BudgetTopTransactionsHolder extends StatelessWidget {
  const BudgetTopTransactionsHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Transactions',
            style: AppTextStyles.body3,
          ),
          Gap(AppSpacing.spacing12),
          BudgetTopTransactions(),
        ],
      ),
    );
  }
}
