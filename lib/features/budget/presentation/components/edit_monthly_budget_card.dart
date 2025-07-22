import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';

import 'package:moneynest/features/budget/presentation/components/budget_card_holder.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/current_month_expense_provider.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';
import 'package:moneynest/features/wallet/riverpod/selected_wallet_provider.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_form_wallet_selector.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart'; // Để extension formattedBalance hoạt động
class EditMonthlyBudgetCard extends ConsumerWidget {
  final String? initialName;
  final String? initialCategory;
  final double? initialAmount;
  final bool? initialRecurring;
  final void Function(String name, String category, double amount, bool isRecurring) onBudgetChanged;

  const EditMonthlyBudgetCard({
    super.key,
    this.initialName,
    this.initialCategory,
    this.initialAmount,
    this.initialRecurring,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: initialName ?? '');
    final categoryController = TextEditingController(text: initialCategory ?? '');
    final amountController = TextEditingController(text: initialAmount?.toStringAsFixed(0) ?? '');
    bool isRecurring = initialRecurring ?? false;

    final selectedWallet = ref.watch(selectedWalletProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.tertiary50,
        border: Border.all(color: AppColors.tertiaryAlpha25),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Chọn ví và hiển thị số dư ---
          TransactionFormWalletSelector(
            selectedWallet: selectedWallet,
            onWalletSelected: (wallet) => ref.read(selectedWalletProvider.notifier).state = wallet,
            label: 'Chọn ví',
            hint: 'Chọn ví để xem số dư',
          ),
          const SizedBox(height: AppSpacing.spacing8),
          if (selectedWallet != null)
            Text('Số dư: ' + selectedWallet.formattedBalance, style: AppTextStyles.body4.copyWith(color: AppColors.tertiary900)),
          if (selectedWallet == null)
            Text('Chưa chọn ví', style: AppTextStyles.body4.copyWith(color: AppColors.tertiary900)),
          const SizedBox(height: AppSpacing.spacing16),
          Text('Tên ngân sách', style: AppTextStyles.body4.copyWith(color: AppColors.tertiary900)),
          const SizedBox(height: AppSpacing.spacing8),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nhập tên ngân sách',
            ),
          ),
          const SizedBox(height: AppSpacing.spacing16),
          Text('Danh mục', style: AppTextStyles.body4.copyWith(color: AppColors.tertiary900)),
          const SizedBox(height: AppSpacing.spacing8),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Chọn danh mục',
            ),
          ),
          const SizedBox(height: AppSpacing.spacing16),
          Text('Số tiền cần dùng', style: AppTextStyles.body4.copyWith(color: AppColors.tertiary900)),
          const SizedBox(height: AppSpacing.spacing8),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nhập số tiền',
            ),
            style: AppTextStyles.numericMedium,
          ),
          const SizedBox(height: AppSpacing.spacing16),
          Row(
            children: [
              StatefulBuilder(
                builder: (context, setState) => Checkbox(
                  value: isRecurring,
                  onChanged: (value) {
                    setState(() {
                      isRecurring = value ?? false;
                    });
                  },
                ),
              ),
              const Text('Đánh dấu ngân sách này là định kỳ'),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing16),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final category = categoryController.text.trim();
              final amount = double.tryParse(amountController.text.replaceAll('.', '')) ?? 0;
              onBudgetChanged(name, category, amount, isRecurring);
              FocusScope.of(context).unfocus();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
