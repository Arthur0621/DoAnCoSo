// lib/core/di/di.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneynest/core/database/moneynest_database.dart';

// Thay đổi provider thành:
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});