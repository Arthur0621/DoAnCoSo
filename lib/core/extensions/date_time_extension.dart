import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Format: 13 March 2025
  String toDayMonthYear() {
    return DateFormat("d MMMM yyyy", "vi").format(this);
  }

  /// Format: 12 Nov 2024
  String toDayShortMonthYear() {
    return DateFormat("d MMM yyyy", "vi").format(this);
  }

  /// Format: March 13, 2025
  String toMonthDayYear() {
    return DateFormat("MMMM d, yyyy", "vi").format(this);
  }

  /// Format: 13/03/2025
  String toDayMonthYearNumeric() {
    return DateFormat("dd/MM/yyyy", "vi").format(this);
  }

  /// Format: 03/2025
  String toMonthYearNumeric() {
    return DateFormat("MM/yyyy", "vi").format(this);
  }

  /// Returns "Today", "Yesterday" if applicable, otherwise "13 March 2025".
  /// Compares `this` date to the current date.
  String toRelativeDayFormatted() {
    final now = DateTime.now();
    // Normalize 'this' (the date instance) and 'now' to midnight for accurate day difference
    final thisDateAtMidnight = DateTime(year, month, day);
    final nowDateAtMidnight = DateTime(now.year, now.month, now.day);

    final differenceInDays = nowDateAtMidnight
        .difference(thisDateAtMidnight)
        .inDays;

    if (differenceInDays == 0) {
      return "Hôm nay"; // thisDateAtMidnight is today
    }
    if (differenceInDays == 1) {
      return "Hôm qua"; // thisDateAtMidnight was yesterday
    }
    // For other dates (further in the past or future if transactions could be future-dated)
    return toDayMonthYear(); // Default format: "13 March 2025"
  }

  /// Returns "This Month", "Last Month", or "Oct 2024" for tab labels.
  /// Compares `this` month to the `currentDate` month.
  String toMonthTabLabel(DateTime currentDate) {
    final thisMonthStart = DateTime(year, month, 1);
    final currentMonthStart = DateTime(currentDate.year, currentDate.month, 1);
    final lastMonthStart = DateTime(currentDate.year, currentDate.month - 1, 1);

    if (thisMonthStart.year == currentMonthStart.year &&
        thisMonthStart.month == currentMonthStart.month) {
      return "Tháng này";
    }
    if (thisMonthStart.year == lastMonthStart.year &&
        thisMonthStart.month == lastMonthStart.month) {
      return "Tháng trước";
    }
    return DateFormat("MMM yyyy").format(this); // e.g., "Oct 2024"
  }

  /// Format: 13 March 2025 05.44 am / 13 March 2025 05.44 pm
  String toDayMonthYearTime12Hour() {
    return DateFormat("d MMMM yyyy hh.mm a", "vi").format(this);
  }

  /// Format: 13 March 2025 17.44
  String toDayMonthYearTime24Hour() {
    return DateFormat("d MMMM yyyy HH.mm", "vi").format(this);
  }
}
