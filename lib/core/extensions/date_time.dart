import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get readableTimeAndDate {
    final timePart = DateFormat('h:mm a').format(this);
    final datePart = DateFormat('MMMM d, yyyy').format(this);
    return '$timePart - $datePart';
  }
}
