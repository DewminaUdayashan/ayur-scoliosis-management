import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';

abstract class PatientService {
  Future<bool> invitePatient(InvitePatientPayload payload);
  Future<AppUser> getPatientDetails(String patientId);
}
