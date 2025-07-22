import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'package:moneynest/features/transaction/data/model/transaction_ui_extension.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final bool showDate;
  const TransactionTile({
    super.key,
    required this.transaction,
    this.showDate = true,
  });

  IconData _getTransactionIcon(TransactionModel tx) {
    if (tx.transactionType == TransactionType.transfer) {
      return Icons.swap_horiz;
    } else if (tx.transactionType == TransactionType.income) {
      return Icons.attach_money;
    } else if (tx.transactionType == TransactionType.expense) {
      // Nếu muốn map icon theo iconName thì có thể mở rộng ở đây
      // Hiện tại mặc định là shopping_bag
      return Icons.shopping_bag;
    }
    return Icons.help_outline;
  }

  /// Hiển thị mô tả nguồn -> đích cho giao dịch chuyển khoản
  String _buildTransferInfo(TransactionModel tx) {
    // Ưu tiên hiển thị ví/ngân sách nếu có tên, nếu không thì fallback mặc định
    String from = '';
    String to = '';
    // Nếu chuyển từ ví sang ví
    if (tx.wallet != null && tx.fromBudgetId == null && tx.toBudgetId == null) {
      from = tx.wallet?.name ?? 'Ví nguồn';
      to = 'Ví đích';
    } else if (tx.wallet != null && tx.toBudgetId != null) {
      from = tx.wallet?.name ?? 'Ví nguồn';
      to = 'Ngân sách';
    } else if (tx.fromBudgetId != null && tx.wallet != null) {
      from = 'Ngân sách';
      to = tx.wallet?.name ?? 'Ví đích';
    } else if (tx.fromBudgetId != null && tx.toBudgetId != null) {
      from = 'Ngân sách nguồn';
      to = 'Ngân sách đích';
    } else if (tx.toBudgetId != null) {
      from = 'Ví';
      to = 'Ngân sách';
    } else if (tx.fromBudgetId != null) {
      from = 'Ngân sách';
      to = 'Ví';
    } else {
      from = 'Nguồn';
      to = 'Đích';
    }
    return '$from → $to';
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/transaction/${transaction.id}'),
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing8,
          AppSpacing.spacing8,
          AppSpacing.spacing16,
          AppSpacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          border: Border.all(color: AppColors.neutralAlpha10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  color: transaction.backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.radius12),
                  border: Border.all(color: transaction.borderColor),
                ),
                child: Center(
                  child: Icon(
                    _getTransactionIcon(transaction),
                    color: transaction.iconColor,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.spacing12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (transaction.transactionType == TransactionType.transfer)
                        ...[
                          Text(
                            'Chuyển',
                            style: AppTextStyles.body3.copyWith(color: AppColors.tertiary),
                          ),
                          const Gap(AppSpacing.spacing2),
                          Text(
                            _buildTransferInfo(transaction),
                            style: AppTextStyles.body4.copyWith(color: AppColors.neutral500),
                          ),
                        ]
                      else ...[
                        Text(transaction.title, style: AppTextStyles.body3),
                        const Gap(AppSpacing.spacing2),
                        Text(
                          transaction.category.title,
                          style: AppTextStyles.body4.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (showDate)
                        Text(
                          transaction.formattedDate,
                          style: AppTextStyles.body5.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      if (showDate) const Gap(AppSpacing.spacing4),
                      Text(
                        transaction.formattedAmount,
                        style: AppTextStyles.numericMedium.copyWith(
                          color: transaction.amountColor,
                          height: 1.12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
