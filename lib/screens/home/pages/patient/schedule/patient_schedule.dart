import 'package:ayur_scoliosis_management/core/constants/size.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointments.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/patient/schedule/widgets/patient_calendar.dart';
import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme.dart';
import 'widgets/patient_appointment_card.dart';

class PatientSchedule extends HookConsumerWidget {
  const PatientSchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = useMemoized(() => DateTime.now());
    final selectedDay = useState(DateTime(now.year, now.month, now.day));
    final appointmentsAsync = ref.watch(
      appointmentsProvider(
        startDate: selectedDay.value,
        endDate: selectedDay.value.add(Duration(days: 1)),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: horizontalPadding,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              title: Text(
                'My Schedule',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // --- CALENDAR CARD ---
                  PatientCalendar(
                    onDaySelected: (day) {
                      selectedDay.value = day;
                    },
                  ),
                  const SizedBox(height: 30),
                  // --- APPOINTMENTS HEADER ---
                  Text(
                    'Appointments for ${DateFormat.yMMMMd().format(selectedDay.value)}',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  appointmentsAsync.when(
                    data: (data) {
                      final appointments = data
                          .map((page) => page.data)
                          .toList()
                          .expand((x) => x)
                          .toList();
                      if (appointments.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: const Center(
                            child: Text('No appointments for this day.'),
                          ),
                        );
                      } else {
                        return ListView.separated(
                          padding: const EdgeInsets.only(top: 20),
                          itemCount: appointments.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return PatientAppointmentCard(
                              appointment: appointments[index],
                            );
                          },
                        );
                      }
                    },
                    error: (_, __) =>
                        const Center(child: Text('Error loading appointments')),
                    loading: () => Skeleton(
                      builder: (decoration) =>
                          Container(decoration: decoration),
                    ),
                  ),
                  // --- APPOINTMENTS LIST ---
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
