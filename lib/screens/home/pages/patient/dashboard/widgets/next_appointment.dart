import 'package:ayur_scoliosis_management/providers/appointment/upcoming_appointments.dart';
import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/constants/size.dart' show radius8;
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';
import 'next_appointment_card.dart';

class NextAppointment extends HookConsumerWidget {
  const NextAppointment({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(upcomingAppointmentsProvider);
    return appointments.when(
      data: (data) {
        if (data.isEmpty) {
          return Card(
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: radius8),
            elevation: 0.2,
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: radius8),
              leading: CircleAvatar(
                backgroundColor: AppTheme.textSecondary.withAlpha(20),
                child: const Icon(
                  CupertinoIcons.calendar,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              title: Text(
                'No upcoming appointments',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              subtitle: Text(
                'Your next appointment will appear here',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          );
        }
        return Column(
          children: data.map((appointment) {
            return NextAppointmentCard(appointment: appointment);
          }).toList(),
        );
      },
      error: (error, stack) => Text('Error: $error'),
      loading: () => Skeleton(
        builder: (decorations) => Container(decoration: decorations),
      ),
    );
  }
}
