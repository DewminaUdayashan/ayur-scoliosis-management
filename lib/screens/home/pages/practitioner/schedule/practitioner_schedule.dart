import 'package:ayur_scoliosis_management/screens/home/pages/practitioner/schedule/widgets/practitioner_appointment_card.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/practitioner/schedule/widgets/practitioner_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme.dart';
import '../../../../../core/theme.dart';
import '../../../../../providers/appointment/appointments.dart';
import '../../../../../widgets/skeleton.dart';
import '../../../../../widgets/sliver_sized_box.dart';
import 'widgets/add_appointment_sheet.dart';

class PractitionerSchedule extends HookConsumerWidget {
  const PractitionerSchedule({super.key});

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
      // Use Scaffold for a standard layout structure.
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () {
                    // TODO: Implement navigation
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Schedule',
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

              // Sliver that contains the main content.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // --- CALENDAR CARD ---
                      PractitionerCalendar(
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
                                return PractitionerAppointmentCard(
                                  appointment: appointments[index],
                                );
                              },
                            );
                          }
                        },
                        error: (_, __) => const Center(
                          child: Text('Error loading appointments'),
                        ),
                        loading: () => Skeleton(
                          builder: (decoration) =>
                              Container(decoration: decoration),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverSizedBox(height: 100),
            ],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  // This makes the sheet scrollable and avoids keyboard overlap
                  isScrollControlled: true,
                  // Use a transparent background to see the rounded corners
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: const AddAppointmentSheet(),
                    );
                  },
                );
              },
              backgroundColor: AppTheme.accent,
              child: const Icon(CupertinoIcons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
