import 'package:ayur_scoliosis_management/core/constants/size.dart';
import 'package:ayur_scoliosis_management/screens/home/pages/patient/schedule/widgets/patient_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme.dart';
import '../../../../../core/theme.dart';
import '../../../../../gen/assets.gen.dart';

// Enum to manage the state of a patient's appointment
enum PatientAppointmentStatus { PendingConfirmation, Confirmed, Completed }

// Data model for a patient's appointment view
class _PatientAppointment {
  final String title;
  final String practitionerName;
  final String practitionerAvatarUrl;
  final DateTime dateTime;
  final PatientAppointmentStatus status;

  _PatientAppointment({
    required this.title,
    required this.practitionerName,
    required this.practitionerAvatarUrl,
    required this.dateTime,
    required this.status,
  });
}

class PatientSchedule extends HookConsumerWidget {
  const PatientSchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = useState(DateTime.now());

    // --- DUMMY DATA ---
    final List<_PatientAppointment> appointments = [
      _PatientAppointment(
        title: 'Follow-up Consultation',
        practitionerName: 'Dr. John Doe',
        practitionerAvatarUrl: Assets.images.logo,
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        status: PatientAppointmentStatus.PendingConfirmation,
      ),
      _PatientAppointment(
        title: 'Physical Therapy Session',
        practitionerName: 'Dr. John Doe',
        practitionerAvatarUrl: Assets.images.logo,
        dateTime: DateTime.now().add(const Duration(days: 3)),
        status: PatientAppointmentStatus.Confirmed,
      ),
      _PatientAppointment(
        title: 'Initial Consultation',
        practitionerName: 'Dr. John Doe',
        practitionerAvatarUrl: Assets.images.logo,
        dateTime: DateTime.now().subtract(const Duration(days: 7)),
        status: PatientAppointmentStatus.Completed,
      ),
    ];

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
                  const SizedBox(height: 24),
                  // --- APPOINTMENTS HEADER ---
                  Text(
                    'Appointments for ${DateFormat.yMMMMd().format(selectedDay.value)}',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // --- APPOINTMENTS LIST ---
                  if (appointments.isEmpty)
                    const Center(child: Text('No appointments for this day.'))
                  else
                    ListView.separated(
                      itemCount: appointments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _PatientAppointmentCard(
                          appointment: appointments[index],
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card widget to display a single appointment from the patient's perspective.
class _PatientAppointmentCard extends StatelessWidget {
  const _PatientAppointmentCard({required this.appointment});
  final _PatientAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(8),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        appointment.status == PatientAppointmentStatus.Completed
                        ? Colors.grey
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.jm().format(appointment.dateTime)} - ${appointment.practitionerName}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(
                    appointment.practitionerAvatarUrl,
                  ),
                ),
              ],
            ),
            // --- Conditional Action Buttons ---
            if (appointment.status ==
                PatientAppointmentStatus.PendingConfirmation)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implement logic to request a new timeslot
                        },

                        child: const Text('Request New Timeslot'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement logic to accept the appointment
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
