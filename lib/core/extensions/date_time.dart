import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get readableTimeAndDate {
    final timePart = DateFormat('h:mm a').format(toLocal());
    final datePart = DateFormat('MMMM d, yyyy').format(toLocal());
    return '$timePart - $datePart';
  }

  String get yMMMMd => DateFormat.yMMMMd().format(toLocal());

  String get yMd => DateFormat.yMd().format(toLocal());

  String get jm => DateFormat.jm().format(toLocal());
}
