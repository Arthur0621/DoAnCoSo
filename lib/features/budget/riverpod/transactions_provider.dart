import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/core/database/daos/transaction_dao.dart';
import 'package:moneynest/core/di/di.dart';

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionDao(db);
});

final transactionsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(transactionDaoProvider).watchAllTransactionsWithDetails();
});
