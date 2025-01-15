import 'package:intl/intl.dart';

String formatDate(l,DateTime date) {
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));
  DateTime twoDaysAgo = now.subtract(const Duration(days: 2));
  DateTime lastWeek = now.subtract(Duration(days: now.weekday));
  DateTime twoWeeksAgo = now.subtract(Duration(days: now.weekday + 7));
  DateTime threeWeeksAgo = now.subtract(Duration(days: now.weekday + 14));
  
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return "${l.s80} ${DateFormat('dd.MM').format(date)}";
  } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
    return "${l.s81} ${DateFormat('dd.MM').format(date)}";
  } else if (date.isAfter(twoDaysAgo)) {
    int daysAgo = now.difference(date).inDays;
    return "$daysAgo ${l.s82} ${DateFormat('dd.MM').format(date)}";
  } else if (date.isAfter(lastWeek)) {
    return "${l.s83} ${DateFormat('dd.MM').format(date)}";
  } else if (date.isAfter(twoWeeksAgo)) {
    int weeksAgo = now.difference(date).inDays ~/ 7;
    return "$weeksAgo ${l.s84} ${DateFormat('dd.MM').format(date)}";
  } else if (date.isAfter(threeWeeksAgo)) {
    return "3 ${l.s84} ${DateFormat('dd.MM').format(date)}";
  } else {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}