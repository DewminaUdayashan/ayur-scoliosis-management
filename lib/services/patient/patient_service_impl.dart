import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated.dart';
import 'package:ayur_scoliosis_management/models/common/paginated/paginated_request.dart';
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

  @override
  Future<Paginated<AppUser>> getPatients(
    PaginatedRequest request, {
    String? search,
  }) async {
    try {
      final response = await client.get(
        api.patients,
        queryParameters: {
          ...request.queryParameters,
          if (search != null) 'search': search,
        },
      );
      return Paginated.fromJson(
        response.data,
        (json) => AppUser.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw e.processException();
    }
  }
}
