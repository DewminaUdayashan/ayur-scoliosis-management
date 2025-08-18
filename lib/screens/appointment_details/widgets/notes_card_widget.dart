import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_details.dart';
import 'package:ayur_scoliosis_management/screens/appointment_details/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme.dart';
import '../../../widgets/skeleton.dart';

class NotesCardWidget extends HookConsumerWidget {
  const NotesCardWidget({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(
      appointmentDetailsProvider(appointmentId),
    );

    return appointmentAsync.when(
      data: (appointment) => InfoCard(
        title: 'Notes',
        children: [
          Text(
            appointment.notes ?? '-',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
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
          'Error loading notes: ${error.toString()}',
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.red),
        ),
      ),
      loading: () => InfoCard(
        title: 'Notes',
        children: [
          Skeleton(
            builder: (decorations) => Container(
              decoration: decorations,
              width: double.infinity,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}
