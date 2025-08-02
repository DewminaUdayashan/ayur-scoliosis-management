import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/size.dart' show radius8;
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key, this.isRemote = false});
  final bool isRemote;

  @override
  Widget build(BuildContext context) {
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
          isRemote
              ? 'Video Call with Dr. John Doe'
              : 'In-Person Appointment with Dr. John Doe',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isRemote ? '11:00 AM - July 20, 2025' : '10:00 AM - July 28, 2025',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_forward,
          color: AppTheme.textSecondary,
        ),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: () {
          context.push(
            AppRouter.appointmentDetails,
            extra: {
              'id': '12345', // Example appointment ID
            },
          );
        },
      ),
    );
  }
}
