import 'package:drift/drift.dart';

class Budgets extends Table {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer()();         // Ví nguồn
  IntColumn get categoryId => integer()();       // Danh mục
  RealColumn get amount => real()();             // Số tiền
  DateTimeColumn get startDate => dateTime()();  // Ngày bắt đầu
  DateTimeColumn get endDate => dateTime().nullable()();    // Ngày kết thúc (nullable)
  BoolColumn get isRecurring => boolean().withDefault(Constant(false))(); // Định kỳ
  RealColumn get usedAmount => real().withDefault(const Constant(0.0))(); // Số tiền đã sử dụng
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))(); // Số dư thực tế
}
