import 'package:ayur_scoliosis_management/core/constants/size.dart'
    show radius8;
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: CircleAvatar(),
        title: Text('Patient Name'),
        subtitle: Row(
          spacing: 4,
          children: [
            Icon(
              CupertinoIcons.video_camera_solid,
              color: AppTheme.textSecondary,
              size: 18,
            ),
            Text(
              'Video Call - 10:00 AM',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            // Icon(
            //   CupertinoIcons.briefcase_fill,
            //   color: AppTheme.textSecondary,
            //   size: 18,
            // ),
            // Text(
            //   'In-person - 10:00 AM',
            //   style: context.textTheme.bodyMedium?.copyWith(
            //     color: AppTheme.textSecondary,
            //   ),
            // ),
          ],
        ),
        trailing: Icon(
          CupertinoIcons.chevron_forward,
          color: AppTheme.textSecondary,
        ),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        onTap: () {
          // Navigate to appointment details
        },
      ),
    );
  }
}
