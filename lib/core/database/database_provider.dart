import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/database/moneynest_database.dart';

/// A singleton AppDatabase for the whole app
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
