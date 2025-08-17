import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/models/patient/invite_patient_payload.dart';
import 'package:ayur_scoliosis_management/services/patient/patient_service.dart';
import 'package:dio/dio.dart';

class PatientServiceImpl extends PatientService {
  PatientServiceImpl({required this.api, required this.client});
  final Api api;
  final Dio client;

  @override
  Future<bool> invitePatient(InvitePatientPayload payload) async {
    try {
      final response = await client.post(
        api.invitePatient,
        data: payload.toJson(),
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<AppUser> getPatientDetails(String patientId) async {
    try {
      final response = await client.get(api.patientDetails(patientId));
      return AppUser.fromJson(response.data);
    } on DioException catch (e) {
      throw e.processException();
    }
  }
}
