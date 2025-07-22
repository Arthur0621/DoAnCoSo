import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';
import 'transaction_providers.dart';

/// Provider that emits the total expenses for the current month for the active wallet.
final currentMonthExpenseProvider = StreamProvider.autoDispose<double>((ref) {
  final transactionsAsync = ref.watch(transactionListProvider);

  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month);
      final nextMonth = DateTime(now.year, now.month + 1);
      final currentMonthExpenses = transactions.where((tx) {
        return tx.transactionType == TransactionType.expense &&
          tx.date.isAfter(thisMonth.subtract(const Duration(seconds: 1))) &&
          tx.date.isBefore(nextMonth);
      }).fold<double>(0, (sum, tx) => sum + tx.amount);
      return Stream.value(currentMonthExpenses);
    },
    loading: () => Stream.value(0),
    error: (e, s) => Stream.value(0),
  );
});
