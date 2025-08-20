import 'package:ayur_scoliosis_management/core/extensions/date_time.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/app_router.dart';
import '../../../../../../models/auth/app_user.dart' show AppUser;
import '../../../../../../providers/patient/patient_details.dart';
import '../../../../../../widgets/patient_profile_avatar.dart';

class PatientListTile extends HookConsumerWidget {
  const PatientListTile({super.key, required this.patient});

  final AppUser patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientDetails = ref
        .watch(patientDetailsProvider(patient.id))
        .valueOrNull;
    return ListTile(
      leading: PatientProfileAvatar(url: patient.imageUrl),
      title: Text(patient.firstName),
      // subtitle: Text('Condition: '),
      trailing:
          patientDetails != null && patientDetails.lastAppointmentDate != null
          ? Text('Last Visit: ${patientDetails.lastAppointmentDate?.yMd}')
          : null,
      onTap: () =>
          context.push(AppRouter.patientDetails, extra: {'id': patient.id}),
    );
  }
}
