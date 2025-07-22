import 'package:flutter/material.dart';

enum TimeRangeFilter {
  day,    // Ngày
  week,   // Tuần
  month,  // Tháng
  year,   // Năm
  custom  // Tùy chỉnh
}

extension TimeRangeFilterExtension on TimeRangeFilter {
  DateTimeRange getDateRange() {
    final now = DateTime.now();
    switch (this) {
      case TimeRangeFilter.day:
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: now,
        );
      case TimeRangeFilter.week:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        );
      case TimeRangeFilter.month:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
      case TimeRangeFilter.year:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: now,
        );
      case TimeRangeFilter.custom:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
    }
  }
}