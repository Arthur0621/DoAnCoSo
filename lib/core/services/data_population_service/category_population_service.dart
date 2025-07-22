import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/category/data/repositories/category_repo.dart'
    as category_repo; // Use an alias

class CategoryPopulationService {
  final AppDatabase _db;

  CategoryPopulationService(this._db);

  Future<void> populateDefaultCategories() async {
    Log.i('Initializing default categories...');
    final allDefaultCategories = category_repo.categories.getAllCategories();
    final categoryDao = _db.categoryDao;

    for (final categoryModel in allDefaultCategories) {
      final companion = CategoriesCompanion(
        id: Value(categoryModel.id!),
        title: Value(categoryModel.title),
        iconName: Value(categoryModel.iconName),
        parentId: categoryModel.parentId == null
            ? const Value.absent()
            : Value(categoryModel.parentId),
        description: categoryModel.description == null ||
                categoryModel.description!.isEmpty
            ? const Value.absent()
            : Value(categoryModel.description!),
      );
      try {
        await categoryDao.upsertCategory(companion);
      } catch (e) {
        Log.e('Failed to upsert category ${categoryModel.title}: $e');
      }
    }

    Log.i(
      'Default categories initialization complete. (${allDefaultCategories.length} total categories processed)',
    );
  }
}
