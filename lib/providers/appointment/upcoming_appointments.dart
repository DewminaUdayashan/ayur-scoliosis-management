import 'package:ayur_scoliosis_management/models/appointment/appointment.dart';
import 'package:ayur_scoliosis_management/providers/appointment/appointment_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upcoming_appointments.g.dart';

@riverpod
Future<List<Appointment>> upcomingAppointments(Ref ref) {
  return ref.watch(appointmentServiceProvider).upcomingAppointments();
}
