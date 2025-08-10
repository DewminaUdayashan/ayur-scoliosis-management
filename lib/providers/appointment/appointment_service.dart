import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/appointment/appointment_service.dart';
import 'package:ayur_scoliosis_management/services/appointment/appointment_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment_service.g.dart';

@riverpod
AppointmentService appointmentService(Ref ref) {
  return AppointmentServiceImpl(api: Api(), client: ref.watch(dioProvider));
}
