import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/database/tables/goal_table.dart';
import 'package:moneynest/features/goal/data/model/checklist_item_model.dart';

@DataClassName('ChecklistItem')
class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real().nullable()();
  TextColumn get link => text().nullable()();
  BoolColumn get completed => boolean().nullable()();
}

extension ChecklistItemTableExtensions on ChecklistItem {
  /// Converts this Drift [ChecklistItem] data class to a [ChecklistItemModel].
  ChecklistItemModel toModel() {
    return ChecklistItemModel(
      id: id,
      goalId: goalId,
      title: title,
      amount: amount ?? 0.0,
      link: link ?? '',
      completed: completed ?? false,
    );
  }
}
