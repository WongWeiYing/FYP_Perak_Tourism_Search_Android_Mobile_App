import 'package:cloud_firestore/cloud_firestore.dart';

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatDate(DateTime date) {
  DateTime now = DateTime.now();
  if (isSameDay(date, now)) {
    return 'Today';
  } else {
    return '${monthName(date.month)} ${date.day}, ${date.year}';
  }
}

String monthName(int month) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month];
}

String formatTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate();
  int hour = date.hour;
  int minute = date.minute;
  String ampm = hour >= 12 ? 'PM' : 'AM';

  hour = hour % 12;
  if (hour == 0) hour = 12;

  return '$hour:${minute.toString().padLeft(2, '0')} $ampm';
}
