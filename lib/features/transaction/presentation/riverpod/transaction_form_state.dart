// File: f:\applications\flutter\moneynest\lib\features\transaction\presentation\hooks\use_transaction_form_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/database/database_provider.dart';
import 'package:moneynest/core/extensions/double_extension.dart';
import 'package:moneynest/core/extensions/string_extension.dart';
import 'package:moneynest/core/services/image_service/riverpod/image_notifier.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'package:moneynest/features/transaction/presentation/riverpod/date_picker_provider.dart';
import 'package:moneynest/features/wallet/riverpod/wallet_providers.dart'; // To access activeWalletProvider
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';
import 'package:moneynest/features/transaction/presentation/components/form/account_or_budget_selector.dart';

import 'package:moneynest/features/transaction/presentation/components/form/transaction_time_type_selector.dart';

class TransactionFormState {
  // For transfer: source and destination wallets
  // For transfer: source and destination wallets or budgets
  final ValueNotifier<AccountOrBudget?> selectedSourceAccountOrBudget;
  final ValueNotifier<AccountOrBudget?> selectedDestinationAccountOrBudget;
  final ValueNotifier<WalletModel?> selectedSourceWallet;
  final ValueNotifier<WalletModel?> selectedDestinationWallet;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController categoryController;
  final ValueNotifier<TransactionType> selectedTransactionType;
  final ValueNotifier<CategoryModel?> selectedCategory;
  final String defaultCurrency;
  final bool isEditing;
  final TransactionModel?
  initialTransaction; // The resolved transaction data for editing

  // Thêm state cho loại thời gian khi là thu nhập
  final ValueNotifier<TransactionTimeType> selectedTimeType;
  // Nếu chọn custom thì lưu khoảng thời gian
  final ValueNotifier<DateTimeRange?> customDateRange;

  TransactionFormState({
    required this.titleController,
    required this.amountController,
    required this.notesController,
    required this.categoryController,
    required this.selectedTransactionType,
    required this.selectedCategory,
    required this.defaultCurrency,
    required this.isEditing,
    this.initialTransaction,
    required this.selectedTimeType,
    required this.customDateRange,
    required this.selectedSourceWallet,
    required this.selectedDestinationWallet,
    required this.selectedSourceAccountOrBudget,
    required this.selectedDestinationAccountOrBudget,
  });

  String getCategoryText() {
    final cat = selectedCategory.value;
    if (cat == null) return '';
    String hint = cat.title;
    if (cat.subCategories?.isNotEmpty == true &&
        cat.subCategories!.first.title.isNotEmpty) {
      hint += ' • ${cat.subCategories!.first.title}';
    }
    return hint;
  }

  Future<void> saveTransaction(WidgetRef ref, BuildContext context) async {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        (selectedTransactionType.value != TransactionType.transfer && selectedCategory.value == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      print('[DEBUG][FORM] return early: missing required fields');
      return;
    }

    // Nếu là chuyển khoản, kiểm tra nguồn và đích
    if (selectedTransactionType.value == TransactionType.transfer) {
      if (selectedSourceAccountOrBudget.value == null || selectedDestinationAccountOrBudget.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn nguồn và nơi nhận (ví hoặc ngân sách).')),
        );
        print('[DEBUG][FORM] return early: missing source/destination for transfer');
        return;
      }
    }

    final db = ref.read(databaseProvider);
    final dateFromPicker = ref.read(datePickerProvider);
    final imagePickerState = ref.read(imageProvider);
    final activeWallet = ref.read(activeWalletProvider).valueOrNull;

