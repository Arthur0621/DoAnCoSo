import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moneynest/core/database/daos/category_dao.dart';
import 'package:moneynest/core/database/daos/transaction_dao.dart';
import 'package:moneynest/core/database/daos/wallet_dao.dart';
import 'package:moneynest/core/database/tables/category_table.dart';
import 'package:moneynest/core/database/tables/transaction_table.dart';
import 'package:moneynest/core/database/tables/wallet_table.dart';
import 'package:moneynest/core/services/data_population_service/category_population_service.dart';
import 'package:moneynest/core/services/data_population_service/wallet_population_service.dart';
import 'package:moneynest/core/utils/logger.dart';

part 'moneynest_database.g.dart';

@DriftDatabase(
  tables: [Categories, Transactions, Wallets],
  daos: [CategoryDao, TransactionDao, WalletDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 8; // Tăng schema version lên 1 đơn vị

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _populateDatabase(this);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Thêm logic nâng cấp nếu cần
        if (from < 8) {
          // Xóa các bảng cũ nếu cần
          await m.deleteTable('goals');
          await m.deleteTable('checklist_items');
        }
      },
    );
  }

  static Future<void> _populateDatabase(AppDatabase db) async {
    await CategoryPopulationService(db).populateDefaultCategories();
    await WalletPopulationService(db).populateDefaultWallets();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'moneynest.sqlite'));
    
    if (kDebugMode) {
      Log.d('Database path: ${file.path}');
    }
    
    return NativeDatabase.createInBackground(file);
  });
}
