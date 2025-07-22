import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/database/tables/category_table.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/core/database/tables/transaction_table.dart';
import 'package:moneynest/core/database/tables/wallet_table.dart'; // Import WalletTable
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/transaction/data/model/transaction_model.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(
  tables: [Transactions, Categories, Wallets], // Add Wallets table
)
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  final AppDatabase db;
  
  // Table references
  late final transactions = db.transactions;
  late final categories = db.categories;
  late final wallets = db.wallets;

  TransactionDao(this.db) : super(db);

  /// Helper to convert a database row (Transaction, Category, Wallet) to a TransactionModel.
  Future<TransactionModel> _mapToTransactionModel(
    Transaction transactionData,
    Category? categoryData,
    Wallet? walletData,
  ) async {
    // Nếu categoryData null thì tạo CategoryModel đặc biệt (ví dụ "Chuyển khoản"), hoặc để null nếu TransactionModel cho phép
    final categoryModel = categoryData != null
        ? categoryData.toModel()
        : CategoryModel(
            id: -1,
            title: 'Chuyển khoản',
            categoryType: CategoryType.transfer,
            iconName: 'HugeIcons.strokeRoundedTransfer',
            description: 'Giao dịch chuyển khoản',
          );
    // Nếu walletData null thì để null
    final walletModel = walletData != null ? walletData.toModel() : null;
    return TransactionModel(
      id: transactionData.id,
      transactionType: TransactionType.values.firstWhere(
        (e) => e.toDbValue() == transactionData.transactionType,
        orElse: () => TransactionType.expense,
      ),
      amount: transactionData.amount,
      date: transactionData.date,
      title: transactionData.title,
      category: categoryModel,
      wallet: walletModel,
      notes: transactionData.notes,
      imagePath: transactionData.imagePath,
      isRecurring: transactionData.isRecurring,
      fromBudgetId: transactionData.fromBudgetId,
      toBudgetId: transactionData.toBudgetId,
    );
  }

  /// Streams all transactions; logs each emission
  Future<List<Transaction>> getAllTransactions() {
    Log.d('🔍  Subscribing to getAllTransactions()');
    return select(transactions).get();
  }

  /// Streams all transactions; logs each emission
  Stream<List<Transaction>> watchAllTransactions() {
    Log.d('🔍  Subscribing to watchAllTransactions()');
    return select(transactions).watch().map((list) {
      Log.d('📋  watchAllTransactions emitted ${list.length} rows');
      return list;
    });
  }

  /// Streams single transaction;
  Stream<Transaction> watchTransactionByID(int id) {
    Log.d('🔍  Subscribing to watchTransactionByID($id)');
    return (select(transactions)..where((g) => g.id.equals(id))).watchSingle();
  }

  /// Watches all transactions with their associated category and wallet details.
  Stream<List<TransactionModel>> watchAllTransactionsWithDetails() {
    final query = select(transactions).join([
      leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
    ])
      ..orderBy([
        OrderingTerm(expression: transactions.date, mode: OrderingMode.desc),
        OrderingTerm(expression: transactions.id, mode: OrderingMode.desc),
      ]);

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTableOrNull(categories);
        final walletData = row.readTableOrNull(wallets);
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            walletData,
          ),
        );
      }
      return result;
    });
  }

  /// Watches all transactions for a specific wallet with their associated category and wallet details.
  Stream<List<TransactionModel>> watchTransactionsByWalletIdWithDetails(
    int walletId,
  ) {
    Log.d(
      '🔍 Subscribing to watchTransactionsByWalletIdWithDetails($walletId)',
    );
    final query = select(transactions).join([
      leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
    ])
      ..where(transactions.walletId.equals(walletId))
      ..orderBy([
        OrderingTerm(expression: transactions.date, mode: OrderingMode.desc),
        OrderingTerm(expression: transactions.id, mode: OrderingMode.desc),
      ]); // Sắp xếp mới nhất lên đầu

    return query.watch().asyncMap((rows) async {
      final result = <TransactionModel>[];
      for (final row in rows) {
        final transactionData = row.readTable(transactions);
        final categoryData = row.readTableOrNull(categories);
        final walletData = row.readTableOrNull(wallets);
        result.add(
          await _mapToTransactionModel(
            transactionData,
            categoryData,
            walletData,
          ),
        );
      }
      // Log toàn bộ transaction lấy được
      print('[DEBUG][DAO] watchTransactionsByWalletIdWithDetails emitted:');
      for (final tx in result) {
        print('  - id: ${tx.id}, type: ${tx.transactionType}, amount: ${tx.amount}, walletId: ${tx.wallet?.id}, fromBudgetId: ${tx.fromBudgetId}, toBudgetId: ${tx.toBudgetId}');
      }
      return result;
    });
  }

  /// Inserts a new transaction.
  Future<int> addTransaction(TransactionModel transactionModel) async {
    Log.d('Saving New Transaction: ${transactionModel.toJson()}');
    final companion = TransactionsCompanion(
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: transactionModel.wallet != null ? Value(transactionModel.wallet!.id!) : const Value.absent(),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      fromBudgetId: transactionModel.fromBudgetId != null ? Value(transactionModel.fromBudgetId!) : const Value.absent(),
      toBudgetId: transactionModel.toBudgetId != null ? Value(transactionModel.toBudgetId!) : const Value.absent(),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    final id = await into(transactions).insert(companion);
    // Log toàn bộ bảng transactions sau khi insert
    final all = await (select(transactions)).get();
    print('[DEBUG][DAO] All transactions in DB:');
    for (final t in all) {
      print('  - id: ${t.id}, type: ${t.transactionType}, amount: ${t.amount}, walletId: ${t.walletId}, fromBudgetId: ${t.fromBudgetId}, toBudgetId: ${t.toBudgetId}');
    }
    return id;
  }

  /// Updates an existing transaction.
  Future<bool> updateTransaction(TransactionModel transactionModel) async {
    Log.d('Updating Transaction: ${transactionModel.toJson()}');
    final companion = TransactionsCompanion(
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: transactionModel.wallet != null ? Value(transactionModel.wallet!.id!) : const Value.absent(),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      fromBudgetId: transactionModel.fromBudgetId != null ? Value(transactionModel.fromBudgetId!) : const Value.absent(),
      toBudgetId: transactionModel.toBudgetId != null ? Value(transactionModel.toBudgetId!) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    return await update(transactions).replace(companion);
  }

  /// Deletes a transaction by its ID.
  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Upserts a transaction: inserts if new, updates if exists by ID.
  Future<void> upsertTransaction(TransactionModel transactionModel) {
    final companion = TransactionsCompanion(
      id: Value(transactionModel.id ?? 0),
      transactionType: Value(transactionModel.transactionType.toDbValue()),
      amount: Value(transactionModel.amount),
      date: Value(transactionModel.date),
      title: Value(transactionModel.title),
      categoryId: Value(transactionModel.category.id!),
      walletId: transactionModel.wallet != null ? Value(transactionModel.wallet!.id!) : const Value.absent(),
      notes: Value(transactionModel.notes),
      imagePath: Value(transactionModel.imagePath),
      isRecurring: Value(transactionModel.isRecurring),
      fromBudgetId: transactionModel.fromBudgetId != null ? Value(transactionModel.fromBudgetId!) : const Value.absent(),
      toBudgetId: transactionModel.toBudgetId != null ? Value(transactionModel.toBudgetId!) : const Value.absent(),
      // Let createdAt be handled by DB default on insert, updatedAt always changes
      updatedAt: Value(DateTime.now()),
    );
    return into(transactions).insertOnConflictUpdate(companion);
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = select(transactions)
      ..where((t) {
        return t.date.isBetween(
          Constant(DateTime(startDate.year, startDate.month, startDate.day)),
          Constant(DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)),
        );
      })
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    
    return await query.get();
    }
}