    if (activeWallet == null || activeWallet.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active wallet selected.')),
      );
      print('[DEBUG][FORM] No active wallet selected, return early');
      return;
    }

    final isTransfer = selectedTransactionType.value == TransactionType.transfer;
    final sourceAccount = selectedSourceAccountOrBudget.value;
    final destinationAccount = selectedDestinationAccountOrBudget.value;
    final amount = amountController.text.takeNumericAsDouble();

    // Nếu là transfer, tạo category tạm thời
    final transferCategory = CategoryModel(
      id: -1,
      title: 'Transfer',
      iconName: 'swap_horiz',
      categoryType: CategoryType.transfer,
    );
    final transactionToSave = TransactionModel(
      id: isEditing ? initialTransaction?.id : null,
      transactionType: selectedTransactionType.value,
      amount: amount,
      date: dateFromPicker,
      title: titleController.text,
      category: isTransfer ? transferCategory : selectedCategory.value!,
      wallet: isTransfer
          ? (sourceAccount?.isWallet == true ? sourceAccount!.wallet! : null)
          : activeWallet,
      fromBudgetId: isTransfer && sourceAccount?.isBudget == true ? sourceAccount!.budget!.id : null,
      toBudgetId: isTransfer && destinationAccount?.isBudget == true ? destinationAccount!.budget!.id : null,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
      imagePath: imagePickerState.imageFile?.path,
      isRecurring: false,
    );

    Log.d(
      transactionToSave.toJson(),
      label: isEditing ? 'Updating transaction' : 'Saving new transaction',
    );

    try {
      print('[DEBUG][FORM] Gọi addTransaction với: ' + transactionToSave.toJson().toString());
      int? savedTransactionId;
      if (!isEditing) {
        savedTransactionId = await db.transactionDao.addTransaction(transactionToSave);
      } else {
        if (transactionToSave.id == null) {
          Log.e('Error: Attempting to update transaction without an ID.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error updating transaction: Missing ID.'),
            ),
          );
          return;
        }
        await db.transactionDao.updateTransaction(transactionToSave);
        savedTransactionId = transactionToSave.id;
      }
      if (savedTransactionId != null) {
        final sourceWallet = selectedSourceAccountOrBudget.value?.wallet;
        final destinationWallet = selectedDestinationAccountOrBudget.value?.wallet;
        final sourceBudget = selectedSourceAccountOrBudget.value?.budget;
        final destinationBudget = selectedDestinationAccountOrBudget.value?.budget;
        if (isTransfer) {
          // Cập nhật ví nếu là ví
          if (sourceWallet != null) {
            final newSourceBalance = sourceWallet.balance - amount;
            await db.walletDao.updateWallet(sourceWallet.copyWith(balance: newSourceBalance));
          }
          if (destinationWallet != null) {
            final newDestBalance = destinationWallet.balance + amount;
            await db.walletDao.updateWallet(destinationWallet.copyWith(balance: newDestBalance));
          }
          // Cập nhật ngân sách nếu là ngân sách
          // ENVELOPE LOGIC: Cập nhật currentBalance khi chuyển tiền vào hoặc chi tiêu từ ngân sách
          // 1. Nếu chuyển tiền vào ngân sách (destinationBudget): cộng amount vào currentBalance
          if (destinationBudget != null) {
            await db.budgetDao.updateBudgetBalance(destinationBudget.id, amount);
          }
          // 2. Nếu chuyển tiền/chi tiêu từ ngân sách (sourceBudget): trừ amount khỏi currentBalance
          if (sourceBudget != null) {
            await db.budgetDao.updateBudgetBalance(sourceBudget.id, -amount);
            // Nếu là chi tiêu, vẫn cập nhật usedAmount như cũ
            if (transactionToSave.transactionType == TransactionType.expense) {
              final newUsedAmount = (sourceBudget.usedAmount ?? 0) + amount;
              await db.budgetDao.updateBudgetUsedAmount(sourceBudget.id, newUsedAmount);
            }
          }
        } else {
          double newBalance = activeWallet.balance;
          if (transactionToSave.transactionType == TransactionType.income) {
            newBalance += transactionToSave.amount;
          } else if (transactionToSave.transactionType == TransactionType.expense) {
            newBalance -= transactionToSave.amount;
          }
          final updatedWallet = activeWallet.copyWith(balance: newBalance);
          await db.walletDao.updateWallet(updatedWallet);
          // Refresh the active wallet provider to reflect the new balance
          ref.read(activeWalletProvider.notifier).setActiveWallet(updatedWallet);
          Log.d('Wallet balance updated for ${activeWallet.name}. New balance: $newBalance');
        }
      }
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      Log.e('Error saving transaction: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save transaction: $e')),
        );
      }
    }
  }

  void dispose() {
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    categoryController.dispose();
    selectedTransactionType.dispose();
    selectedCategory.dispose();
  }
}


