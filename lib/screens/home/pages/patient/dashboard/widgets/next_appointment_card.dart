import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/size.dart' show radius8;
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
  });

  final Appointment appointment;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final isRemote = appointment.type == AppointmentType.remote;

    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary,
          child: Icon(
            isRemote
                ? CupertinoIcons.video_camera_solid
                : CupertinoIcons.building_2_fill,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          '${appointment.name} with Dr. ${appointment.practitioner?.firstName}',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${appointment.appointmentDateTime.readableTimeAndDate} • ${appointment.durationInMinutes} min',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (appointment.status == AppointmentStatus.pendingConfirmation)
              Text(
                appointment.status.value,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: appointment.status == AppointmentStatus.scheduled
                      ? Colors.green
                      : Colors.amber.shade900,
                ),
              ),
          ],
        ),
        isThreeLine:
            appointment.status == AppointmentStatus.pendingConfirmation,
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: () => context.push(AppRouter.appointmentDetails(appointment.id)),
      ),
    );
  }
}
