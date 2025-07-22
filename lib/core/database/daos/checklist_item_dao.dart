import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/database/tables/checklist_item_table.dart';
import 'package:moneynest/core/utils/logger.dart';

part 'checklist_item_dao.g.dart';

@DriftAccessor(tables: [ChecklistItems])
class ChecklistItemDao extends DatabaseAccessor<AppDatabase> with _$ChecklistItemDaoMixin {
  final AppDatabase db;
  
  // Table reference
  late final checklistItems = db.checklistItems;

  ChecklistItemDao(this.db) : super(db);

  /// Inserts a new ChecklistItem, returns its auto-incremented ID
  Future<int> addChecklistItem(ChecklistItemsCompanion entry) async {
    Log.d('📝  addChecklistItem → ${entry.toString()}');
    final id = await into(checklistItems).insert(entry);
    Log.d('✔️  ChecklistItem inserted with id=$id');
    return id;
  }

  /// Streams all checklist items for a specific goal
  Stream<List<ChecklistItem>> watchChecklistItemsForGoal(int goalId) {
    Log.d('🔍  Subscribing to watchChecklistItemsForGoal($goalId)');
    return (select(checklistItems)
      ..where((tbl) => tbl.goalId.equals(goalId))).watch();
  }

  /// Updates an existing checklist item
  Future<bool> updateChecklistItem(ChecklistItem item) async {
    Log.d('✏️  updateChecklistItem → ${item.toString()}');
    final success = await update(checklistItems).replace(item);
    Log.d('✔️  updateChecklistItem success=$success');
    return success;
  }

  /// Deletes a checklist item by its ID
  Future<int> deleteChecklistItem(int id) async {
    Log.d('🗑️  deleteChecklistItem → id=$id');
    final count = await (delete(checklistItems)
      ..where((t) => t.id.equals(id))).go();
    Log.d('✔️  deleteChecklistItem deleted $count row(s)');
    return count;
  }
}
