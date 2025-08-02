import 'package:ayur_scoliosis_management/widgets/patient_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/size.dart' show radius8;
import '../../../../../../core/extensions/theme.dart';
import '../../../../../../core/theme.dart';

class RecentInstructionCard extends StatelessWidget {
  const RecentInstructionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius8),
      elevation: 0.2,
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius8),
        leading: const PatientProfileAvatar(), // Practitioner's avatar
        title: RichText(
          text: TextSpan(
            text: 'Dr. John Doe',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' left you a new note',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          '5 hours ago',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_forward,
          color: AppTheme.textSecondary,
        ),
        onTap: () {
          // Navigate to the specific note or timeline event
        },
      ),
    );
  }
}
