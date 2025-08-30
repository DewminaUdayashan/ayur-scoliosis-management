import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/constants/size.dart'
    show radius8;
import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:ayur_scoliosis_management/widgets/patient_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../models/appointment/appointment.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: PatientProfileAvatar(url: null),
        title: Text(
          '${appointment.patient?.firstName} ${appointment.patient?.lastName}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(
                  appointment.type == AppointmentType.physical
                      ? CupertinoIcons.briefcase_fill
                      : CupertinoIcons.video_camera_solid,
                  color: AppTheme.textSecondary,
                  size: 12,
                ),
                Text(
                  appointment.type.value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              ' ${appointment.appointmentDateTime.readableTimeAndDate}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Icon(
          CupertinoIcons.chevron_forward,
          color: AppTheme.textSecondary,
        ),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: () => context.push(AppRouter.appointmentDetails(appointment.id)),
      ),
    );
  }
}
