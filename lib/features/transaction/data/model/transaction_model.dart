import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    int? id,
    required TransactionType transactionType,
    required double amount,
    required DateTime date,
    required String title,
    required CategoryModel category,
    required WalletModel? wallet,
    int? fromBudgetId,
    int? toBudgetId,
    String? notes,
    String? imagePath,
    bool? isRecurring,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

// Đặt enum SAU class!
enum TransactionType { income, expense, transfer }
extension TransactionList on List<TransactionModel> {
  double get totalIncome {
    double total = 0;
    for (var transaction in this) {
      if (transaction.transactionType == TransactionType.income) {
        total += transaction.amount;
      }
    }
    return total;
  }

  double get totalExpenses {
    double total = 0;
    for (var transaction in this) {
      if (transaction.transactionType == TransactionType.expense) {
        total += transaction.amount;
      }
    }
    return total;
  }

  double get total {
    return totalIncome - totalExpenses;
  }
}