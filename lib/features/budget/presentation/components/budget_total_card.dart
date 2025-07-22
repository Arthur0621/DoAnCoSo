import 'package:flutter/material.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/constants/app_radius.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/constants/app_text_styles.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';

class BudgetTotalCard extends ConsumerWidget {
  const BudgetTotalCard({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(allWalletsStreamProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        border: Border.all(color: AppColors.purpleAlpha25),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng số dư các ví',
            style: AppTextStyles.body5.copyWith(
              color: AppColors.purple,
            ),
          ),
          walletsAsync.when(
            data: (wallets) {
              final total = wallets.fold<double>(0, (sum, w) => sum + (w.balance ?? 0));
              final formatted = WalletModel(balance: total).formattedBalance;
              return Text(
                formatted,
                style: AppTextStyles.numericMedium.copyWith(
                  color: AppColors.purple900,
                ),
              );
            },
            loading: () => const SizedBox(height: 24, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
            error: (e, _) => Text('Lỗi', style: AppTextStyles.numericMedium.copyWith(color: AppColors.purple900)),
          ),
        ],
      ),
    );
  }
}
