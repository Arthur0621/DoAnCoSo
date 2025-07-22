import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneynest/core/components/buttons/small_button.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/core/extensions/double_extension.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

class TransactionSummaryCard extends StatelessWidget {
  final List<TransactionModel> transactions;
  const TransactionSummaryCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.purpleAlpha10,
        border: Border.all(color: AppColors.purpleAlpha10),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thu vào',
                style: AppTextStyles.body3.copyWith(color: AppColors.purple950),
              ),
              Expanded(
                child: Text(
                  transactions.totalIncome.toDouble().toPriceFormat(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chi ra',
                style: AppTextStyles.body3.copyWith(color: AppColors.purple950),
              ),
              Expanded(
                child: Text(
                  '- ${transactions.totalExpenses.toDouble().toPriceFormat()}',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.red700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.purpleAlpha10,
            thickness: 1,
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.purple950,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Text(
                  transactions.total.toDouble().toPriceFormat(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.numericMedium.copyWith(
                    color: AppColors.purple950,
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.spacing4),
          const SmallButton(
            label: 'Xem chi tiết ',
            backgroundColor: AppColors.purpleAlpha10,
            borderColor: AppColors.purpleAlpha10,
            foregroundColor: AppColors.purple,
            labelTextStyle: AppTextStyles.body5,
          ),
        ],
      ),
    );
  }
}
