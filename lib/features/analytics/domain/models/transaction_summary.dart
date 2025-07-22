import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_summary.freezed.dart';
part 'transaction_summary.g.dart';

@freezed
class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    required double income,           // Tổng thu
    required double expense,          // Tổng chi
    required DateTime date,           // Ngày
    @Default(0) int transactionCount, // Số giao dịch
  }) = _TransactionSummary;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) => 
      _$TransactionSummaryFromJson(json);
}