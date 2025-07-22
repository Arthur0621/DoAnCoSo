import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneynest/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:moneynest/core/components/buttons/button_state.dart';
import 'package:moneynest/core/components/buttons/primary_button.dart';
import 'package:moneynest/core/components/form_fields/custom_numeric_field.dart';
import 'package:moneynest/core/components/form_fields/custom_text_field.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/core/database/database_provider.dart';
import 'package:moneynest/core/extensions/string_extension.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/currency_picker/presentation/components/currency_picker_field.dart';
import 'package:moneynest/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';
import 'package:toastification/toastification.dart';

class WalletFormBottomSheet extends HookConsumerWidget {
  final WalletModel? wallet; // Nullable for add mode
  const WalletFormBottomSheet({super.key, this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.read(currencyProvider);
    final isEditing = wallet != null;

    final nameController = useTextEditingController();
    final balanceController = useTextEditingController();
    final currencyController = useTextEditingController();
    // Add controllers for iconName and colorHex if you plan to edit them
    // final iconController = useTextEditingController(text: wallet?.iconName ?? '');
    // final colorController = useTextEditingController(text: wallet?.colorHex ?? '');

    // Initialize form fields if in edit mode (already handled by controller initial text)
    useEffect(() {
      if (isEditing && wallet != null) {
        nameController.text = wallet!.name;
        balanceController.text = wallet!.balance.toString();
        currencyController.text = wallet!.currency;
      }
      return null;
    }, [wallet, isEditing]);

    return CustomBottomSheet(
      title: '${isEditing ? 'Sửa' : 'Thêm'} ví',
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.spacing16,
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Tên ví',
              hint: 'ví dụ: Ví tiết kiệm',
              isRequired: true,
              prefixIcon: HugeIcons.strokeRoundedWallet02,
              textInputAction: TextInputAction.next,
            ),
            CurrencyPickerField(defaultCurrency: currency),
            CustomNumericField(
              controller: balanceController,
              defaultCurreny: currency.isoCode,
              label: 'Số dư ban đầu',
              hint: '0.00',
              icon: HugeIcons.strokeRoundedMoney01,
              isRequired: true,
              // autofocus: !isEditing, // Optional: autofocus if adding new
            ),
            PrimaryButton(
              label: 'Lưu ví',
              state: ButtonState.active,
              onPressed: () async {
                final newWallet = WalletModel(
                  id: wallet?.id, // Keep ID for updates, null for inserts
                  name: nameController.text.trim(),
                  balance: balanceController.text.takeNumericAsDouble(),
                  currency: currency.isoCode,
                  iconName: wallet?.iconName, // Preserve or add UI to change
                  colorHex: wallet?.colorHex, // Preserve or add UI to change
                );

                Log.d(newWallet.toJson(), label: 'New Wallet');
                // return;

                final db = ref.read(databaseProvider);
                try {
                  if (isEditing) {
                    await db.walletDao.updateWallet(newWallet);
                  } else {
                    await db.walletDao.addWallet(newWallet);
                  }
                  if (context.mounted) context.pop(); // Close bottom sheet
                } catch (e) {
                  // Handle error, e.g., show a SnackBar
                  toastification.show(
                    description: Text('Error saving wallet: $e'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
