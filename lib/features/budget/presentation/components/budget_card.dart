import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/progress_indicators/progress_bar.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/features/category/data/repositories/category_repo.dart';
import 'package:moneynest/features/category_picker/presentation/components/category_tile.dart';

import 'package:moneynest/features/category/data/model/category_model.dart';

class BudgetCard extends StatelessWidget {
  final String budgetName;
  final CategoryModel category;
  final double amountSpent;
  final double amountTarget;
  final double balance;
  final bool isRecurring;
  final DateTime startDate;
  final DateTime? endDate;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BudgetCard({
    super.key,
    required this.budgetName,
    required this.category,
    required this.amountSpent,
    required this.amountTarget,
    required this.balance,
    required this.isRecurring,
    required this.startDate,
    this.endDate,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (amountTarget > 0) ? (balance / amountTarget).clamp(0, 1) : 0.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(color: AppColors.darkAlpha10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budgetName,
              style: AppTextStyles.heading5,
            ),
            const SizedBox(height: 4),
            CategoryTile(
              category: category,
              suffixIcon: Icons.delete,
              onSuffixIconPressed: onDelete,
            ),
            Gap(AppSpacing.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ".")} VND',
                  style: AppTextStyles.body4.copyWith(color: Colors.green),
                ),
                Text(
                  '${amountTarget.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ".")} VND',
                  style: AppTextStyles.body4.copyWith(color: AppColors.purple),
                ),
              ],
            ),
            Gap(AppSpacing.spacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   'Đã chi: ${amountSpent.toStringAsFixed(0)} VND',
                //   style: AppTextStyles.body5.copyWith(color: AppColors.red),
                // ),
              ],
            ),
            Gap(AppSpacing.spacing8),
            ProgressBar(value: progress.toDouble(), foreground: AppColors.purpleAlpha50),
            if (isRecurring)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.repeat, size: 16, color: AppColors.purple),
                    SizedBox(width: 4),
                    Text('Định kỳ', style: AppTextStyles.body4.copyWith(color: AppColors.purple)),

                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

