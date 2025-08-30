import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';

abstract class PatientService {
  Future<Paginated<AppUser>> getPatients(
    PaginatedRequest request, {
    String? search,
  });
  Future<bool> invitePatient(InvitePatientPayload payload);
  Future<AppUser> getPatientDetails(String patientId);
}
