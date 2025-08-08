import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';

abstract class PatientService {
  Future<bool> invitePatient(InvitePatientPayload payload);
}
