import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_details.dart';
import 'package:ayur_scoliosis_management/providers/patient/patient_details.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme.dart';
import '../../../widgets/patient_profile_avatar.dart';
import '../../../widgets/skeleton.dart';

class ParticipantInfoWidget extends HookConsumerWidget {
  const ParticipantInfoWidget({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(
      appointmentDetailsProvider(appointmentId),
    );
    final appointment = appointmentAsync.valueOrNull;
    final patient = ref
        .watch(patientDetailsProvider(appointment?.patientId))
        .valueOrNull;

    return appointmentAsync.when(
      data: (appointment) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              PatientProfileAvatar(size: 60, url: appointment.patientId),
              const SizedBox(height: 8),
              Text(
                'Dr. ${appointment.practitioner!.firstName}',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Practitioner',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              CupertinoIcons.arrow_right_arrow_left,
              color: AppTheme.textSecondary,
            ),
          ),
          Column(
            children: [
              PatientProfileAvatar(size: 60, url: patient?.imageUrl),
              const SizedBox(height: 8),
              Text(
                appointment.patient!.firstName,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Patient',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
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
          'Error loading participant info: ${error.toString()}',
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.red),
        ),
      ),
      loading: () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 60, height: 60),
              ),
              const SizedBox(height: 8),
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 80, height: 16),
              ),
              const SizedBox(height: 4),
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 60, height: 12),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              CupertinoIcons.arrow_right_arrow_left,
              color: AppTheme.textSecondary,
            ),
          ),
          Column(
            children: [
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 60, height: 60),
              ),
              const SizedBox(height: 8),
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 80, height: 16),
              ),
              const SizedBox(height: 4),
              Skeleton(
                builder: (decorations) =>
                    Container(decoration: decorations, width: 60, height: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
