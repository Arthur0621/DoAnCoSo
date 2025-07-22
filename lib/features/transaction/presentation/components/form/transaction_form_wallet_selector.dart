import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';
import 'package:moneynest/core/components/form_fields/custom_select_field.dart';

/// Wallet selector for transfer forms: select source or destination wallet.
class TransactionFormWalletSelector extends ConsumerWidget {
  final WalletModel? selectedWallet;
  final ValueChanged<WalletModel?> onWalletSelected;
  final String label;
  final String hint;
  final int? excludeWalletId; // To prevent selecting the same wallet

  const TransactionFormWalletSelector({
    super.key,
    required this.selectedWallet,
    required this.onWalletSelected,
    required this.label,
    required this.hint,
    this.excludeWalletId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(allWalletsStreamProvider);
    return walletsAsync.when(
      data: (wallets) {
        final filtered = excludeWalletId == null
            ? wallets
            : wallets.where((w) => w.id != excludeWalletId).toList();
        return CustomSelectField(
          controller: TextEditingController(
            text: selectedWallet?.name ?? '',
          ),
          label: label,
          hint: hint,
          isRequired: true,
          onTap: () async {
            final chosen = await showModalBottomSheet<WalletModel>(
              context: context,
              builder: (ctx) => ListView(
                children: filtered
                    .map(
                      (w) => ListTile(
                        leading: w.iconName != null
                            ? Icon(Icons.account_balance_wallet)
                            : null,
                        title: Text(w.name),
                        subtitle: Text(w.formattedBalance),
                        onTap: () => Navigator.of(ctx).pop(w),
                        selected: selectedWallet?.id == w.id,
                      ),
                    )
                    .toList(),
              ),
            );
            if (chosen != null) {
              onWalletSelected(chosen);
            }
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Lỗi tải ví: $e'),
    );
  }
}
