import 'package:ayur_scoliosis_management/core/utils/snacks.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';
import 'package:ayur_scoliosis_management/models/patient/patient.dart';
import 'package:ayur_scoliosis_management/providers/patient/patient_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patients.g.dart';

@riverpod
class Patients extends _$Patients {
  @override
  List<Patient> build() {
    return [];
  }

  Future<void> invitePatient(
    InvitePatientPayload payload, {
    required VoidCallback onSuccess,
    required ValueChanged<String?> onError,
  }) async {
    try {
      await ref.read(patientServiceProvider).invitePatient(payload);
      ref.invalidateSelf();
      showSuccessSnack('Invitation to the ${payload.email} sent successfully!');
      onSuccess();
    } catch (e) {
      onError(e.toString());
      showErrorSnack(e.toString());
    }
  }
}
