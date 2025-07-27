import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/size.dart' show radius8;
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primary,
          child: Icon(
            CupertinoIcons.video_camera_solid,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        title: const Text('Video Call with Dr. John Doe'),
        subtitle: Text(
          '10:00 AM - July 28, 2025',
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
          // Navigate to appointment details
        },
      ),
    );
  }
}
