import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/providers/patient/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/skeleton.dart';

class PatientProfileName extends HookConsumerWidget {
  const PatientProfileName({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientDetailsProvider(id));
    return patientAsync.when(
      data: (patient) => Padding(
        padding: const EdgeInsets.only(left: 70),
        child: Text(
          patient.fullName,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      error: (error, _) => Text(
        'Error: $error',
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      loading: () => Skeleton(
        builder: (decorations) =>
            Container(width: 100, height: 20, decoration: decorations),
      ),
    );
  }
}
