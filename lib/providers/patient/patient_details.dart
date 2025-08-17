import 'package:ayur_scoliosis_management/providers/patient/patient_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/auth/app_user.dart';

part 'patient_details.g.dart';

@riverpod
Future<AppUser> patientDetails(Ref ref, String patientId) {
  final service = ref.watch(patientServiceProvider);
  return service.getPatientDetails(patientId);
}
