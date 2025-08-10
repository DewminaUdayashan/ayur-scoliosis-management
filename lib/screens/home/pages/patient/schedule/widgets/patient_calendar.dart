import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/core/utils/logger.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../providers/profile/profile.dart';

class PatientCalendar extends HookConsumerWidget {
  const PatientCalendar({super.key, required this.onDaySelected});
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;
    final joinedDate = profile?.joinedDate;

    // --- STATE MANAGEMENT ---
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState(DateTime.now());

    // Date range for current focused month
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);

    // Watch appointment dates provider
    final appointmentDatesAsync = ref.watch(
      appointmentDatesProvider(startDate.value, endDate.value),
    );

    // Function to calculate month's first and last day
    void updateDateRange(DateTime focusedDay) {
      final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
      final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);

      startDate.value = firstDay;
      endDate.value = lastDay;

      Log.i('Updated date range: ${firstDay.yMMMMd} to ${lastDay.yMMMMd}');
    }

    // Initialize date range on first build
    useEffect(() {
      updateDateRange(focusedDay.value);
      return null;
    }, []);

    // Convert appointment dates to a set for faster lookup
    final appointmentDays =
        appointmentDatesAsync.whenOrNull(data: (dates) => dates.toSet()) ??
        <DateTime>{};

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
        firstDay:
            joinedDate ?? DateTime.now().subtract(Duration(days: 365 * 10)),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay.value,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
        onDaySelected: (newSelectedDay, newFocusedDay) {
          selectedDay.value = newSelectedDay;
          focusedDay.value = newFocusedDay;
          onDaySelected(newSelectedDay);
        },
        onPageChanged: (newFocusedDay) {
          focusedDay.value = newFocusedDay;
          updateDateRange(newFocusedDay);
          Log.i('Calendar page changed to: ${newFocusedDay.yMMMMd}');
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
          // Check if the day has appointments
          final dayHasAppointment = appointmentDays.any(
            (appointmentDate) => isSameDay(appointmentDate, day),
          );
          return dayHasAppointment ? ['appointment'] : [];
        },
      ),
    );
  }
}
