import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/info_card.dart';
import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/info_row.dart';
import 'package:ayur_scoliosis_management/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/appointment/appointment_details.dart';

class DetailsCardWidget extends HookConsumerWidget {
  const DetailsCardWidget({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(
      appointmentDetailsProvider(appointmentId),
    );

    return appointmentAsync.when(
      data: (appointment) => InfoCard(
        title: 'Session Details',
        children: [
          InfoRow(
            icon: CupertinoIcons.calendar,
            label: 'Date',
            value: appointment.appointmentDateTime.yMMMMd,
          ),
          InfoRow(
            icon: CupertinoIcons.clock,
            label: 'Time',
            value: appointment.appointmentDateTime.jm,
          ),
          InfoRow(
            icon: CupertinoIcons.hourglass,
            label: 'Duration',
            value: '${appointment.durationInMinutes} minutes',
          ),
          InfoRow(
            icon: appointment.type == AppointmentType.remote
                ? CupertinoIcons.video_camera_solid
                : CupertinoIcons.building_2_fill,
            label: 'Type',
            value: appointment.type.value,
          ),
          InfoRow(
            icon: CupertinoIcons.check_mark_circled,
            label: 'Status',
            valueWidget: Chip(
              label: Text(
                appointment.status.value,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: appointment.status.textColor,
                ),
              ),
              backgroundColor: appointment.status.backgroundColor,
            ),
          ),
        ],
      ),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Error loading appointment details: ${error.toString()}',
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.red),
        ),
      ),
      loading: () => InfoCard(
        title: 'Session Details',
        children: [
          for (int i = 0; i < 5; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Skeleton(
                    builder: (decorations) => Container(
                      decoration: decorations,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Skeleton(
                    builder: (decorations) => Container(
                      decoration: decorations,
                      width: 60,
                      height: 16,
                    ),
                  ),
                  const Spacer(),
                  Skeleton(
                    builder: (decorations) => Container(
                      decoration: decorations,
                      width: 100,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