TransactionFormState useTransactionFormState({
  required WidgetRef ref,
  required String defaultCurrency,
  required bool isEditing,
  TransactionModel?
  transaction, // Pass the resolved transaction data for editing
}) {
  final titleController = useTextEditingController(
    text: isEditing ? transaction?.title : '',
  );
  final amountController = useTextEditingController(
    text: isEditing && transaction != null
        ? '$defaultCurrency ${transaction.amount.toDouble().toPriceFormat()}'
        : '',
  );
  final notesController = useTextEditingController(
    text: isEditing ? transaction?.notes ?? '' : '',
  );
  final categoryController = useTextEditingController(
    text: isEditing && transaction != null ? transaction.category.title : '',
  );
  final selectedTransactionType = useState<TransactionType>(
    isEditing && transaction != null ? transaction.transactionType : TransactionType.expense,
  );
  final selectedCategory = useState<CategoryModel?>(
    isEditing && transaction != null && transaction.transactionType != TransactionType.transfer
        ? transaction.category
        : null,
  );
  final selectedTimeType = useState<TransactionTimeType>(TransactionTimeType.day);
  final customDateRange = useState<DateTimeRange?>(null);
  final selectedSourceAccountOrBudget = useState<AccountOrBudget?>(null);
  final selectedDestinationAccountOrBudget = useState<AccountOrBudget?>(null);
  // Legacy wallet-only selectors, kept for backward compatibility
  final selectedSourceWallet = useState<WalletModel?>(null);
  final selectedDestinationWallet = useState<WalletModel?>(null);

  final formState = useMemoized(
    () => TransactionFormState(
      titleController: titleController,
      amountController: amountController,
      notesController: notesController,
      categoryController: categoryController,
      selectedTransactionType: selectedTransactionType,
      selectedCategory: selectedCategory,
      defaultCurrency: defaultCurrency,
      isEditing: isEditing,
      initialTransaction: transaction,
      selectedTimeType: selectedTimeType,
      customDateRange: customDateRange,
      selectedSourceWallet: selectedSourceWallet,
      selectedDestinationWallet: selectedDestinationWallet,
      selectedSourceAccountOrBudget: selectedSourceAccountOrBudget,
      selectedDestinationAccountOrBudget: selectedDestinationAccountOrBudget,
    ),
    [defaultCurrency, isEditing, transaction],
  );

  useEffect(
    () {
      void initializeForm() {
        if (isEditing && transaction != null) {
          // Controllers are initialized with text in their declaration if transaction is available.
          // If transaction was initially null (e.g., during loading) and then becomes available,
          // we need to update them here.
          if (titleController.text != transaction.title) {
            titleController.text = transaction.title;
          }
          if (amountController.text !=
              '$defaultCurrency ${transaction.amount.toDouble().toPriceFormat()}') {
            amountController.text =
                '$defaultCurrency ${transaction.amount.toDouble().toPriceFormat()}';
          }
          if (notesController.text != (transaction.notes ?? '')) {
            notesController.text = transaction.notes ?? '';
          }
          if (selectedTransactionType.value != transaction.transactionType) {
            selectedTransactionType.value = transaction.transactionType;
          }
          if (selectedCategory.value != transaction.category) {
            selectedCategory.value = transaction.category;
          }
          // categoryController.text is handled by another useEffect based on selectedCategory

          // final imagePath = transaction.imagePath;
          // if (imagePath != null && imagePath.isNotEmpty) {
          //   Future.microtask(
          //     () => ref.read(imageProvider.notifier).loadImagePath(imagePath),
          //   );
          // } else {
          //   Future.microtask(
          //     () => ref.read(imageProvider.notifier).clearImage(),
          //   );
          // }
        } else if (!isEditing) {
          // Only reset for new, not if transaction is just null during edit loading
          titleController.clear();
          amountController.clear();
          notesController.clear();
          selectedTransactionType.value = TransactionType.expense;
          selectedCategory.value = null;
          // Future.microtask(() => ref.read(imageProvider.notifier).clearImage());
        }
        // categoryController text is updated by the separate effect below
      }

      initializeForm();
      // No need to return formState.dispose here if we want the hook's lifecycle
      // to be tied to the widget using it. The controllers are disposed by useTextEditingController.
      // ValueNotifiers from useState are also handled.
      // If formState.dispose did more, we'd return it.
      return null;
    },
    [
      isEditing,
      transaction,
      defaultCurrency,
      ref,
      titleController,
      amountController,
      notesController,
      selectedTransactionType,
      selectedCategory,
    ],
  );

  useEffect(
    () {
      categoryController.text = formState.getCategoryText();
      return null;
    },
    [selectedCategory.value, formState],
  ); // formState is stable due to useMemoized

  // The main dispose for controllers created by useTextEditingController
  // and ValueNotifiers from useState is handled automatically by flutter_hooks.
  // The custom `formState.dispose()` might be redundant if it only disposes these.
  // If it has other specific cleanup, it should be called.
  // For now, assuming standard hook cleanup is sufficient.

  return formState;
}
