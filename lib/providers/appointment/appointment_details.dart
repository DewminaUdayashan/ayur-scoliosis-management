import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment_details.g.dart';

@riverpod
Future<Appointment> appointmentDetails(Ref ref, String appointmentId) {
  return ref
      .watch(appointmentServiceProvider)
      .appointmentDetails(appointmentId);
}
