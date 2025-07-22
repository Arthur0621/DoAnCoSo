import 'package:drift/drift.dart';
import 'package:moneynest/core/database/moneynest_database.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';

// Define tables
@DataClassName('Category')
class Categories extends Table {
  /// Loại danh mục: 0=income, 1=expense, 2=transfer
  IntColumn get categoryType => integer().withDefault(const Constant(1))(); // 1=expense
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get iconName => text().nullable()();
  IntColumn get parentId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();
  TextColumn get description => text().nullable()();
// Thêm trường categoryType bên dưới
}

extension CategoryTableExtensions on Category {
  /// Converts this Drift [Category] data class to a [CategoryModel].
  ///
  /// Note: The `subCategories` field in [CategoryModel] is not populated
  /// by this direct conversion as the Drift [Category] object doesn't
  /// inherently store its children. Fetching and assembling sub-categories
  /// is typically handled at a higher layer (e.g., a repository or service)
  /// that can query for children based on `parentId`.
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      title: title,
      iconName: iconName ?? '',
      parentId: parentId,
      description: description,
      // subCategories are not directly available on the Drift Category object.
      // This needs to be populated by querying children if needed.
      subCategories: null,
      categoryType: CategoryType.values[categoryType],
    );
  }
}
