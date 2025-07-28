import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class PatientCalendar extends HookConsumerWidget {
  const PatientCalendar({super.key, required this.onDaySelected});
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- STATE MANAGEMENT ---
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay.value,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
        onDaySelected: (newSelectedDay, newFocusedDay) {
          selectedDay.value = newSelectedDay;
          focusedDay.value = newFocusedDay;
          onDaySelected(newSelectedDay);
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppTheme.accent,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(30),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(70),
            shape: BoxShape.circle,
          ),
        ),
        eventLoader: (day) {
          if (day.day == 28 || day.day == 21) {
            // Dummy event days
            return ['event'];
          }
          return [];
        },
      ),
    );
  }
}
