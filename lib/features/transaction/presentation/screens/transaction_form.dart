import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import hooks_riverpod
import 'package:moneynest/core/components/buttons/button_state.dart';
import 'package:moneynest/core/components/buttons/primary_button.dart';
import 'package:moneynest/core/components/scaffolds/custom_scaffold.dart';
import 'package:moneynest/core/constants/app_spacing.dart';
import 'package:moneynest/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:moneynest/features/transaction/presentation/components/transaction_date_picker.dart';
import 'package:moneynest/features/transaction/presentation/components/transaction_image_picker.dart';
import 'package:moneynest/features/transaction/presentation/components/transaction_image_preview.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_type_selector.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_title_field.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_amount_field.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_category_selector.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_form_wallet_selector.dart';
import 'package:moneynest/features/transaction/presentation/components/form/account_or_budget_selector.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_time_type_selector.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_notes_field.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/transaction_form_state.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/transaction_providers.dart';

class TransactionForm extends HookConsumerWidget {
  // Change to HookConsumerWidget
  final int? transactionId;
  const TransactionForm({super.key, this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrency = ref
        .read(authStateProvider)
        .defaultCurrency; // Determine if we are in "edit" mode
    final isEditing = transactionId != null;

    // Fetch transaction details if in edit mode
    final asyncTransaction = isEditing
        ? ref.watch(transactionDetailsProvider(transactionId!))
        : null;

    // Instantiate the hook. It will get the transaction data when it's ready.
    final formState = useTransactionFormState(
      ref: ref,
      defaultCurrency: defaultCurrency,
      isEditing: isEditing,
      transaction:
          asyncTransaction?.valueOrNull, // Pass current data, hook handles null
    );

    return CustomScaffold(
      context: context,
      title: !isEditing
          ? 'Thêm giao dịch'
          : 'Sửa giao dịch', // Dynamic title
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
              child: isEditing
                  ? asyncTransaction!.when(
                      // Data is already passed to the hook above.
                      // The hook's useEffect will handle updates when transactionData changes.
                      data: (transactionData) =>
                          _buildActualForm(context, ref, formState),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text('Lỗi khi tải giao dịch: $err'),
                      ),
                    )
                  // For new transactions, asyncTransaction is null, formState is initialized for 'new'.
                  : _buildActualForm(context, ref, formState),
            ),
          ),
          PrimaryButton(
            label: 'Lưu',
            state: ButtonState.active,
            // Now formState is available in this scope
            onPressed: () async {
             final transactionType = formState.selectedTransactionType.value;
             if (transactionType == TransactionType.transfer) {
               final source = formState.selectedSourceAccountOrBudget.value;
               final dest = formState.selectedDestinationAccountOrBudget.value;
               final amountStr = formState.amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
               final amount = double.tryParse(amountStr) ?? 0;
               if (source == null || dest == null) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Vui lòng chọn nguồn và nơi nhận (ví hoặc ngân sách).')),
                 );
                 return;
               }
               if (source.displayName == dest.displayName) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Không thể chuyển giữa cùng một tài khoản/ngân sách.')),
                 );
                 return;
               }
               if (amount <= 0) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Số tiền chuyển phải lớn hơn 0.')),
                 );
                 return;
               }
               // Nếu cả nguồn và đích đều là ví thì kiểm tra số dư và id
               if (source.isWallet && dest.isWallet) {
                 if (source.wallet!.id == dest.wallet!.id) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Không thể chuyển tiền giữa cùng một ví.')),
                   );
                   return;
                 }
                 if (source.wallet!.balance < amount) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Số dư ví nguồn không đủ để chuyển.')),
                   );
                   return;
                 }
               }
               // All good, proceed
             }
             await formState.saveTransaction(ref, context);
           },
          ).floatingBottom,
        ],
      ),
    );
  }

  Widget _buildActualForm(
    BuildContext context,
    WidgetRef ref,
    TransactionFormState formState,
  ) {
    final transactionType = formState.selectedTransactionType.value;
    final isIncome = transactionType == TransactionType.income;
    final isCustomRange = isIncome && formState.selectedTimeType.value == TransactionTimeType.custom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(AppSpacing.spacing12),
        const Gap(AppSpacing.spacing12),
        TransactionTypeSelector(
          selectedType: formState.selectedTransactionType.value,
          onTypeSelected: (type) {
            formState.selectedTransactionType.value = type;
            // Reset category & time type when đổi loại giao dịch
            formState.selectedCategory.value = null;
            formState.categoryController.text = '';
            if (type == TransactionType.income) {
              formState.selectedTimeType.value = TransactionTimeType.day;
              formState.customDateRange.value = null;
            }
          },
        ),
        const Gap(AppSpacing.spacing12),
        if (isIncome) ...[
          const Gap(AppSpacing.spacing16),
          // Chọn kiểu thời gian
          TransactionTimeTypeSelector(
            selectedType: formState.selectedTimeType.value,
            onTypeSelected: (type) {
              formState.selectedTimeType.value = type;
              if (type != TransactionTimeType.custom) {
                formState.customDateRange.value = null;
              }
            },
          ),
          if (isCustomRange)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange: formState.customDateRange.value,
                        );
                        if (picked != null) {
                          formState.customDateRange.value = picked;
                        }
                      },
                      child: Text(
                        formState.customDateRange.value == null
                            ? 'Chọn khoảng thời gian'
                            : '${formState.customDateRange.value!.start.day}/${formState.customDateRange.value!.start.month}/${formState.customDateRange.value!.start.year} - '
                              '${formState.customDateRange.value!.end.day}/${formState.customDateRange.value!.end.month}/${formState.customDateRange.value!.end.year}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        TransactionTitleField(
          controller: formState.titleController,
          transactionType: formState.selectedTransactionType.value,
        ),
        const Gap(AppSpacing.spacing16),
        if (transactionType == TransactionType.transfer) ...[
          AccountOrBudgetSelector(
            selected: formState.selectedSourceAccountOrBudget.value,
            onSelected: (account) {
              formState.selectedSourceAccountOrBudget.value = account;
              // Prevent selecting same for destination
              if (formState.selectedDestinationAccountOrBudget.value?.displayName == account?.displayName) {
                formState.selectedDestinationAccountOrBudget.value = null;
              }
            },
            label: 'Chọn nguồn chuyển',
            hint: 'Chọn ví hoặc ngân sách nguồn',
          ),
          const Gap(AppSpacing.spacing12),
          AccountOrBudgetSelector(
            selected: formState.selectedDestinationAccountOrBudget.value,
            onSelected: (account) {
              formState.selectedDestinationAccountOrBudget.value = account;
              // Prevent selecting same for source
              if (formState.selectedSourceAccountOrBudget.value?.displayName == account?.displayName) {
                formState.selectedSourceAccountOrBudget.value = null;
              }
            },
            label: 'Chọn nơi nhận',
            hint: 'Chọn ví hoặc ngân sách đích',
          ),
          const Gap(AppSpacing.spacing16),
        ],
        TransactionAmountField(
          controller: formState.amountController,
          defaultCurrency: formState.defaultCurrency,
          transactionType: formState.selectedTransactionType.value,
          autofocus: !formState.isEditing,
        ),
        const Gap(AppSpacing.spacing16),
        if (transactionType != TransactionType.transfer) ...[
          TransactionCategorySelector(
            controller: formState.categoryController, // For displaying the text
            onCategorySelected: (category) {
              formState.selectedCategory.value = category;
              formState.categoryController.text = formState.getCategoryText();
            },
            categoryTypeFilter: transactionType == TransactionType.income
                ? CategoryType.income
                : transactionType == TransactionType.expense
                    ? CategoryType.expense
                    : CategoryType.transfer,
          ),
        ],
        const Gap(AppSpacing.spacing16),
        TransactionDatePicker(initialDate: formState.initialTransaction?.date),
        const Gap(AppSpacing.spacing16),
        TransactionNotesField(controller: formState.notesController),
        const Gap(AppSpacing.spacing16),
        const TransactionImagePicker(),
        const Gap(AppSpacing.spacing16),
        const TransactionImagePreview(),
      ],
    );
  }
}
