import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/database/tables/wallet_table.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  final AppDatabase db;
  
  // Table reference
  late final wallets = db.wallets;

  WalletDao(this.db) : super(db);

  Future<WalletModel> _mapToWalletModel(Wallet walletData) async {
    return walletData.toModel();
  }

  Stream<List<WalletModel>> watchAllWallets() {
    Log.d('🔍 Subscribing to watchAllWallets()');
    return select(wallets).watch().asyncMap((walletList) async {
      Log.d('📋 watchAllWallets emitted ${walletList.length} rows');
      return walletList.map((e) => e.toModel()).toList();
    });
  }

  Stream<WalletModel?> watchWalletById(int id) {
    Log.d('🔍 Subscribing to watchWalletById($id)');
    return (select(wallets)..where((w) => w.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((walletData) async {
          if (walletData == null) return null;
          return await _mapToWalletModel(walletData);
        });
  }

  Future<int> addWallet(WalletModel walletModel) async {
    Log.d('Saving New Wallet: ${walletModel.toJson()}');
    final companion = walletModel.toCompanion(isInsert: true);
    return await into(wallets).insert(companion);
  }

  Future<bool> updateWallet(WalletModel walletModel) async {
    Log.d('Updating Wallet: ${walletModel.toJson()}');
    if (walletModel.id == null) {
      Log.e('Wallet ID is null, cannot update.');
      return false;
    }
    final companion = walletModel.toCompanion();
    return await update(wallets).replace(companion);
  }

  Future<int> deleteWallet(int id) {
    return (delete(wallets)..where((w) => w.id.equals(id))).go();
  }

  Future<void> upsertWallet(WalletModel walletModel) async {
    Log.d('Upserting Wallet: ${walletModel.toJson()}');
    final companion = walletModel.toCompanion(
      isInsert: walletModel.id == null,
    );
    await into(wallets).insertOnConflictUpdate(companion);
  }

  Future<WalletModel?> getWalletById(int id) async {
    return (select(wallets)..where((w) => w.id.equals(id)))
        .getSingleOrNull()
        .then((wallet) => wallet?.toModel());
  }

  Future<void> updateWalletBalance(int id, double newBalance) async {
    await (update(wallets)..where((w) => w.id.equals(id))).write(
          WalletsCompanion(
            balance: Value(newBalance),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
