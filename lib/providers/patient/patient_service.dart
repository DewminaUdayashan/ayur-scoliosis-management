import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/patient/patient_service.dart';
import 'package:ayur_scoliosis_management/services/patient/patient_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_service.g.dart';

@riverpod
PatientService patientService(Ref ref) {
  return PatientServiceImpl(api: Api(), client: ref.watch(dioProvider));
}
