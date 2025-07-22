import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart';
import 'package:moneynest/features/budget/riverpod/budget_providers.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/components/form_fields/custom_select_field.dart';

/// Wrapper object to represent either a wallet or a budget
class AccountOrBudget {
  final WalletModel? wallet;
  final Budget? budget;
  AccountOrBudget.wallet(this.wallet) : budget = null;
  AccountOrBudget.budget(this.budget) : wallet = null;
  bool get isWallet => wallet != null;
  bool get isBudget => budget != null;
  String get displayName => isWallet ? wallet!.name : (budget?.name ?? '');
  String get subtitle => isWallet ? wallet!.formattedBalance : 'Ngân sách: ${budget?.amount ?? ''}';
}

class AccountOrBudgetSelector extends ConsumerWidget {
  final AccountOrBudget? selected;
  final ValueChanged<AccountOrBudget?> onSelected;
  final String label;
  final String hint;

  const AccountOrBudgetSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(allWalletsStreamProvider);
    final budgetsAsync = ref.watch(budgetsProvider);
    return walletsAsync.when(
      data: (wallets) {
        return budgetsAsync.when(
          data: (budgets) {
            return CustomSelectField(
              controller: TextEditingController(
                text: selected?.displayName ?? '',
              ),
              label: label,
              hint: hint,
              isRequired: true,
              onTap: () async {
                final chosen = await showModalBottomSheet<AccountOrBudget>(
                  context: context,
                  builder: (ctx) => ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Ví', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...wallets.map((w) => ListTile(
                            leading: const Icon(Icons.account_balance_wallet),
                            title: Text(w.name),
                            subtitle: Text(w.formattedBalance),
                            onTap: () => Navigator.of(ctx).pop(AccountOrBudget.wallet(w)),
                            selected: selected?.wallet?.id == w.id,
                          )),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Ngân sách', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...budgets.map((b) => ListTile(
                            leading: const Icon(Icons.savings),
                            title: Text(b.name),
                            subtitle: Text('Ngân sách: ${b.amount}'),
                            onTap: () => Navigator.of(ctx).pop(AccountOrBudget.budget(b)),
                            selected: selected?.budget?.id == b.id,
                          )),
                    ],
                  ),
                );
                if (chosen != null) {
                  onSelected(chosen);
                }
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Lỗi tải ngân sách: $e'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Lỗi tải ví: $e'),
    );
  }
}
